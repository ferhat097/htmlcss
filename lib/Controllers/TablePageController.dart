import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TablePageController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenTables;
  List<DocumentSnapshot<Map<String, dynamic>>> tables = [];
  @override
  void onClose() {
    listenTables?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }

  listenTableinfo(String restaurantId) {
    listenTables = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("tables")
        .snapshots()
        .listen((tableQuery) {
      tables = tableQuery.docs;
      update();
    });
  }

  Color defineTableStatus(bool status) {
    if (status) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
