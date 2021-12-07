// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MenuPageController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  QuerySnapshot<Map<String, dynamic>>? category;
  Map<Map<String, dynamic>, List> menus = {};
  List<Map<String, dynamic>> allMenu = [];
  List<Map<String, dynamic>> searcedMenu = [];
  StreamSubscription? streamMenu;
  //GetStorage getStorage = GetStorage();
  bool state = true;
  List categoryorders = [];

  searchFood(String searchtext) {
    searcedMenu.clear();
    allMenu.forEach((element) {
      String name = element["name"];
      if (name.isCaseInsensitiveContainsAny(searchtext)) {
        searcedMenu.add(element);
      }
    });
    update();
  }

  changeCategoryList(int old, int neww, dynamic element) async {
    categoryorders.removeAt(old);
    categoryorders.insert(neww, element);
    update();
  }

  @override
  onInit() {
    super.onInit();
  }

  @override
  onClose() {
    streamMenu?.cancel();
    tableListen?.cancel();
    super.onClose();
  }

  Future getCategory(String restaurantId) async {
    category = await firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection('category')
        .orderBy("order")
        .get();
    categoryorders.clear();
    category!.docs.forEach((element) {
      categoryorders.add(element);
    });
    print(categoryorders.first);
    print("bu kateqoridir");

    update();
  }

  getMenu(String restaurantId) async {
    // String restaurantId = await getStorage.read("restaurantId");
    streamMenu = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection('menu')
        .snapshots()
        .listen((menu) async {
      allMenu.clear();
      menu.docs.forEach((element) {
        allMenu.add(element.data());
      });
      await getCategory(restaurantId);
      menus.clear();
      category!.docs.forEach((category) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> singleCategory = menu
            .docs
            .where((menu) =>
                menu.data()['categoryId'] == category.data()['categoryId'])
            .toList();
        menus.putIfAbsent({
          "categoryId": category.data()["categoryId"],
          "categoryName": category.data()["categoryName"],
          "categoryUid": category.id
        }, () => singleCategory);
      });
      print("updated");

      update();
    });

    print(menus.entries);
  }

  TextEditingController deleteCategoryPasswordController =
      TextEditingController();
  //check
  StreamSubscription? tableListen;
  bool? busy;
  String? orderId;
  checkTable(String restaurantId, int tableNumber) {
    tableListen = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("tables")
        .doc(tableNumber.toString())
        .snapshots()
        .listen(
      (table) {
        busy = table.data()!["busy"];
        if (busy!) {
          orderId = table.data()!["orderId"];
        }
        update();
      },
    );
  }

  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();

  Widget defineFoodImage(String? foodImage, int categoryId) {
    if (foodImage != null && foodImage.isNotEmpty) {
      return Image.network(
        foodImage,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    } else {
      return Image.network(
        firebaseRemoteConfigController.menuCategory.entries
            .where((element) => element.value["categoryId"] == categoryId)
            .first
            .value["categoryPhoto"],
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    }
  }

  TextEditingController orderPassword = TextEditingController();

  Future<Map<String, dynamic>> checkOrderCodePassword(
      String password, int tableNumber, String restaurantId) async {
    int pass = int.parse(password);
    print("ok");
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("checkOrderPassword");
    HttpsCallableResult orderId = await httpsCallable.call(<String, dynamic>{
      "password": pass,
      "tableNumber": tableNumber,
      "restaurantId": restaurantId
    });
    print("ok");
    update();
    return orderId.data;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getRestaurant(
  //     String restaurantId) async {
  //   return await firebaseFirestore
  //       .collection("Restaurant")
  //       .doc(restaurantId)
  //       .get();
  // }
}
