import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TableMessageController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GetStorage getStorage = GetStorage();
  Stream<QuerySnapshot<Map<String, dynamic>>> loadMessages(
      int tableNumber, String orderId, String restaurantId) async* {
    // String restaurantId = await getStorage.read("restaurantId");
    yield* firebaseFirestore
        .collection("Orders")
        .doc(orderId)
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
  }

  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  Future sendMessage(
      String restaurantId, int tableNumber, String orderId) async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("sendMessagetoTable");
    await httpsCallable.call(<String, dynamic>{
      "from": 3,
      "restaurantId": restaurantId,
      "tableNumber": tableNumber,
      "orderId": orderId,
      "message": messageController.text,
      "userId": firebaseAuth.currentUser!.uid
    });
  }
}
