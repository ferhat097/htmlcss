// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'GeneralController.dart';

class FoodMoodSocialController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodSocialLevel = [];
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodSocialWeeklyTop = [];
  List<DocumentSnapshot<Map<String, dynamic>>> foodMoodSocialSendAway = [];
  GetStorage getStorage = GetStorage();
  StreamSubscription? listenUsers;
  StreamSubscription? listenWeeklyTop;

  @override
  void onClose() {
    listenUsers?.cancel();

    listenWeeklyTop?.cancel();
    super.onClose();
  }

  // @override
  // void onInit() {
  //   getDuo();
  //   // listenFoodMoodSocialBestPoint();
  //   // listenFoodMoodSocialMe();
  //   // listenFoodMoodSocialWeeklyTop();
  //   // getFoodMoodSocialsendaway();
  //   super.onInit();
  // }

  listenFoodMoodSocialBestPoint() async {
    String userId = await getStorage.read("userUid");
    listenUsers = firebaseFirestore
        .collection("FoodMoodSocial")
        .orderBy("userId")
        .where("userId", isNotEqualTo: userId)
        .orderBy("point", descending: true)
        .where("foodMoodSocial", isEqualTo: true)
        .where("test", isEqualTo: false)
        .snapshots()
        .listen(
      (usersQuery) {
        foodMoodSocialLevel = usersQuery.docs;
        update();
      },
    );
  }

  Color defineUserColor(double point) {
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

  // listenFoodMoodSocialWeeklyTop() {
  //   listenWeeklyTop = firebaseFirestore
  //       .collection("FoodMoodSocial")
  //       .where("foodMoodSocial", isEqualTo: true)
  //       .orderBy("weeklyPay", descending: true)
  //       .where("test", isEqualTo: false)
  //       .limit(10)
  //       .snapshots()
  //       .listen(
  //     (weeklyTopQuery) {
  //       foodMoodSocialWeeklyTop = weeklyTopQuery.docs;
  //       update(["weeklytop"]);
  //     },
  //   );
  // }

  Future getFoodMoodSocialsendaway() async {
    QuerySnapshot<Map<String, dynamic>> sendawayQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("issendaway", isEqualTo: true)
        .where("test", isEqualTo: false)
        .orderBy("sendawayfor", descending: true)
        .get();
    foodMoodSocialSendAway = sendawayQuery.docs;
    update(["sendaway"]);
  }

  PageController pageController = PageController(initialPage: 1);
  int currentPage = 1;
  void changePage(newPage) {
    currentPage = newPage;
    update(["foodmoodsocialpagechange"]);
  }

  List<Map<String, dynamic>> duos = [];
  MatchEngine matchEngine = MatchEngine();

  String? lastid;
  bool firstInit = true;

  /////limit
  ///
  ///
  bool loadingIncreaseLimit = false;

  Future increaseLimit(int currentdailyIncreased) async {
    GeneralController generalController = Get.find();
    String adId;
    if (Platform.isIOS) {
      adId = "ca-app-pub-9770261708355804/9240914907";
    } else {
      adId = "ca-app-pub-9770261708355804/4289896584";
    }
    int dailyLimitIncreaseLimit =
        generalController.foodSocial["dailyLimitIncreaseLimit"];
    int dailyIncreased = currentdailyIncreased;
    if (dailyIncreased >= dailyLimitIncreaseLimit) {
      return Get.snackbar("Günlük limiti artıra bilməzsiniz",
          "Günlük limiti ən çox $dailyLimitIncreaseLimit dəfə artıra bilərsiniz.");
    } else {
      loadingIncreaseLimit = true;
      update();
      await RewardedAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) async {
            //loaded
            await ad.show(
              onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) async {
                await firebaseFirestore
                    .collection("FoodMoodSocial")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update(
                  {
                    "dailyLimit": FieldValue.increment(
                        generalController.foodSocial["oneLimitIncrease"]),
                    "dailyIncreased": FieldValue.increment(1),
                  },
                );
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            //failed
          },
        ),
      );
      Get.snackbar("Limit artırıldı", "");
      loadingIncreaseLimit = false;
      update();
    }
  }

  Future getDuo() async {
    print("getduos1");
    loadingDuos = true;
    firstInit = false;
    update();
    duos.clear();
    print("getduos2");
    bool allFilled =
        profilePageController.meSocial!.data()!["allFilled"] ?? false;
    print("getduos3");
    bool foodMoodSocial =
        profilePageController.meSocial!.data()!["foodMoodSocial"] ?? false;
    print("getduos4");
    if (allFilled && foodMoodSocial) {
      print("getduos5");
      String userId = await getStorage.read("userUid");
      int mysex = profilePageController.meSocial!.data()!["sex"] ?? 1;
      int searchedSex;
      if (mysex == 1) {
        searchedSex = 2;
      } else {
        searchedSex = 1;
      }
      print("getduos6");
      QuerySnapshot<Map<String, dynamic>> duosQuery = await firebaseFirestore
          .collection("FoodMoodSocial")
          .where("foodMoodSocial", isEqualTo: true)
          .where("test", isEqualTo: false)
          .where("allFilled", isEqualTo: true)
          .where("userId", isNotEqualTo: userId)
          .where("sex", isEqualTo: searchedSex)
          .limit(20)
          .get();
      print("getduos7");
      List seenUsers = profileController.meSocial!.data()!["seenUsers"] ?? [];
      lastid = duosQuery.docs.last.id;
      for (var duo in duosQuery.docs) {
        // List likedUsers = duo.data()["likedUsers"] ?? [];
        if (!seenUsers.contains(duo.data()["userId"])) {
          duos.add(duo.data());
        }
      }
      print("getduos8");
      //duos.shuffle();
      print("1- bu duosun uzunlugudur${duos.length}");
      matchEngine = MatchEngine(
        swipeItems: duos
            .map(
              (e) => SwipeItem(
                  content: e,
                  likeAction: () {
                    defineLikeAction(e["userId"], e);
                  },
                  nopeAction: () {
                    defineNopeAction(e["userId"]);
                  },
                  superlikeAction: () {
                    defineNopeAction(e["userId"]);
                  }),
            )
            .toList(),
      );
    }
    lastDuos = false;
    loadingDuos = false;
    update();
  }

  bool loadingDuos = false;

  Future getMoreDuos() async {
    loadingDuos = true;
    firstInit = false;
    update();
    duos.clear();
    int mysex = profilePageController.meSocial!.data()!["sex"] ?? 1;
    String userId = await getStorage.read("userUid");
    int searchedSex;
    if (mysex == 1) {
      searchedSex = 2;
    } else {
      searchedSex = 1;
    }
    QuerySnapshot<Map<String, dynamic>> duosQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("foodMoodSocial", isEqualTo: true)
        .where("test", isEqualTo: false)
        .where("allFilled", isEqualTo: true)
        .where("userId", isNotEqualTo: userId)
        .where("sex", isEqualTo: searchedSex)
        .orderBy("userId")
        .startAfter([lastid])
        .limit(20)
        .get();

    print(duosQuery.docs.length);
    if (duosQuery.docs.isEmpty) {
      if (!lastDuos) {
        await getifEnded();
        return null;
      } else {
        loadingDuos = false;
        return null;
      }
    } else {
      List seenUsers = profileController.meSocial!.data()!["seenUsers"] ?? [];
      lastid = duosQuery.docs.last.id;
      for (var duo in duosQuery.docs) {
        //List likedUsers = duo.data()["likedUsers"] ?? [];
        if (!seenUsers.contains(duo.data()["userId"])) {
          duos.add(duo.data());
        }
      }
      if (duos.isEmpty) {
        print("2 duoslist-ok bosdur");
        if (!lastDuos) {
          await getifEnded();
          return null;
        } else {
          loadingDuos = false;
          return null;
        }
      }
      print("2 - bu duosun uzunlugudur${duos.length}");
      matchEngine = MatchEngine(
        swipeItems: duos
            .map(
              (e) => SwipeItem(
                  content: e,
                  likeAction: () {
                    defineLikeAction(e["userId"], e);
                  },
                  nopeAction: () {
                    defineNopeAction(e["userId"]);
                  },
                  superlikeAction: () {
                    defineNopeAction(e["userId"]);
                  }),
            )
            .toList(),
      );
    }

    loadingDuos = false;
    update();
  }

  bool lastDuos = false;
  ProfilePageController profilePageController = Get.find();

  Future getifEnded() async {
    loadingDuos = true;
    print("son duos: ");
    int mysex = profilePageController.meSocial!.data()!["sex"] ?? 1;
    update();
    duos.clear();
    String userId = await getStorage.read("userUid");
    int searchedSex;
    if (mysex == 1) {
      searchedSex = 2;
    } else {
      searchedSex = 1;
    }
    QuerySnapshot<Map<String, dynamic>> duosQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("foodMoodSocial", isEqualTo: true)
        .where("test", isEqualTo: false)
        .where("allFilled", isEqualTo: true)
        .where("userId", isNotEqualTo: userId)
        .where("sex", isEqualTo: searchedSex)
        .orderBy("userId")
        .limit(50)
        .get();
    List likedUsers = profileController.meSocial!.data()!["likedUsers"] ?? [];
    for (var duo in duosQuery.docs) {
      if (!likedUsers.contains(duo.data()["userId"])) {
        duos.add(duo.data());
      }
    }
    duos.shuffle();
    print("bu duosun uzunlugudur${duos.length}");
    matchEngine = MatchEngine(
      swipeItems: duos
          .map(
            (e) => SwipeItem(
              content: e,
              likeAction: () {
                defineLikeAction(e["userId"], e);
              },
              nopeAction: () {
                defineNopeAction(e["userId"]);
              },
              superlikeAction: () {
                defineNopeAction(e["userId"]);
              },
            ),
          )
          .toList(),
    );
    lastDuos = true;
    loadingDuos = false;
    update();
  }

  ProfilePageController profileController = Get.find();
  GeneralController generalController = Get.find();
  AuthController authController = Get.find();

  Future defineLikeAction(String userId, Map<String, dynamic> user) async {
    bool connected = authController.activeInternet;
    if (connected) {
      if (defineLikeType(
              profileController.meSocial!.data()!["likedUsers"] ?? [],
              profileController.meSocial!.data()!["likerUsers"] ?? [],
              userId) ==
          1) {
        if (defineAllPercentage(user["allList"] ?? [],
                profileController.meSocial!.data()!["allList"] ?? []) <
            generalController.foodSocial["adsRequired"]) {
          bool premium =
              profileController.meSocial!.data()!["premium"] ?? false;
          if (premium) {
            List likerUsers =
                profileController.meSocial!.data()!["likerUsers"] ?? [];
            if (likerUsers.contains(userId)) {
              haveMatch = true;
              matchedUser = user;
              controllerCenter.play();
              controllerCenterLeft.play();
              matchEngine.currentItem!.resetMatch();
              //matchEngine.cycleMatch();
              //matchEngine.rewindMatch();
              update();
              //oda seni beyenib;
            }
            await likeAction(userId, haveMatch, user);
          } else {
            //reklam izle
            matchEngine.currentItem!.resetMatch();
            String adId;
            if (Platform.isIOS) {
              adId = "ca-app-pub-9770261708355804/9240914907";
            } else {
              adId = "ca-app-pub-9770261708355804/4289896584";
            }
            await RewardedAd.load(
              adUnitId: adId,
              request: const AdRequest(),
              rewardedAdLoadCallback: RewardedAdLoadCallback(
                onAdLoaded: (RewardedAd ad) {
                  //loaded
                  ad.show(onUserEarnedReward:
                      (RewardedAd ad, RewardItem rewardItem) async {
                    List likerUsers =
                        profileController.meSocial!.data()!["likerUsers"];
                    if (likerUsers.contains(userId)) {
                      haveMatch = true;
                      matchedUser = user;
                      controllerCenter.play();
                      controllerCenterLeft.play();

                      //matchEngine.cycleMatch();
                      //matchEngine.rewindMatch();
                      update();
                      //oda seni beyenib;
                    }
                    await likeAction(userId, haveMatch, user);
                    matchEngine.currentItem!.resetMatch();
                    // matchEngine.currentItem!.superLike();
                  });
                },
                onAdFailedToLoad: (LoadAdError error) {
                  //failed
                },
              ),
            );
          }
        } else {
          List likerUsers =
              profileController.meSocial!.data()!["likerUsers"] ?? [];
          if (likerUsers.contains(userId)) {
            haveMatch = true;
            matchedUser = user;
            controllerCenter.play();
            controllerCenterLeft.play();
            matchEngine.currentItem!.resetMatch();
            //matchEngine.cycleMatch();
            //matchEngine.rewindMatch();
            update();
            //oda seni beyenib;
          }

          await likeAction(userId, haveMatch, user);
        }
      } else if (defineLikeType(
              profileController.meSocial!.data()!["likedUsers"] ?? [],
              profileController.meSocial!.data()!["likerUsers"] ?? [],
              userId) ==
          2) {
        //gift actions
      } else {
        // Get.to(() => MessageDetail(
        //       userId: userId,
        //       withConversation: false,
        //       user: user,
        //     ));
        // matchEngine.currentItem!.resetMatch();
        //message actions
      }
    } else {
      Get.snackbar(
        "Internet bağlantısı yoxdur!",
        "Cihazınızın internetə bağlı olduğuna əmin olun.",
        backgroundColor: Colors.red.withOpacity(0.8),
        borderRadius: 5,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        snackStyle: SnackStyle.FLOATING,
        colorText: Colors.white,
      );
    }
  }

  bool haveMatch = false;
  Map<String, dynamic>? matchedUser;
  writeMessage() {
    haveMatch = false;
    //matchEngine.currentItem!.superLike();
    controllerCenter.stop();
    controllerCenterLeft.stop();
    update();
  }

  Future defineNopeAction(String userId) async {
    bool connected = authController.activeInternet;
    if (connected) {
      await nopeAction(userId);
    } else {
      Get.snackbar(
        "Internet bağlantısı yoxdur!",
        "Cihazınızın internetə bağlı olduğuna əmin olun.",
        backgroundColor: Colors.red.withOpacity(0.8),
        borderRadius: 5,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        snackStyle: SnackStyle.FLOATING,
        colorText: Colors.white,
      );
    }
  }

  Future likeAction(
      String userId, bool hasMatch, Map<String, dynamic> user) async {
    String meId = await getStorage.read("userUid");
    DocumentReference userReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    DocumentReference meReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(meId);
    await firebaseFirestore.runTransaction<bool>((transaction) async {
      await transaction.update(userReference, {
        "likerUsers": FieldValue.arrayUnion([meId]),
        "likerTime": FieldValue.increment(1),
        "swiperTime": FieldValue.increment(1),
      });
      await transaction.update(meReference, {
        "likedUsers": FieldValue.arrayUnion([userId]),
        "likedTime": FieldValue.increment(1),
        "swipeTime": FieldValue.increment(1),
        "seenUsers": FieldValue.arrayUnion([userId]),
      });
      if (hasMatch) {
        DocumentReference meMatchedReference = firebaseFirestore
            .collection("FoodMoodSocial")
            .doc(meId)
            .collection("matched")
            .doc(userId);
        DocumentReference userMatchedReference = firebaseFirestore
            .collection("FoodMoodSocial")
            .doc(userId)
            .collection("matched")
            .doc(meId);
        transaction.set(meMatchedReference, {
          "userId": userId,
          "userPhoto": user["userPhoto"],
          "userName": user["userName"],
          "name": user["name"],
          "messaged": false,
          "date": DateTime.now(),
          "meId": FirebaseAuth.instance.currentUser!.uid,
          "userToken": user["token"] ?? ""
        });
        transaction.set(userMatchedReference, {
          "userId": meId,
          "userPhoto": profileController.meSocial!.data()!["userPhoto"],
          "userName": profileController.meSocial!.data()!["userName"],
          "name": profileController.meSocial!.data()!["name"],
          "messaged": false,
          "date": DateTime.now(),
          "meId": user["userId"],
          "userToken": profileController.meSocial!.data()!["token"] ?? "",
        });
      }
      return true;
    });
    int dailyswipeTime = getStorage.read("swipeTime") ?? 0;
    await getStorage.write("swipeTime", dailyswipeTime + 1);
  }

  Future nopeAction(String userId) async {
    String meId = await getStorage.read("userUid");
    DocumentReference userReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    DocumentReference meReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(meId);
    await firebaseFirestore.runTransaction<bool>(
      (transaction) async {
        transaction.update(
          userReference,
          {
            "noperTime": FieldValue.increment(1),
            "swiperTime": FieldValue.increment(1),
          },
        );
        transaction.update(
          meReference,
          {
            "nopedUsers": FieldValue.arrayUnion([userId]),
            "nopedTime": FieldValue.increment(1),
            "swipeTime": FieldValue.increment(1),
            "seenUsers": FieldValue.arrayUnion([userId]),
          },
        );
        return true;
      },
    );
    int dailyswipeTime = getStorage.read("swipeTime") ?? 0;
    await getStorage.write("swipeTime", dailyswipeTime + 1);
  }

  Widget defineLikeButton(
    List? likedUsers,
    List? likerUsers,
    String userId,
    List? allList,
  ) {
    if (defineAllPercentage(allList ?? [],
            profileController.meSocial!.data()!["allList"] ?? []) <
        generalController.foodSocial["adsRequired"]) {
      bool premium = profileController.meSocial!.data()!["premium"] ?? false;
      if (premium) {
        return Image.asset(
          "assets/healthy-food.png",
          //color: Colors.white,
          scale: 5,
        );
      } else {
        return Stack(
          children: [
            Image.asset(
              "assets/healthy-food.png",
              //color: Colors.white,
              scale: 5,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/advertisements.png",
                  color: Colors.white,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
              ),
            )
          ],
        );
      }
    } else {
      return Image.asset(
        "assets/healthy-food.png",
        //color: Colors.white,
        scale: 5,
      );
    }
  }

  Color defineLikeColor(
    List? likedUsers,
    List? likerUsers,
    String userId,
  ) {
    return Colors.pinkAccent[200]!;
  }

  int defineLikeType(
    List? likedUsers,
    List? likerUsers,
    String userId,
  ) {
    return 1;
    // if (likedUsers!.contains(userId) && likerUsers!.contains(userId)) {
    //   return 3;
    // } else if (likedUsers.contains(userId)) {
    //   return 2;
    // } else {
    //   return 1;
    // }
  }

  //confetti
  ConfettiController controllerCenter =
      ConfettiController(duration: const Duration(seconds: 10));
  ConfettiController controllerCenterLeft =
      ConfettiController(duration: const Duration(seconds: 10));
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  //definePercentage
  int defineFoodPercentage(List userFoodList, List meFoodList) {
    Set set = userFoodList.toSet().intersection(meFoodList.toSet());
    int percent = (set.length / 3 * 100).toInt();
    return percent;
  }

  int defineDrinkPercentage(List userFoodList, List meFoodList) {
    Set set = userFoodList.toSet().intersection(meFoodList.toSet());
    int percent = (set.length / 3 * 100).toInt();
    return percent;
  }

  int defineRestaurantPercentage(List userFoodList, List meFoodList) {
    Set set = userFoodList.toSet().intersection(meFoodList.toSet());
    int percent = (set.length / 3 * 100).toInt();
    return percent;
  }

  int defineAllPercentage(List userallList, List meallList) {
    Set set = userallList.toSet().intersection(meallList.toSet());
    int percent = (set.length / 9 * 100).toInt();
    return percent;
  }

  String defineRestaurantImage(int number) {
    switch (number) {
      case 21:
        return "assets/burger-2.png";
      case 22:
        return "assets/coffee.png";
      case 23:
        return "assets/pub.png";
      case 24:
        return "assets/restaurant.png";
      case 25:
        return "assets/bar.png";
      case 26:
        return "assets/karaoke.png";
      case 27:
        return "assets/terrace-2.png";
      case 28:
        return "assets/live-streaming.png";
      case 29:
        return "assets/beach.png";
      default:
        return "assets/beach.png";
    }
  }
}
