// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class SearchController extends GetxController {
  List<Map<String, dynamic>> features = [];
  List selectedFeatures = [];
  List cordinates = [];
  @override
  void onInit() async {
    listenController();
    await getRestaurant();
    await getFeatures();
    super.onInit();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? restaurantsQuery;
  List<Map<String, dynamic>> restaurants = [];
  Future getRestaurant() async {
    if (restaurants.isNotEmpty) {
      // restaurants.where((element) => element["ads"] == true).forEach((element) {
      //   AdWidget adWidget = element["widget"];
      //   adWidget.ad.dispose();
      //   restaurants.clear();
      // });
      restaurants.clear();
    }
    if (restaurantTypes) {
      if (restaurantFeatures) {
        restaurantsQuery = await firebaseFirestore
            .collection("Restaurant")
            .where("facilityType", isEqualTo: facilityType)
            .where("restaurantFeatures", arrayContainsAny: selectedFeatures)
            .limit(10)
            .get();

        lastId = restaurantsQuery!.docs.last.id;
        int count = 0;
        for (var restaurant in restaurantsQuery!.docs) {
          count++;
          if (count % 5 == 0) {
            AdWidget adWidget = await loadAds();
            restaurants.add({"ads": true, "widget": adWidget});
          }
          Map<String, dynamic> restaurantMap = restaurant.data();
          restaurantMap.putIfAbsent("ads", () => false);
          restaurants.add(restaurantMap);
        }
        restaurants.shuffle();
      } else {
        restaurantsQuery = await firebaseFirestore
            .collection("Restaurant")
            .where("facilityType", isEqualTo: facilityType)
            .limit(10)
            .get();
        lastId = restaurantsQuery!.docs.last.id;
        int count = 0;
        for (var restaurant in restaurantsQuery!.docs) {
          count++;
          if (count % 5 == 0) {
            AdWidget adWidget = await loadAds();
            restaurants.add({"ads": true, "widget": adWidget});
          }
          Map<String, dynamic> restaurantMap = restaurant.data();
          restaurantMap.putIfAbsent("ads", () => false);
          restaurants.add(restaurantMap);
        }
        //restaurants.shuffle();
      }
    } else {
      if (restaurantFeatures) {
        print("okquery");
        restaurantsQuery = await firebaseFirestore
            .collection("Restaurant")
            .where("restaurantFeatures", arrayContainsAny: selectedFeatures)
            .limit(10)
            .get();
        lastId = restaurantsQuery!.docs.last.id;
        int count = 0;
        for (var restaurant in restaurantsQuery!.docs) {
          count++;
          if (count % 5 == 0) {
            AdWidget adWidget = await loadAds();
            restaurants.add({"ads": true, "widget": adWidget});
          }
          Map<String, dynamic> restaurantMap = restaurant.data();
          restaurantMap.putIfAbsent("ads", () => false);
          restaurants.add(restaurantMap);
        }
        restaurants.shuffle();
      } else {
        restaurantsQuery = await firebaseFirestore
            .collection("Restaurant")
            .orderBy("restaurantId")
            .limit(10)
            .get();
        lastId = restaurantsQuery!.docs.last.id;
        int count = 0;
        for (var restaurant in restaurantsQuery!.docs) {
          count++;
          if (count % 5 == 0) {
            AdWidget adWidget = await loadAds();
            restaurants.add({"ads": true, "widget": adWidget});
          }
          Map<String, dynamic> restaurantMap = restaurant.data();
          restaurantMap.putIfAbsent("ads", () => false);
          restaurants.add(restaurantMap);
        }
        restaurants.shuffle();
      }
    }

    update();
  }

  String? lastId;

  bool loadingMore = false;

  Future getMoreRestaurant() async {
    if (near) {
      return Get.snackbar(
        "5 KM ətrafınızdakı restoranlar göstərildi!",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.pink,
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        borderRadius: 5,
      );
    }
    if (!near && !isSearch) {
      loadingMore = true;
      update(["loadingMore"]);
      if (restaurantTypes) {
        if (restaurantFeatures) {
          restaurantsQuery = await firebaseFirestore
              .collection("Restaurant")
              .where("facilityType", isEqualTo: facilityType)
              .where("restaurantFeatures", arrayContainsAny: selectedFeatures)
              .startAfter([lastId])
              .limit(10)
              .get();
          lastId = restaurantsQuery!.docs.last.id;
          int count = 0;
          for (var restaurant in restaurantsQuery!.docs) {
            if (count % 5 == 0) {
              AdWidget adWidget = await loadAds();
              restaurants.add({"ads": true, "widget": adWidget});
            }
            Map<String, dynamic> restaurantMap = restaurant.data();
            restaurantMap.putIfAbsent("ads", () => false);
            restaurants.add(restaurantMap);
          }
        } else {
          restaurantsQuery = await firebaseFirestore
              .collection("Restaurant")
              .where("facilityType", isEqualTo: facilityType)
              .startAfter([lastId])
              .limit(10)
              .get();
          lastId = restaurantsQuery!.docs.last.id;
          int count = 0;
          for (var restaurant in restaurantsQuery!.docs) {
            count++;
            if (count % 5 == 0) {
              AdWidget adWidget = await loadAds();
              restaurants.add({"ads": true, "widget": adWidget});
            }
            Map<String, dynamic> restaurantMap = restaurant.data();
            restaurantMap.putIfAbsent("ads", () => false);
            restaurants.add(restaurantMap);
          }
        }
      } else {
        if (restaurantFeatures) {
          print("okquery");
          restaurantsQuery = await firebaseFirestore
              .collection("Restaurant")
              .where("restaurantFeatures", arrayContainsAny: selectedFeatures)
              .startAfter([lastId])
              .limit(10)
              .get();
          lastId = restaurantsQuery!.docs.last.id;
          int count = 0;
          for (var restaurant in restaurantsQuery!.docs) {
            count++;
            if (count % 5 == 0) {
              AdWidget adWidget = await loadAds();
              restaurants.add({"ads": true, "widget": adWidget});
            }
            Map<String, dynamic> restaurantMap = restaurant.data();
            restaurantMap.putIfAbsent("ads", () => false);
            restaurants.add(restaurantMap);
          }
        } else {
          print("getted");
          restaurantsQuery = await firebaseFirestore
              .collection("Restaurant")
              .orderBy("restaurantId")
              .startAfter([lastId])
              .limit(10)
              .get();
          print("getted2");
          if (restaurantsQuery!.docs.isNotEmpty) {
            lastId = restaurantsQuery!.docs.last.id;
            int count = 0;
            for (var restaurant in restaurantsQuery!.docs) {
              count++;
              if (count % 5 == 0) {
                AdWidget adWidget = await loadAds();
                restaurants.add({"ads": true, "widget": adWidget});
              }
              Map<String, dynamic> restaurantMap = restaurant.data();
              restaurantMap.putIfAbsent("ads", () => false);
              restaurants.add(restaurantMap);
            }
          }
        }
      }
      loadingMore = false;
      update(["loadingMore"]);
      update();
    }
  }

  bool loadingRestaurantType = false;

  int facilityType = 0;
  bool restaurantTypes = false;
  filterRestaurantType(int newType) async {
    print(newType);
    if (newType == 0) {
      near = false;
      restaurantTypes = false;
      facilityType = 0;
    } else {
      near = false;
      facilityType = newType;
      restaurantTypes = true;
    }
    loadingRestaurantType = true;
    update();
    try {
      await getRestaurant();
    } catch (e) {
      print(e);
      loadingRestaurantType = false;
      update();
    }
    loadingRestaurantType = false;
    update();
  }

  /////search
  String searchIndex = "Restaurants";
  bool loadingSearchIndex = false;

  void setSearchIndex(String index) {
    loadingSearchIndex = true;
    update();
    searchIndex = index;
    searchDelayFunction(searchController.text);
    update();
  }

  bool restaurantFeatures = false;
  Future setRestaurantFeatures(bool state) async {
    loadingFeatures = true;
    update(["features"]);
    restaurantFeatures = state;
    try {
      await getRestaurant();
    } catch (e) {
      print(e);
      loadingFeatures = false;
      update(["features"]);
      update();
    }

    loadingFeatures = false;
    update(["features"]);
    update();
  }

  bool loadingFeatures = false;

  setFeature(int key) {
    if (selectedFeatures.contains(key)) {
      selectedFeatures.remove(key);
    } else {
      selectedFeatures.add(key);
    }

    update(["features"]);
  }

  bool loadingDeleteFeature = false;
  Future deleteFeature() async {
    selectedFeatures.clear();
    if (restaurantFeatures) {
      restaurantFeatures = false;
      loadingDeleteFeature = true;
      update(["features"]);
      await getRestaurant();
      loadingDeleteFeature = false;
    }

    update(["features"]);
  }

  bool isSearch = false;
  RxBool searching = false.obs;
  setWidgettoSearch(bool search) {
    isSearch = search;
    if (!search) {
      searchIndex = "Restaurants";
    }
    update();
  }

  Timer? searchDelay;
  TextEditingController searchController = TextEditingController();
  //algolia
  AlgoliaQuerySnapshot? searchResults;

  searchDelayFunction(String queryText) {
    searchDelay = Timer(
      const Duration(seconds: 2),
      () => searchAlgolia(queryText),
    );
  }

  Future searchAlgolia(String querytext) async {
    print("searched");
    loadingSearchIndex = true;
    update();
    Algolia algolia = const Algolia.init(
      applicationId: "X47Q4IOWZ3",
      apiKey: "8e66460b474ae360303b13ef6f4a5caf",
    );
    AlgoliaQuery query = algolia.instance.index(searchIndex).query(querytext);
    searchResults = await query.getObjects();
    searching.value = false;
    loadingSearchIndex = false;
    update();
  }

  Future getFeatures() async {
    QuerySnapshot<Map<String, dynamic>> featureQuery =
        await firebaseFirestore.collection("Features").get();
    for (var feature in featureQuery.docs) {
      features.add(feature.data());
    }
    update(["features"]);
  }

  Widget defineRestaurantImage(String? image, BuildContext context) {
    if (image == null || image.isEmpty) {
      return Container(color: Theme.of(context).primaryColor);
    } else {
      return Image.network(
        image,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
      );
    }
  }

  Widget defineType(int type) {
    if (type == 1) {
      return Image.asset(
        "assets/restaurant.png",
      );
    } else if (type == 3) {
      return Image.asset("assets/hotel.png");
    } else if (type == 2) {
      return Image.asset("assets/burger.png");
    } else if (type == 4) {
      return Image.asset("assets/homemade.png");
    } else {
      return Image.asset("assets/restaurant.png");
    }
  }

  bool defineOpenedStatus(int openedTime, int closedTime, bool? is247) {
    DateTime dateTime = DateTime.now();
    if (is247 != null && is247) {
      return true;
    }
    if (dateTime.hour > openedTime && dateTime.hour < closedTime) {
      return true;
    } else {
      return false;
    }
  }

  ///find nearby you
  ///
  ///
  Future<bool> permissionLocation() async {
    var status = await Permission.locationWhenInUse.status;
    print(status);
    if (status == PermissionStatus.permanentlyDenied) {
      await AppSettings.openLocationSettings();
      var status2 = await Permission.locationWhenInUse.status;
      if (status2.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status != PermissionStatus.granted) {
      PermissionStatus permissionStatus =
          await Permission.locationWhenInUse.request();
      if (permissionStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  bool near = false;
  Future setNear(bool newvalue) async {
    if (newvalue) {
      bool permissionStatus = await permissionLocation();
      if (permissionStatus) {
        await getNearRestaurant();
        near = newvalue;
      } else {
        return Get.snackbar("Location Permission",
            "Ayarlardan FoodMood tətbiqinin konumunuzu istifadəsinə icazə verin. Daha sonra yenidən cəhd edin",
            onTap: (a) {
          AppSettings.openLocationSettings();
        });
      }
    } else {
      restaurants.shuffle();
      near = newvalue;
      update();
    }

    update();
  }

  void setNearToFalse() {
    near = false;
    update();
  }

  bool loadingGetNearRestaurant = false;

  Future getNearRestaurant() async {
    loadingGetNearRestaurant = true;
    update();
    Position currentPosition = await Geolocator.getCurrentPosition();
    print(currentPosition.latitude);
    print(currentPosition.longitude);

    HttpsCallable httpsCallable =
        FirebaseFunctions.instance.httpsCallable("getNearMe");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "meLat": currentPosition.latitude,
      "meLon": currentPosition.longitude,
      "radius": 5,
    });

    print(result.data);
    restaurants.clear();
    List restaurantNear = result.data;
    for (var res in restaurantNear) {
      Map<String, dynamic> resMap = {
        "restaurantName": res["restaurantName"],
        "location": res["location"],
        "locationName": res["locationName"],
        "closeTime": res["closeTime"],
        "openTime": res["openTime"],
        "is247": res["is247"],
        "restaurantImage": res["restaurantImage"],
        "facilityType": res["facilityType"],
        "restaurantId": res["restaurantId"],
      };
      restaurants.add(resMap);
    }

    for (var restaurant in restaurants) {
      GeoPoint geoPoint = GeoPoint(restaurant["location"]["_latitude"],
          restaurant["location"]["_longitude"]);
      double m = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        geoPoint.latitude,
        geoPoint.longitude,
      );
      restaurant.putIfAbsent("distance", () => m);
      restaurant.putIfAbsent("ads", () => false);
      restaurant.putIfAbsent("fromPins", () => true);
    }
    restaurants.sort((a, b) => a["distance"].compareTo(b["distance"]));
    loadingGetNearRestaurant = false;
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
      size: AdSize.mediumRectangle,
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

  ScrollController controller = ScrollController();
  listenController() {
    controller.addListener(
      () {
        if (controller.offset == controller.position.maxScrollExtent &&
            !controller.position.outOfRange &&
            controller.position.pixels != 0) {
          if (!loadingMore) {
            getMoreRestaurant();
          }
        }
      },
    );
  }
}
