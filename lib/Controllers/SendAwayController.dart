import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SendAwayController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> firstRestaurants = [];
  AlgoliaQuerySnapshot? searchResults;
  bool isSearched = false;
  Map<String, dynamic> selectedRestaurant = {};

  setSelectedRestaurant(
      String restaurantId, String restaurantName, String restaurantPhoto) {
    selectedRestaurant = {
      "restaurantId": restaurantId,
      "restaurantName": restaurantName,
      "restaurantPhoto": restaurantPhoto
    };
    print(selectedRestaurant);
    update();
  }

  setSearchedState(bool state) {
    isSearched = state;
    update();
  }

  @override
  void onInit() {
    getRestaurant();
    super.onInit();
  }

  Future getRestaurant() async {
    QuerySnapshot<Map<String, dynamic>> restaurantQuery =
        await firebaseFirestore.collection("Restaurant").limit(50).get();
    firstRestaurants = restaurantQuery.docs;
    update();
  }

  Timer? searchDelay;
  searchDelayFunction(String queryText) {
    searchDelay = Timer(Duration(seconds: 2), () => searchAlgolia(queryText));
  }

  Future searchAlgolia(String querytext) async {
    isSearched = true;
    update();
    print("searched");
    Algolia algolia = Algolia.init(
        applicationId: "X47Q4IOWZ3",
        apiKey: "8e66460b474ae360303b13ef6f4a5caf");
    AlgoliaQuery query = algolia.instance.index("Restaurants").query(querytext);
    searchResults = await query.getObjects();
    update();
  }

  ///fromtable
  ///
  List<Map<String, dynamic>>? menuList = [];
  double? totalPrice;
  String definePrice() {
    double price = 0.0;
    if (menuList!.isNotEmpty) {
      menuList!.forEach(
        (element) {
          if (element["isDiscount"]) {
            price = price + (element["discountPrice"] * element["amount"]);
          } else {
            price = price + (element["price"] * element["amount"]);
          }
        },
      );
    } else {
      price = 0;
    }
    totalPrice = price;
    return price.toString();
  }

  increaseAmount(Map<String, dynamic> addfood, bool isnew,
      {Map<String, dynamic>? food}) {
    int amount;
    if (isnew) {
      amount = 1;
      //amount = amount + 1;
      Map<String, dynamic>? newFood = addfood;
      newFood.putIfAbsent("amount", () => 1);
      menuList!.add(newFood);
    } else {
      amount = food!["amount"];
      amount = amount + 1;
      menuList!
          .where((element) => element["foodId"] == food["foodId"])
          .first
          .update("amount", (value) => value = amount);
    }

    update();
  }

  decreaseAmount(Map<String, dynamic> food) {
    int amount;
    amount = food["amount"];
    if (amount > 1) {
      amount = amount - 1;
      menuList!
          .where((element) => element["foodId"] == food["foodId"])
          .first
          .update("amount", (value) => value = amount);
    } else if (amount == 1) {
      menuList!.removeWhere((element) => element["foodId"] == food["foodId"]);
    }

    update();
  }

  Future sendAwayfromTable(
      String orderId, int tableNumber, int fromTableNumber) async {
    print(menuList![0]["discountOffTime"]);
    menuList!.forEach((element) {
      Timestamp timestamp = element["discountOffTime"];
      element.update("discountOffTime",
          (value) => value = timestamp.millisecondsSinceEpoch);
    });
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("sendAwayfromTable");
    await httpsCallable.call(<String, dynamic>{
      "orderId": orderId,
      "menuList": menuList,
      "userId": firebaseAuth.currentUser!.uid,
      "tableNumber": tableNumber,
      "fromTableNumber": fromTableNumber
    });
  }
}
