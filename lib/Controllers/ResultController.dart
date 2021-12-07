// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ResultController extends GetxController {
  Timer? timer;
  @override
  void onInit() {
    // getMostPopular();
    listenFoodMoodPromotion();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      update(["time"]);
    });
    super.onInit();
  }

  @override
  void onClose() {
    listenPromotion?.cancel();
    timer?.cancel();
    super.onClose();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenPromotion;
  ProfilePageController profilePageController = Get.find();
  List<Map<String, dynamic>> mostPopular = [];
  List<Map<String, dynamic>> promotion = [];
  bool loadingMostPopular = false;
  bool firstInit = true;

  Future getMostPopular() async {
    loadingMostPopular = true;
    update();
    int mysex = profilePageController.meSocial!.data()!["sex"] ?? 1;
    int sex;
    if (mysex == 1) {
      sex = 2;
    } else {
      sex = 1;
    }
    QuerySnapshot<Map<String, dynamic>> mostPopularQuery =
        await firebaseFirestore
            .collection("FoodMoodSocial")
            .orderBy("likedTime")
            // .orderBy("premiumDate", descending: true)
            .where("premium", isEqualTo: true)
            .where("sex", isEqualTo: sex)
            .limit(20)
            .get();
    print("${mostPopularQuery.docs.length} gettedMostPopular lenfid");
    mostPopular.clear();
    for (var pop in mostPopularQuery.docs) {
      mostPopular.add(pop.data());
    }
    loadingMostPopular = false;
    firstInit = false;
    update();
  }

  listenFoodMoodPromotion() {
    listenPromotion = firebaseFirestore
        .collection("Promotion")
        .orderBy("fromFoodMood", descending: true)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((promotionQuery) {
      promotion.clear();
      for (var singlepromotion in promotionQuery.docs) {
        promotion.add(singlepromotion.data());
      }
      print(promotion.length);
      update();
    });
  }

  Future<Map<String, dynamic>> getJoinedInfo(String promotionId) async {
    QuerySnapshot<Map<String, dynamic>> query = await firebaseFirestore
        .collection("Promotion")
        .doc(promotionId)
        .collection("joinedUsers")
        .where("users", arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    return query.docs.first.data();
  }

  Color defineStartedColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  String defineEndedTime(Timestamp timestamp) {
    DateTime endedTime = timestamp.toDate();
    DateTime nowTime = DateTime.now();
    Duration deference = endedTime.difference(nowTime).abs();
    int days = deference.inDays;

    if (deference.inDays > 0) {
      int hours = deference.inHours - (deference.inDays * 24);
      int minutes = deference.inMinutes - (deference.inHours * 60);
      return "$days gün, $hours saat, $minutes dəqiqə";
    } else {
      int hours = deference.inHours - (deference.inDays * 24);
      int minutes = deference.inMinutes - (deference.inHours * 60);
      int seconds = deference.inSeconds - (deference.inMinutes * 60);
      return "$hours saat, $minutes dəqiqə, $seconds saniyə";
    }
  }

  Future<AdWidget> loadAds() async {
    String adId;
    if (Platform.isIOS) {
      adId = 'ca-app-pub-9770261708355804/9620188852';
    } else {
      adId = "ca-app-pub-9770261708355804/4855442171";
    }
    BannerAd banner = BannerAd(
      adUnitId: adId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print("ok");
          print(ad.adUnitId);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // ad.dispose();
          // print(error);
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );

    await banner.load();
    AdWidget adWidget = AdWidget(ad: banner);

    return adWidget;
  }
}
