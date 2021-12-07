// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ResultController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:foodmood/Screens/FoodMoodSocial/JoinPromotion.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';

import 'PromotionInfo.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> with AutomaticKeepAliveClientMixin {
  ProfilePageController profilePageController = Get.find();
  ResultController resultController = Get.find();
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<AuthController>(
      id: "internet",
      builder: (authController) {
        if (!authController.activeInternet) {
          return Center(
            child: Text(
              "Aktiv internet bağlantısı yoxdur!",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<ProfilePageController>(
                  id: "resultPage",
                  builder: (controller3) {
                    if (controller3.meSocial != null) {
                      if (resultController.firstInit) {
                        print("gettedMostPopular");
                        resultController.getMostPopular();
                      }
                    }
                    return GetBuilder<ResultController>(
                      builder: (controller) {
                        if (controller.mostPopular.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.mostPopular.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 0,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => UserProfile(
                                            userId: controller
                                                .mostPopular[index]["userId"],
                                          ),
                                          preventDuplicates: false,
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                  controller.mostPopular[index]
                                                      ["userPhoto"],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            controller.mostPopular[index]
                                                ["name"],
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.pink,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.pink,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () async {
                                    await controller.getMostPopular();
                                  },
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const Divider(),
                GetBuilder<GeneralController>(
                  id: "generaladControll",
                  builder: (controller) {
                    if (controller.adControll.isNotEmpty) {
                      if (controller.adControll["isResultPageBanner"]) {
                        return FutureBuilder<AdWidget>(
                          future: resultController.loadAds(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: snap.data!,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                GetBuilder<ResultController>(
                  builder: (controller) {
                    if (controller.promotion.isNotEmpty) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.promotion.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Material(
                                  color: HexColor(
                                    controller.promotion[index]["color"] ??
                                        "de5037",
                                  ),
                                  elevation: 5,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        PromotionInfo(
                                          promotion:
                                              controller.promotion[index],
                                        ),
                                        isScrollControlled: true,
                                        backgroundColor:
                                            context.theme.canvasColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  controller.promotion[index]
                                                          ["promotionName"] ??
                                                      "",
                                                  style: GoogleFonts.encodeSans(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .defineStartedColor(
                                                      controller.promotion[
                                                                  index][
                                                              "startedStatus"] ??
                                                          3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      100,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (controller.promotion[index]
                                                  ["withTime"] ??
                                              false)
                                            GetBuilder<ResultController>(
                                                id: "time",
                                                builder: (controller) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      bottom: 10,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Bitməsinə",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${controller.defineEndedTime(
                                                            controller.promotion[
                                                                    index]
                                                                ["endedTime"],
                                                          )} ",
                                                          style: GoogleFonts
                                                              .encodeSans(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })
                                          else
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Bitməsinə",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${controller.promotion[index]["joinForEnded"] - controller.promotion[index]["joinedUsers"]} ",
                                                          style: GoogleFonts
                                                              .encodeSans(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "nəfər",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.person),
                                                      Text(
                                                        "${controller.promotion[index]["joinedUsers"] ?? 0}",
                                                        style: GoogleFonts
                                                            .encodeSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Builder(builder: (context) {
                                  List joinedUsers = controller.promotion[index]
                                          ["joinedList"] ??
                                      [];
                                  if (!joinedUsers.contains(
                                      FirebaseAuth.instance.currentUser!.uid)) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 60),
                                      height: 100,
                                      width: double.infinity,
                                      child: Stack(
                                        fit: StackFit.loose,
                                        alignment: Alignment.center,
                                        children: [
                                          Material(
                                            elevation: 2,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    profilePageController
                                                                .meSocial!
                                                                .data()![
                                                            "userPhoto"] ??
                                                        "",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 120),
                                            child: Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color:
                                                    context.theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 120),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFde5037),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xFFde5037),
                                                    blurRadius: 3.0,
                                                    offset: Offset(-1.0, 0),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 1.0,
                                                    offset: Offset(0.0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(
                                                        0xFFde5037), // Colors.black,
                                                  ),
                                                  height: 100,
                                                  width: 100,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    child: Image.asset(
                                                      "assets/anonymous-3.png",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return FutureBuilder<Map<String, dynamic>>(
                                      future: controller.getJoinedInfo(
                                        controller.promotion[index]
                                                ["promotionId"] ??
                                            "",
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String userPhoto;
                                          if (snapshot.data!["from"] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid) {
                                            userPhoto =
                                                snapshot.data!["toPhoto"] ?? "";
                                          } else {
                                            userPhoto =
                                                snapshot.data!["fromPhoto"] ??
                                                    "";
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              String userId;
                                              if (snapshot.data!["from"] ==
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid) {
                                                userId = snapshot.data!["to"];
                                              } else {
                                                userId = snapshot.data!["from"];
                                              }
                                              Get.to(
                                                () =>
                                                    UserProfile(userId: userId),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 60),
                                                  height: 100,
                                                  width: double.infinity,
                                                  child: Stack(
                                                    fit: StackFit.loose,
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Material(
                                                        elevation: 2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            100,
                                                          ),
                                                          child: SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                profilePageController
                                                                        .meSocial!
                                                                        .data()!["userPhoto"] ??
                                                                    "",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 120,
                                                        ),
                                                        child: Container(
                                                          height: 120,
                                                          width: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: context.theme
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              100,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 120),
                                                        child: Material(
                                                          elevation: 2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                        // Colors.black,
                                                                        ),
                                                                height: 100,
                                                                width: 100,
                                                                child: Image(
                                                                  image:
                                                                      CachedNetworkImageProvider(
                                                                    userPhoto,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          "${snapshot.data!["from"] != FirebaseAuth.instance.currentUser!.uid ? snapshot.data!["toName"] : snapshot.data!["fromName"]}",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            context.iconColor,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " ilə",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            context.iconColor,
                                                      ),
                                                    )
                                                  ]),
                                                )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    );
                                  }
                                }),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${controller.promotion[index]["award"] ?? 0} ${controller.promotion[index]["currency"] ?? "AZN"}",
                                        style: GoogleFonts.encodeSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Builder(builder: (context) {
                                        List joinedList =
                                            controller.promotion[index]
                                                    ["joinedList"] ??
                                                [];
                                        if (!joinedList.contains(FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                bool premiumRequired = controller
                                                            .promotion[index]
                                                        ["premiumRequired"] ??
                                                    false;
                                                if (premiumRequired) {
                                                  bool meisPremium =
                                                      profilePageController
                                                          .meSocial!
                                                          .data()!["premium"];
                                                  if (meisPremium) {
                                                    bool active = controller
                                                                .promotion[
                                                            index]["active"] ??
                                                        false;
                                                    int status = controller
                                                                    .promotion[
                                                                index]
                                                            ["startedStatus"] ??
                                                        false;
                                                    if (active && status == 1) {
                                                      List joinedList =
                                                          controller.promotion[
                                                                      index][
                                                                  "joinedList"] ??
                                                              [];
                                                      if (!joinedList.contains(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)) {
                                                        print(controller
                                                                    .promotion[
                                                                index]
                                                            ["promotionId"]);
                                                        print(controller
                                                            .promotion[index]);
                                                        Get.bottomSheet(
                                                          JoinPromotion(
                                                            promotionId: controller
                                                                        .promotion[
                                                                    index]
                                                                ["promotionId"],
                                                            joinedList:
                                                                joinedList,
                                                            promotion: controller
                                                                    .promotion[
                                                                index],
                                                          ),
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              context.theme
                                                                  .canvasColor,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Get.snackbar(
                                                          "Siz artıq bu yarışmaya qoşulubsunuz",
                                                          "",
                                                          backgroundColor:
                                                              Colors.red,
                                                        );
                                                      }
                                                    } else {
                                                      return Get.snackbar(
                                                        "Yarışma aktiv deyil!",
                                                        "",
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                    }
                                                  } else {
                                                    return Get.snackbar(
                                                      "Bu yarışmaya ancaq premium istifadəçilər qoşula bilər!",
                                                      "Dəvət etdiyiniz istifadəçinin premium olması tələb olunmur!",
                                                      backgroundColor:
                                                          Colors.red,
                                                    );
                                                  }
                                                } else {
                                                  bool active = controller
                                                              .promotion[index]
                                                          ["active"] ??
                                                      false;
                                                  int status = controller
                                                              .promotion[index]
                                                          ["startedStatus"] ??
                                                      false;
                                                  if (active && status == 1) {
                                                    List joinedList = controller
                                                                    .promotion[
                                                                index]
                                                            ["joinedList"] ??
                                                        [];
                                                    if (!joinedList.contains(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)) {
                                                      print(controller
                                                              .promotion[index]
                                                          ["promotionId"]);
                                                      print(controller
                                                          .promotion[index]);
                                                      Get.bottomSheet(
                                                        JoinPromotion(
                                                          promotionId: controller
                                                                      .promotion[
                                                                  index]
                                                              ["promotionId"],
                                                          joinedList:
                                                              joinedList,
                                                          promotion: controller
                                                              .promotion[index],
                                                        ),
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor: context
                                                            .theme.canvasColor,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Get.snackbar(
                                                        "Siz artıq bu yarışmaya qoşulubsunuz",
                                                        "",
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                    }
                                                  } else {
                                                    return Get.snackbar(
                                                      "Yarışma aktiv deyil!",
                                                      "",
                                                      backgroundColor:
                                                          Colors.red,
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }
                                      })
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: HexColor(
                                      controller.promotion[index]["color"],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Material(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      onTap: () {
                                        bool fromFoodMood = controller
                                            .promotion[index]["fromFoodMood"];
                                        if (fromFoodMood) {
                                          Get.dialog(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Material(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .theme.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            100,
                                                          ),
                                                          child: SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child:
                                                                Image.network(
                                                              controller.promotion[
                                                                      index][
                                                                  "sponsorImage"],
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "FoodMood TM",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: context
                                                                .iconColor,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Yarışma FoodMood TM - in sponsorluğu ilə keçirilir!",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: context
                                                                .iconColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          int sponsorType = controller
                                              .promotion[index]["sponsorType"];
                                          if (sponsorType == 1) {
                                            String restaurantId = controller
                                                .promotion[index]["sponsorId"];
                                            Get.to(
                                              () => RestaurantPage(
                                                  restaurantId: restaurantId),
                                              preventDuplicates: false,
                                            );
                                          } else {
                                            String userId = controller
                                                .promotion[index]["sponsorId"];
                                            Get.to(
                                              () => UserProfile(userId: userId),
                                              preventDuplicates: false,
                                            );
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        controller.promotion[
                                                                    index][
                                                                "sponsorImage"] ??
                                                            "",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.promotion[index]
                                                      ["sponsorName"],
                                                  style: GoogleFonts.encodeSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ), //restoran veya sexs
                                                Text(
                                                  controller.promotion[index]
                                                      ["sponsorSlogan"],
                                                  style: GoogleFonts.quicksand(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
