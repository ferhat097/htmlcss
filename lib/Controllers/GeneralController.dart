// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GeneralController extends GetxController {
  StreamSubscription? generalListen;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> general = [];
  Map<String, dynamic> financial = {};
  Map<String, dynamic> foodSocial = {};
  Map<String, dynamic> adControll = {};
  @override
  void onInit() {
    listenGeneral();
    super.onInit();
  }

  @override
  void onClose() {
    generalListen?.cancel();
    super.onClose();
  }

  listenGeneral() {
    generalListen = firebaseFirestore.collection("General").snapshots().listen(
      (bigQuery) {
        general.clear();
        for (var doc in bigQuery.docs) {
          general.add(doc.data());
          if (doc.id == "financial") {
            financial = doc.data();
            update(["generalfinancial"]);
          }
          if (doc.id == "foodSocial") {
            foodSocial = doc.data();
            update(["generalfoodsocial"]);
          }
          if (doc.id == "adControll") {
            adControll = doc.data();
            update(["generaladControll"]);
          }
        }
        update();
      },
    );
  }

  Future getGeneral() async {
    QuerySnapshot<Map<String, dynamic>> generalQuery =
        await firebaseFirestore.collection("General").get();
    general.clear();
    for (var doc in generalQuery.docs) {
      general.add(doc.data());
      if (doc.id == "financial") {
        financial = doc.data();
        //update(["generalfinancial"]);
      }
      if (doc.id == "foodSocial") {
        foodSocial = doc.data();
        //update(["generalfoodsocial"]);
      }
      if (doc.id == "adControll") {
        adControll = doc.data();
        //update(["generaladControll"]);
      }
    }
  }
}
