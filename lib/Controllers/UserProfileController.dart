// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Models/PresenceModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserProfileController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  StreamSubscription? userSocialListen;
  Map<String, dynamic>? userSocial;
  List<DocumentSnapshot<Map<String, dynamic>>> images = [];
  PresenceModel? presenceModel;
  @override
  void onClose() {
    userSocialListen?.cancel();
    userPresenceSubs?.cancel();
    super.onClose();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
  //
  Future getUserImages(String userId) async {
    QuerySnapshot<Map<String, dynamic>> imagesQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(userId)
        .collection("photos")
        .orderBy("sharedDate", descending: true)
        .get();
    images = imagesQuery.docs;
    update();
  }

  listenUserSocialInfo(String userId) {
    userSocialListen = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(userId)
        .snapshots()
        .listen((social) {
      userSocial = social.data();
      update();
    });
  }

  Color defineCircularColor(bool showOnline, bool isPremium, bool? online) {
    if (showOnline) {
      if (online ?? false) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      if (isPremium) {
        return const Color(0xFFe1ad21);
      } else {
        return Colors.blue[900]!;
      }
    }
  }

  Future<void> onRefresh() async {}

  GetStorage getStorage = GetStorage();

  Future like(String userId) async {
    String meId = await getStorage.read("userUid");
    DocumentReference userReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    DocumentReference meReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(meId);
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.update(userReference, {
        "likerUsers": FieldValue.arrayUnion([meId]),
        "likerTime": FieldValue.increment(1),
      });
      transaction.update(meReference, {
        "likedUsers": FieldValue.arrayUnion([userId]),
        "likedTime": FieldValue.increment(1),
        "seenUsers": FieldValue.arrayUnion([userId]),
      });
    });
  }

  Future dislike(String userId) async {
    String meId = await getStorage.read("userUid");
    DocumentReference userReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    DocumentReference meReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(meId);
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.update(userReference, {
        "likerUsers": FieldValue.arrayRemove([meId]),
        "likerTime": FieldValue.increment(-1),
      });
      transaction.update(meReference, {
        "likedUsers": FieldValue.arrayRemove([userId]),
        "likedTime": FieldValue.increment(-1),
        "seenUsers": FieldValue.arrayUnion([userId]),
      });
    });
  }

  bool checkMessage(
      bool? isMeFoodMoodSocial,
      bool? isUserFoodMoodSocial,
      bool? meIsRestaurant,
      bool? userIsRestaurant,
      String? meRestaurantId,
      String? userRestaurantId) {
    return true;
    // if (isMeFoodMoodSocial! &&
    //     meIsRestaurant! &&
    //     userIsRestaurant! &&
    //     isUserFoodMoodSocial!) {
    //   if (userRestaurantId! == meRestaurantId!) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   return false;
    // }
  }

  bool checksendaway(
    bool? isMeFoodMoodSocial,
    bool? isUserFoodMoodSocial,
    bool? meissendaway,
    bool? userissendaway,
  ) {
    if (isMeFoodMoodSocial! &&
        isUserFoodMoodSocial! &&
        meissendaway! &&
        userissendaway!) {
      return true;
    } else {
      return false;
    }
  }

  StreamSubscription? userPresenceSubs;

  listenPrensence(String userId) {
    FirebaseDatabase firebasePresence = FirebaseDatabase(
        databaseURL: "https://foodmood-presence.firebaseio.com/");
    userPresenceSubs = firebasePresence
        .reference()
        .child("/$userId")
        .onValue
        .listen((userPresenceQuery) {
      if (userPresenceQuery.snapshot.exists) {
        //userPresence = jsonDecode(userPresenceQuery.snapshot.toString());
        //userOnline = userPresenceQuery.snapshot.value["online"];
        presenceModel = PresenceModel(
          online: userPresenceQuery.snapshot.value["online"] ?? false,
          date: userPresenceQuery.snapshot.value["date"] ?? "",
        );
      }
      print(presenceModel!.online);
      update();
    });
  }
}
