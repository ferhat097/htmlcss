// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MessageController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenMessages;
  GetStorage getStorage = GetStorage();
  List<DocumentSnapshot<Map<String, dynamic>>> conversations = [];
  List<Map<String, dynamic>> matched = [];
  @override
  void onClose() {
    listenMessages?.cancel();

    super.onClose();
  }

  @override
  void onInit() {
    getMatched();
    listenMessageQuery();
    super.onInit();
  }

  listenMessageQuery() async {
    String userId = await getStorage.read("userUid");
    listenMessages = firebaseFirestore
        .collection("Conversation")
        .where("users", arrayContains: userId)
        .where("archive", isEqualTo: false)
        .where("deleted", isEqualTo: false)
        .orderBy("lastMessageDate", descending: true)
        .snapshots()
        .listen((conversationQuery) {
      conversations = conversationQuery.docs;
      update(["messages"]);
    });
  }

  Future getMatched() async {
    matched.clear();
    String userId = await getStorage.read("userUid");
    QuerySnapshot<Map<String, dynamic>> matchedQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(userId)
        .collection("matched")
        .orderBy("date", descending: true)
        .get();
    for (var matcheduser in matchedQuery.docs) {
      matched.add(matcheduser.data());
    }
    update();
    update(["messages"]);
  }
}
