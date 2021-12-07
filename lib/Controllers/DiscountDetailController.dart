import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DiscountDetailController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenDiscount;
  DocumentSnapshot<Map<String, dynamic>>? discount;
  List<Map<String, dynamic>> foods = [];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    listenDiscount?.cancel();
    super.onClose();
  }

  listenDiscountQuery(String discountId) {
    listenDiscount = firebaseFirestore
        .collection("Discounts")
        .doc(discountId)
        .snapshots()
        .listen((discountDocument) {
      discount = discountDocument;
      if (discountDocument.data()!["menutype"] == 2) {
        getDiscountFoods(discountId);
      }
      update();
    });
  }

  Future getDiscountFoods(String discountId) async {
    foods.clear();
    QuerySnapshot<Map<String, dynamic>> foodQuery = await firebaseFirestore
        .collection("Discounts")
        .doc(discountId)
        .collection("foods")
        .get();
    foodQuery.docs.forEach((food) {
      foods.add(food.data());
    });
    print(foodQuery);
    update();
  }

  String defineEndTime() {
    return "";
  }
}
