import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MySendAwayController extends GetxController {
  @override
  void onInit() {
    getFromMeSendAway();
    getToMeSendAway();
    super.onInit();
  }

  @override
  void onClose() {
    listenToMeSendAway?.cancel();
    listenFromMeSendAway?.cancel();
    super.onClose();
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenToMeSendAway;
  StreamSubscription? listenFromMeSendAway;
  List<DocumentSnapshot<Map<String, dynamic>>> sendAwayMe = [];
  List<DocumentSnapshot<Map<String, dynamic>>> sendAwayFromMe = [];
  Future getToMeSendAway() async {
    listenToMeSendAway = firebaseFirestore
        .collection("SendAway")
        .orderBy("sendedDate", descending: true)
        .where("sendAwayToId", isEqualTo: firebaseAuth.currentUser!.uid)
        .where("used", isEqualTo: false)
        .snapshots()
        .listen((sendAwayMeQuery) {
      sendAwayMe = sendAwayMeQuery.docs;
      update();
    });
  }

  Future getFromMeSendAway() async {
    listenFromMeSendAway = firebaseFirestore
        .collection("SendAway")
        .orderBy("sendedDate", descending: true)
        .where("sendAwayFromId", isEqualTo: firebaseAuth.currentUser!.uid)
        .where("used", isEqualTo: false)
        .snapshots()
        .listen((sendAwayFromMeQuery) {
      sendAwayFromMe = sendAwayFromMeQuery.docs;
      update();
    });
  }
}
