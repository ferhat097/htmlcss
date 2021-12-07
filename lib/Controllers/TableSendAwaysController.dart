import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:get/get.dart';

class TableSendAwaysController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    tableSendAwayListen?.cancel();
    super.onClose();
  }

  StreamSubscription? tableSendAwayListen;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> sendAways = [];
  listenTableSendAways(String orderId) {
    tableSendAwayListen = firebaseFirestore
        .collection("Orders")
        .doc(orderId)
        .collection("sendAway")
        .snapshots()
        .listen((sendAwaysQuery) {
      sendAways = sendAwaysQuery.docs;
      update();
    });
  }

  Future acceptSendAway(String orderId, String sendAwayId) async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("acceptTableSendAway");
    await httpsCallable
        .call(<String, dynamic>{"orderId": orderId, "sendAwayId": sendAwayId});
    update();
  }
}
