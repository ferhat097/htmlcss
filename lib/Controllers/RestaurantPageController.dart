// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/HomeController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

import 'GeneralController.dart';
import 'ProfilePageController.dart';

class RestaurantPageController extends GetxController {
  @override
  void onClose() {
    listenDiscounts?.cancel();
    listenComments?.cancel();
    super.onClose();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenDiscounts;
  StreamSubscription? listenComments;
  StreamSubscription? listenHeres;
  List<DocumentSnapshot<Map<String, dynamic>>> images = [];
  List<DocumentSnapshot<Map<String, dynamic>>> heres = [];
  List<DocumentSnapshot<Map<String, dynamic>>> hereFemale = [];
  List<DocumentSnapshot<Map<String, dynamic>>> hereMale = [];
  List<DocumentSnapshot<Map<String, dynamic>>> hastags = [];
  List<DocumentSnapshot<Map<String, dynamic>>> discounts = [];
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodSocial = [];
  DocumentSnapshot<Map<String, dynamic>>? restaurant;
  List<DocumentSnapshot<Map<String, dynamic>>> comments = [];
  List<dynamic> hastagsId = [];
  Future getRestaurantMain(String restaurantId) async {
    DocumentSnapshot<Map<String, dynamic>> restaurantquery =
        await firebaseFirestore
            .collection("Restaurant")
            .doc(restaurantId)
            .get();
    hastagsId = restaurantquery.data()!["hastags"];
    restaurant = restaurantquery;

    getHastags();
    update();
    update(["heres"]);
  }

  Future getImages(String restaurantId) async {
    QuerySnapshot<Map<String, dynamic>> imagequery = await firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("images")
        .get();
    images = imagequery.docs;
    update();
  }

  HomeController homeController = Get.find();

  void getHastags() {
    if (hastagsId.isNotEmpty) {
      hastags = homeController.hastags
          .where((element) => hastagsId.contains(element.data()!["id"]))
          .toList();
    }
    update(["hastag"]);
  }

  listenRestaurantHeres(String restaurantId) async {
    print(restaurantId);
    listenHeres = firebaseFirestore
        .collection("Heres")
        .where("restaurantId", isEqualTo: restaurantId)
        .snapshots()
        .listen((heresQuery) {
      heres = heresQuery.docs;
      hereMale =
          heresQuery.docs.where((doc) => doc.data()["sex"] == 1).toList();
      hereFemale =
          heresQuery.docs.where((doc) => doc.data()["sex"] == 2).toList();

      update(["heres"]);
    });
  }

  listenRestaurantDiscounts(String restaurantId) async {
    print(restaurantId);
    listenDiscounts = firebaseFirestore
        .collection("Discounts")
        .where("restaurantId", isEqualTo: restaurantId)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((discountQuery) {
      print(discountQuery.docs.length);
      discounts = discountQuery.docs;
      update(["discount"]);
    });
  }

  listenRestaurantComments(String restaurantId) {
    listenComments = firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("comments")
        .orderBy("date", descending: true)
        .snapshots()
        .listen(
      (commentQuery) {
        comments = commentQuery.docs;
        update();
      },
    );
  }

  bool defineOpenedStatus(int openedTime, int closedTime) {
    DateTime dateTime = DateTime.now();
    if (dateTime.hour > openedTime && dateTime.hour < closedTime) {
      return true;
    } else {
      return false;
    }
  }

  String defineTimeText(int openedTime, int closedTime) {
    return "${openedTime < 10 ? "0" + openedTime.toString() : openedTime.toString()}:00 - ${closedTime < 10 ? "0" + closedTime.toString() : closedTime.toString()}:00";
  }

  String defineEndTime() {
    return "";
  }

  Future getFoodMoodSocial(String restaurantId) async {
    QuerySnapshot<Map<String, dynamic>> foodMoodSocialQuery =
        await firebaseFirestore
            .collection("Restaurant")
            .doc(restaurantId)
            .collection("foodmoodsocial")
            .where("foodMoodSocial", isEqualTo: true)
            .get();
    print(foodMoodSocialQuery.docs.length);
    foodMoodSocial = foodMoodSocialQuery.docs;
    update(["foodmoodsocial"]);
  }

  Color defineUserColor(int point) {
    if (point <= 50) {
      return const Color(0xFFddb892);
    } else if (point > 50 && point <= 100) {
      return const Color(0xFF2a9d8f);
    } else if (point > 100 && point <= 150) {
      return const Color(0xFFC0C0C0);
    } else if (point > 150 && point <= 200) {
      return const Color(0xFFC29B0C);
    } else if (point > 250) {
      return const Color(0xFF014f86);
    } else {
      return const Color(0xFFfdf0d5);
    }
  }

  CarouselController carouselController = CarouselController();
  int currentImageIndex = 0;
  changeCurrentImageIndex(index) {
    currentImageIndex = index;
    update(["dot"]);
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool followProgress = false;
  Future unfollow(String restaurantId) async {
    followProgress = true;
    update();
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("unfollowRestaurant");
    await httpsCallable.call(
      <String, dynamic>{
        "restaurantId": restaurantId,
        "userId": firebaseAuth.currentUser!.uid
      },
    );
    followProgress = false;
    update();
  }

  Future follow(String restaurantId) async {
    followProgress = true;
    update();
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("followRestaurant");
    await httpsCallable.call(
      <String, dynamic>{
        "restaurantId": restaurantId,
        "userId": firebaseAuth.currentUser!.uid
      },
    );
    followProgress = false;
    update();
  }

  TextEditingController ratingWithCommentController = TextEditingController();
  double rating = 0;
  setRating(double newRating) {
    rating = newRating;
    update(["rating"]);
  }

  Future ratingRestaurant(double rating, String restaurantId) async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("ratingRestaurant");
    await httpsCallable.call(<String, dynamic>{
      "restaurantId": restaurantId,
      "userId": firebaseAuth.currentUser!.uid,
      "rating": rating,
      "comment": ratingWithCommentController.text
    });
    update();
  }

  checkRatingAvailable(List userList) {
    if (userList.contains(firebaseAuth.currentUser!.uid)) {
      return false;
    } else {
      return true;
    }
  }

  bool commentWritingProgress = false;

  TextEditingController writeRestaurantCommentController =
      TextEditingController();

  Future writeRestaurantComment(String restaurantId) async {
    commentWritingProgress = true;
    ProfilePageController profilePageController = Get.find();
    update();
    await firebaseFirestore
        .collection("Restaurant")
        .doc(restaurantId)
        .collection("comments")
        .add({
      "restaurantId": restaurantId,
      "fromId": firebaseAuth.currentUser!.uid,
      "comment": writeRestaurantCommentController.text,
      "date": DateTime.now(),
      "fromName": profilePageController.meSocial!.data()!["name"],
      "fromPhoto": profilePageController.meSocial!.data()!["userPhoto"],
      "fromUserName": profilePageController.meSocial!.data()!["userName"],
      "like": 0,
      "likedUsers": [],
    });
    // HttpsCallable httpsCallable =
    //     firebaseFunctions.httpsCallable("writeRestaurantComment");
    // await httpsCallable.call(
    //   <String, dynamic>{
    //     "restaurantId": restaurantId,
    //     "userId": firebaseAuth.currentUser!.uid,
    //     "comment": writeRestaurantCommentController.text,
    //   },
    // );
    commentWritingProgress = false;
    update();
  }

  bool defineHeres(List<DocumentSnapshot<Map<String, dynamic>>> heres) {
    if (heres
        .where((element) =>
            element.data()!["userId"] == firebaseAuth.currentUser!.uid)
        .isNotEmpty) {
      if (heres
              .where((element) =>
                  element.data()!["userId"] == firebaseAuth.currentUser!.uid)
              .first["isHere"] ??
          false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool loadingIamHere = false;

  Future iamhere(LatLng restaurantPosition, String restaurantId) async {
    loadingIamHere = true;
    update(["iamhere"]);
    print("permission");
    bool permission = await permissionLocation();

    if (permission) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        restaurantPosition.latitude,
        restaurantPosition.longitude,
      );
      if (distance < 50) {
        await setHere(restaurantId);
      } else {
        Get.snackbar("Siz bu ərazidə deyilsiniz", "");
        print("Siz bu erazide deyilsiniz");
      }
    } else {
      Get.snackbar("Location Permission",
          "Ayarlardan FoodMood tətbiqinin konumunuzu istifadəsinə icazə verin. Daha sonra yenidən cəhd edin",
          onTap: (a) {
        AppSettings.openLocationSettings();
      });
    }
    loadingIamHere = false;
    update(["iamhere"]);
  }

  GeneralController generalController = Get.find();

  Future setHere(String restaurantId) async {
    ProfilePageController profilePageController = Get.find();
    int sex = profilePageController.meSocial!["sex"];
    String userId = profilePageController.meSocial!["userId"];
    Map<String, dynamic> userInfo = profilePageController.meSocial!.data()!;
    userInfo.putIfAbsent("hereDate", () => DateTime.now());
    userInfo.putIfAbsent("restaurantId", () => restaurantId);
    userInfo.putIfAbsent("isHere", () => true);
    DocumentReference restaurantReference =
        firebaseFirestore.collection("Restaurant").doc(restaurantId);
    DocumentReference<Map<String, dynamic>> hereReference =
        firebaseFirestore.collection("Heres").doc(userId);
    DocumentReference<Map<String, dynamic>> meSocialReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    firebaseFirestore.runTransaction(
      (transaction) async {
        DocumentSnapshot<Map<String, dynamic>> user =
            await transaction.get(hereReference);
        if (user.exists) {
          if (user.data()!["restaurantId"] == restaurantId &&
              user.data()!["isHere"]) {
            Timestamp hereDateTS = user.data()!["hereDate"];
            DateTime hereDate = hereDateTS.toDate();
            // int timeLeft = hereDate.compareTo(DateTime.now());
            Duration timeLeft = DateTime.now().difference(hereDate);
            print(hereDate);
            return Get.snackbar(
              "Artıq bu restoran olduğunuzu qeyd edibsiniz",
              "${(timeLeft.inMinutes - 30) * -1} dəqiqə sonra ləğv olunacaq",
            );
          } else if (user.data()!["restaurantId"] != restaurantId &&
              user.data()!["isHere"]) {
            return Get.snackbar("Siz başqa restorandasınız", "");
          } else {
            if (sex == 1) {
              transaction.update(restaurantReference, {
                "heremale": FieldValue.increment(1),
              });
            } else {
              transaction.update(restaurantReference, {
                "herefemale": FieldValue.increment(1),
              });
            }
            transaction.set(
              hereReference,
              userInfo,
            );
            if (user.data()!["restaurantId"] == restaurantId) {
              Timestamp hereDateTS = user.data()!["hereDate"];
              DateTime hereDate = hereDateTS.toDate();
              int timeLeft = DateTime.now().difference(hereDate).inHours;
              if (timeLeft > 6) {
                transaction.update(meSocialReference, {
                  "hereTime": FieldValue.increment(1),
                });
              }
            } else {
              if (heres.isEmpty) {
                transaction.update(meSocialReference, {
                  "hereTime": FieldValue.increment(1),
                  "moodx": FieldValue.increment(
                      generalController.financial["firstHeresAward"]),
                });
              } else {
                transaction.update(meSocialReference, {
                  "hereTime": FieldValue.increment(1),
                });
              }
            }
          }
        } else {
          if (sex == 1) {
            transaction.update(restaurantReference, {
              "heremale": FieldValue.increment(1),
            });
          } else {
            transaction.update(restaurantReference, {
              "herefemale": FieldValue.increment(1),
            });
          }
          transaction.set(
            hereReference,
            userInfo,
          );
          if (heres.isEmpty) {
            transaction.update(meSocialReference, {
              "hereTime": FieldValue.increment(1),
              "moodx": FieldValue.increment(
                  generalController.financial["firstHeresAward"]),
            });
          } else {
            transaction.update(
              meSocialReference,
              {
                "hereTime": FieldValue.increment(1),
              },
            );
          }
        }
      },
    );
  }

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

  Future likeComment(String commentId, bool like) async {
    if (like) {
      await firebaseFirestore
          .collection("Restaurant")
          .doc(restaurant!.id)
          .collection("comments")
          .doc(commentId)
          .update({
        "likedUsers": FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(1),
      });
    } else {
      await firebaseFirestore
          .collection("Restaurant")
          .doc(restaurant!.id)
          .collection("comments")
          .doc(commentId)
          .update({
        "likedUsers": FieldValue.arrayRemove([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(-1),
      });
    }
  }

  Future removeComment(
    String commentId,
  ) async {
    await firebaseFirestore
        .collection("Restaurant")
        .doc(restaurant!.id)
        .collection("comments")
        .doc(commentId)
        .delete();
  }
}
