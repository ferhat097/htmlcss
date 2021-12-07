// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Profile/ProfilePage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeController extends GetxController {
  @override
  void onClose() {
    listenFoodMoodDiscount?.cancel();
    // listenFollowedRestaurantDiscount?.cancel();
    // listenForYouDiscount?.cancel();
    listenFoods?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    listenFood();
    super.onInit();
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodDiscounts = [];
  List<DocumentSnapshot<Map<String, dynamic>>> followedRestaurantDiscounts = [];
  List<DocumentSnapshot<Map<String, dynamic>>> forYouDiscounts = [];
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodRestaurant = [];
  List<DocumentSnapshot<Map<String, dynamic>>> hastags = [];
  List<DocumentSnapshot<Map<String, dynamic>>> foods = [];
  List<DocumentSnapshot<Map<String, dynamic>>> popularFoods = [];
  StreamSubscription? listenFoodMoodDiscount;
  // StreamSubscription? listenFollowedRestaurantDiscount;
  // StreamSubscription? listenForYouDiscount;
  StreamSubscription? listenFoods;
  GetStorage getStorage = GetStorage();

  bool loadingwhereIGoToday = false;
  Future<Map<String, dynamic>> whereIGoToday() async {
    loadingwhereIGoToday = true;
    update(["hastags"]);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("whereigotoday");
    HttpsCallableResult result = await httpsCallable.call();
    String restaurantId = result.data;
    DocumentSnapshot<Map<String, dynamic>> restaurant = await firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .get();
    loadingwhereIGoToday = false;
    update(["hastags"]);
    return restaurant.data()!;
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future getuserStatistic(bool fromProfile, List discountList,
      List restaurantList, List followedRestaurant) async {
    if (firebaseAuth.currentUser != null &&
        !firebaseAuth.currentUser!.isAnonymous &&
        fromProfile) {
      if (discountList.length < 3) {
        await getDefaultFoodMoodDiscount();
      } else {
        await getSpecialFoodMoodDiscount(discountList);
      }
      if (restaurantList.length < 3) {
        await getDefaultFoodMoodRestaurant();
      } else {
        await getSpecialFoodMoodRestaurant(restaurantList);
      }
      await getMostPopularFoods();
      // if (followedRestaurant.isNotEmpty) {
      //   await getFoodMoodFollowedDiscount(followedRestaurant);
      // }
    } else {
      await getMostPopularFoods();
      await getDefaultFoodMoodRestaurant();
      await getDefaultFoodMoodDiscount();
    }
    //await getForYouDiscount();
    await getHastags();
  }

  getDefaultFoodMoodDiscount() {
    listenFoodMoodDiscount = firebaseFirestore
        .collection("Discounts")
        .where("active", isEqualTo: true)
        .where("isFoodMoodSelection", isEqualTo: true)
        .snapshots()
        .listen((discount) {
      foodMoodDiscounts = discount.docs;
      update(["foodMoodDiscount"]);
    });
  }

  getSpecialFoodMoodDiscount(List discounList) {
    listenFoodMoodDiscount = firebaseFirestore
        .collection("Discounts")
        .where("dicountId", whereIn: discounList)
        .snapshots()
        .listen(
      (discount) {
        foodMoodDiscounts = discount.docs;
        update(["foodMoodDiscount"]);
      },
    );
  }

  Future getMostPopularFoods() async {
    QuerySnapshot<Map<String, dynamic>> popularFoodsQuery =
        await firebaseFirestore
            .collection("Foods")
            .orderBy("like", descending: true)
            .limit(20)
            .get();
    popularFoods.clear();
    for (var popularFood in popularFoodsQuery.docs) {
      popularFoods.add(popularFood);
    }
    update(["popularFood"]);
  }

  // getFoodMoodFollowedDiscount(List followedRestaurant) {
  //   listenFollowedRestaurantDiscount = firebaseFirestore
  //       .collection("Discounts")
  //       .where("discountId", whereIn: followedRestaurant)
  //       .snapshots()
  //       .listen(
  //     (discount) {
  //       followedRestaurantDiscounts = discount.docs;
  //       update(["followedDiscount"]);
  //     },
  //   );
  // }

  // getForYouDiscount() {
  //   listenForYouDiscount = firebaseFirestore
  //       .collection("Discounts")
  //       .orderBy("createdDate", descending: true)
  //       .where("active", isEqualTo: true)
  //       .snapshots()
  //       .listen((discount) {
  //     forYouDiscounts = discount.docs;
  //     update(["discountForYou"]);
  //   });
  // }

  Future getDefaultFoodMoodRestaurant() async {
    QuerySnapshot<Map<String, dynamic>> foodMoodRestaurantQuery;
    foodMoodRestaurantQuery = await firebaseFirestore
        .collection("Restaurant")
        .where("isFoodMoodSelection", isEqualTo: true)
        .where("active", isEqualTo: true)
        .get();
    foodMoodRestaurant = foodMoodRestaurantQuery.docs;
    update(["foodMoodRestaurant"]);
  }

  Future getSpecialFoodMoodRestaurant(List restaurantId) async {
    QuerySnapshot<Map<String, dynamic>> foodMoodRestaurantQuery;
    foodMoodRestaurantQuery = await firebaseFirestore
        .collection("Restaurant")
        .where("restaurantId", whereIn: restaurantId)
        .where("active", isEqualTo: true)
        .get();
    foodMoodRestaurant = foodMoodRestaurantQuery.docs;
    update(["foodMoodRestaurant"]);
  }

  Future getHastags() async {
    QuerySnapshot<Map<String, dynamic>> hastagQuery;
    hastagQuery = await firebaseFirestore
        .collection("Hastags")
        .orderBy("updated")
        .orderBy("priority")
        .get();
    hastags = hastagQuery.docs;
    update(["hastags"]);
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

  String defineEndTime() {
    return "";
  }

  listenFood() {
    listenFoods = firebaseFirestore
        .collection("Foods")
        .where("promise", isEqualTo: true)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((foodsQuery) {
      foods = foodsQuery.docs;
      update(["foods"]);
    });
  }
}
