// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HastagController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> restaurants = [];
  Future getRestaurants(String hastagId) async {
    QuerySnapshot<Map<String, dynamic>> restaurant = await firebaseFirestore
        .collection("Restaurant")
        .where("hastags", arrayContains: hastagId)
        .get();
    restaurants = restaurant.docs;
    update();
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
