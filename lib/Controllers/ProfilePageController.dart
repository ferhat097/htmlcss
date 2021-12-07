// ignore: file_names
// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/HomeController.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  StreamSubscription? userListen;
  StreamSubscription? userSocialListen;
  StreamSubscription? blockedMoodxListen;
  List<Map<String, dynamic>> seen = [];
  List<Map<String, dynamic>> blockedMoodx = [];
  DocumentSnapshot<Map<String, dynamic>>? meSocial;
  List<DocumentSnapshot<Map<String, dynamic>>> images = [];
  @override
  void onClose() {
    userListen?.cancel();
    userSocialListen?.cancel();
    blockedMoodxListen?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    //listenUser();
    getUserImages();
    listenMeSocialInfo();
    //listeBlockedMoodx();
    super.onInit();
  }

  // listenUser() {
  //   userListen = firebaseFirestore
  //       .collection("FoodMoodSocial")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("seen")
  //       .snapshots()
  //       .listen((userQuery) {
  //     seen.clear();
  //     for (var user in userQuery.docs) {
  //       seen.add(user.data());
  //     }
  //     update(["seen"]);
  //   });
  // }

  listeBlockedMoodx() {
    blockedMoodxListen = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("blockedMoodx")
        .where("blockedDate", isGreaterThan: DateTime.now())
        .snapshots()
        .listen((blockedQuery) {
      blockedMoodx.clear();
      for (var block in blockedQuery.docs) {
        blockedMoodx.add(block.data());
      }
      update(["blockedMoodx"]);
    });
  }

  Future getUserImages() async {
    QuerySnapshot<Map<String, dynamic>> imagesQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("photos")
        .orderBy("sharedDate", descending: true)
        .get();
    images = imagesQuery.docs;
    print("bu sekil uzunluqudur ${images.length}");
    update();
  }

  List<dynamic> followedRestaurant = [];

  HomeController homeController = Get.find();
  bool firstMeSocialInit = true;

  listenMeSocialInfo() {
    userSocialListen = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((meSocialQuery) {
      meSocial = meSocialQuery;
      update(["foodmoodsocial"]);
      update(["messageDetailPage"]);
      update(["resultPage"]);
      followedRestaurant = meSocialQuery.data()!["followedRestaurant"] ?? [];
      if (firstMeSocialInit) {
        homeController.getuserStatistic(
          true,
          meSocialQuery.data()!["discounts"] ?? [],
          meSocialQuery.data()!["restaurants"] ?? [],
          meSocialQuery.data()!["followedRestaurant"] ?? [],
        );
      }
      firstMeSocialInit = false;
      update();
    });
  }

  Future<void> onRefresh() async {}

  bool deletedLoading = false;

  Future deleteImage(String imageId) async {
    deletedLoading = true;
    update();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(userId)
        .collection("photos")
        .doc(imageId)
        .delete();
    deletedLoading = false;
    update();
    getUserImages();
  }
}
