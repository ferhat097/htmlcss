import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class CouponsController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription? listenCoupons;
  List<DocumentSnapshot<Map<String, dynamic>>> coupons = [];
  @override
  void onClose() {
    listenCoupons?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    listenUserCoupons();
    //print(randomString(10));
    super.onInit();
  }

  listenUserCoupons() {
    listenCoupons = firebaseFirestore
        .collection("Coupons")
        .where("userId", isEqualTo: firebaseAuth.currentUser!.uid)
        .where("used", isEqualTo: false)
        .where("accepted", isEqualTo: true)
        .snapshots()
        .listen((couponsQuery) {
      coupons = couponsQuery.docs;
      update();
    });
  }

  getRestaurantCoupon(){
    
  }
}
