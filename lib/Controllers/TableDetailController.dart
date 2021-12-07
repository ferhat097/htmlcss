import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TableDetailController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listeTable;
  DocumentSnapshot<Map<String, dynamic>>? table;
  @override
  void onClose() {
    listeTable?.cancel();
    super.onClose();
  }

  listenTable(String restaurantId, int tableNumber) {
    listeTable = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("tables")
        .doc(tableNumber.toString())
        .snapshots()
        .listen((tableQuery) {
      table = tableQuery;
      update();
    });
  }
}
