import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TableSocialController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GetStorage getStorage = GetStorage();
  StreamSubscription? listenSocial;
  StreamSubscription? listenMeSocial;
  List<DocumentSnapshot<Map<String, dynamic>>> tableSocials = [];
  DocumentSnapshot<Map<String, dynamic>>? me;
  RxBool activeTableSocial = false.obs;
  @override
  void onClose() {
    listenSocial?.cancel();
    listenMeSocial?.cancel();
    super.onClose();
  }

  meSocialListen(String restaurantId) {
    listenMeSocial = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("foodmoodsocial")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((meSocialQuery) {
      me = meSocialQuery;
      tableSocial = me!.data()!["tableSocial"];
      update();
    });
  }

  listenSocialUser(String restaurantId) {
    listenSocial = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("foodmoodsocial")
        .where("foodmoodsocial", isEqualTo: true)
        .where("active", isEqualTo: true)
        .where("tableSocial", isEqualTo: true)
        .where("userId", isNotEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((tableSocialQuery) {
      if (tableSocialQuery.docs.isNotEmpty) {
        tableSocials = tableSocialQuery.docs;
      }
      update();
    });
  }

  Future changeFoodMoodStatus(bool status, String restaurantId) async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("changeOrderSocial");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "status": status,
      "restaurantId": restaurantId,
      "userId": FirebaseAuth.instance.currentUser!.uid
    });
    if (result.data) {
      listenSocialUser(restaurantId);
      listenSocial?.resume();
    } else {
      listenSocial?.pause();
    }
  }

  bool tableSocial = false;

  changeTableSocial(bool newValue, String restaurantId) async {
    tableSocial = newValue;
    update();
    await changeFoodMoodStatus(newValue, restaurantId);
    update();
  }
}
