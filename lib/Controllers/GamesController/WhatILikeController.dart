// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';

class WhatILikeController extends GetxController {
  List selectedFoods = [];
  List selectedDrinks = [];
  int timeRemaining = 99;
  Timer? timer;
  @override
  void onInit() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        timeRemaining = timeRemaining - 1;
        update();
      } else {
        Get.back();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void selectDrink(int foodId) {
    if (selectedDrinks.contains(foodId)) {
      selectedDrinks.remove(foodId);
    } else {
      selectedDrinks.add(foodId);
    }
    update();
  }

  void selectFood(int foodId) {
    if (selectedFoods.contains(foodId)) {
      selectedFoods.remove(foodId);
    } else {
      selectedFoods.add(foodId);
    }
    update();
  }

  GeneralController generalController = Get.find();
  ProfilePageController profilePageController = Get.find();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future sendInvitation(int totalMoodx, String userId, String toName,
      String toPhoto, String toToken) async {
    int needForJoin = totalMoodx ~/ 2;
    int foodMoodCommissionPercentage =
        generalController.financial["foodMoodCommissionForGame"];
    int commission = (totalMoodx * foodMoodCommissionPercentage ~/ 100);
    int earnedWithCommission = totalMoodx - commission;
    DateTime blockedEndDate = DateTime.now().add(const Duration(seconds: 60));
    Timestamp blctmstmp =
        profilePageController.meSocial!.data()!["blockedEndDate"] ??
            Timestamp.now();
    DateTime lastBlockedDate = blctmstmp.toDate();
    int moodx = profilePageController.meSocial!.data()!["moodx"];
    int blocked = profilePageController.meSocial!.data()!["blockedMoodx"];
    int usable = moodx - blocked;
    DocumentReference gameReference =
        firebaseFirestore.collection("GameInvitation").doc();
    DocumentReference meReference = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(firebaseAuth.currentUser!.uid);
    CollectionReference<Map<String, dynamic>> blockedReference =
        firebaseFirestore
            .collection("FoodMoodSocial")
            .doc(firebaseAuth.currentUser!.uid)
            .collection("blockedMoodx");
    await firebaseFirestore.runTransaction((transaction) async {
      // await transaction.get(blockedReference);

      transaction.set(gameReference, {
        "gameType": 1,
        "gameName": "Mən nə sevirəm?",
        "gameDuration": 60,
        "totalEarnMoodxWithoutCommission": totalMoodx,
        "totalEarnMoodxWithCommission": earnedWithCommission,
        "commission": commission,
        "needForJoinMoodx": needForJoin,
        "foodMoodCommissionPercentage": foodMoodCommissionPercentage,
        "from": firebaseAuth.currentUser!.uid,
        "fromName": profilePageController.meSocial!.data()!["name"],
        "fromPhoto": profilePageController.meSocial!.data()!["userPhoto"],
        "fromToken": profilePageController.meSocial!.data()!["token"],
        "to": userId,
        "toName": toName,
        "toPhoto": toPhoto,
        "toToken": toToken,
        "sendedDate": DateTime.now(),
        "endedDate": DateTime.now().add(const Duration(seconds: 60)),
        "accepted": false,
        "rejected": false,
        "rejectedFromSender": false,
      });
      transaction.update(meReference, {
        "blockedMoodx": FieldValue.increment(needForJoin),
        // "blockedEndDate"
      });
    });
  }
}
