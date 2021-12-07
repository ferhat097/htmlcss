// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class AddFoodController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>>? menuList = [];
  double? totalPrice;
  addFoodtoList(Map<String, dynamic> food) {
    Map<String, dynamic>? newFood = food;
    newFood.putIfAbsent("amount", () => 1);
    menuList!.add(newFood);
    update();
  }

  deleteFoodfromList(Map<String, dynamic> food) {
    menuList!.removeWhere((element) => element["foodId"] == food["foodId"]);
    update();
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

  String definePrice() {
    double price = 0.0;
    if (menuList!.isNotEmpty) {
      for (var element in menuList!) {
        if (element["isDiscount"]) {
          price = price + (element["discountPrice"] * element["amount"]);
        } else {
          price = price + (element["price"] * element["amount"]);
        }
      }
    } else {
      price = 0;
    }
    totalPrice = price;
    return price.toString();
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  GetStorage getStorage = GetStorage();
  Future addFood(int tableNumber, String orderId, String restaurantId,
      String userName) async {
    print(tableNumber);
    print(orderId);
    List<Map<String, dynamic>> menus = [];
    menuList!.forEach((element) {
      element.removeWhere((key, value) => key == "discountOffTime");
      element.removeWhere((key, value) => key == "foodCreatedTime");
      menus.add(element);
    });
    //String restaurantId = await getStorage.read("restaurantId");
    // print(restaurantId);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("addFoodtoTable");
    await httpsCallable.call(
      <String, dynamic>{
        "restaurantId": restaurantId,
        "tableNumber": tableNumber,
        "orderId": orderId,
        "menuList": menus,
        "from": 3,
        "fromId": firebaseAuth.currentUser!.uid,
        "fromName": userName
      },
    );
  }
}
