// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GameRequestController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription? listenGames;
  List<Map<String, dynamic>> games = [];
  @override
  void onInit() {
    listenQuery();
    super.onInit();
  }

  @override
  void onClose() {
    listenGames?.cancel();
    super.onClose();
  }

  listenQuery() {
    listenGames = firebaseFirestore
        .collection("GameInvitation")
        .where("toUser", isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .listen((gameQuery) {
      games.clear();
      for (var game in gameQuery.docs) {
        games.add(game.data());
      }
      update();
    });
  }
}
