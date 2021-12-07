// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Screens/Common/Order/OrderPage.dart';
import 'package:foodmood/Screens/FoodMoodSocial/FoodMoodSocial.dart';
import 'package:foodmood/Screens/Home/Home.dart';
import 'package:foodmood/Screens/LoginNeeded.dart';
import 'package:foodmood/Screens/Profile/ProfilePage.dart';
import 'package:foodmood/Screens/Search/Search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? orderListen;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GetStorage getStorage = GetStorage();
  bool orderExist = false;
  DocumentSnapshot<Map<String, dynamic>>? activeOrder;
  @override
  void onClose() {
    orderListen?.cancel();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    // listenOrderStatus();
    // QuerySnapshot<Map<String, dynamic>> order = await firebaseFirestore
    //     .collection("Orders")
    //     .orderBy("orderCreatedDate", descending: true)
    //     .where("active", isEqualTo: true)
    //     .where("userList", arrayContains: firebaseAuth.currentUser!.uid)
    //     .get();
    // if (order.docs.isNotEmpty) {
    //   if (order.docs.first.exists) {
    //     await getStorage.write("orderExist", true);
    //     orderExist = true;
    //     // print(" MAIN CONTROLLER ${activeOrder!.data()!["orderId"]}");
    //     // print(" MAIN CONTROLLER ${activeOrder!.data()!["restaurantId"]}");
    //     // print(" MAIN CONTROLLER ${activeOrder!.data()!["tableNumber"]}");
    //     Get.to(
    //       () => OrderPage(
    //         orderId: order.docs.first.data()["orderId"],
    //         createOrder: false,
    //         needJoin: false,
    //         restaurantId: order.docs.first.data()["restaurantId"],
    //         tableNumber: order.docs.first.data()["tableNumber"],
    //       ),
    //     );
    //   }
    // } else {
    //   await getStorage.write("orderExist", false);
    //   orderExist = false;
    // }
    // print(orderExist);
    // super.onInit();
  }

  // listenOrderStatus() {
  //   orderListen = firebaseFirestore
  //       .collection("Orders")
  //       .orderBy("orderCreatedDate", descending: true)
  //       .where("active", isEqualTo: true)
  //       .where("userList", arrayContains: firebaseAuth.currentUser!.uid)
  //       .snapshots()
  //       .listen((order) {
  //     if (order.docs.isNotEmpty) {
  //       if (order.docs.first.exists) {
  //         orderExist = order.docs.isNotEmpty;
  //         order.docs.sort(
  //           (a, b) => a
  //               .data()["orderCreatedDate"]
  //               .compareTo(b.data()["orderCreatedDate"]),
  //         );
  //         activeOrder = order.docs.first;
  //         update(["orderbutton"]);
  //       }
  //     } else {
  //       orderExist = false;
  //       update(["orderbutton"]);
  //     }
  //   });
  // }

  List<Widget> setPages(isAnonymous) {
    if (isAnonymous) {
      return [
        Home(
          isAnonym: true,
        ),
        Search(),
        LoginNeeded(),
        LoginNeeded()
      ];
    } else {
      return [
        Home(
          isAnonym: false,
        ),
        Search(),
        FoodMoodSocial(),
        ProfilePage()
      ];
    }
  }

  int page = 0;
  changePage(int newpage) {
    page = newpage;
    update(["pages"]);
  }

  changeTheme() {
    Get.isDarkMode
        ? Get.changeThemeMode(ThemeMode.light)
        : Get.changeThemeMode(ThemeMode.dark);
  }
}
