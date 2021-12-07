// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/FoodMoodSocialController.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:foodmood/Screens/Login/CompleteSignup.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'InviteGame.dart';

class MoodSocial extends StatefulWidget {
  const MoodSocial({Key? key}) : super(key: key);

  @override
  _MoodSocialState createState() => _MoodSocialState();
}

class _MoodSocialState extends State<MoodSocial>
    with AutomaticKeepAliveClientMixin {
  FoodMoodSocialController foodMoodSocialController = Get.find();
  AuthController authController = Get.find();
  GeneralController generalController = Get.find();
  ProfilePageController profilePageController = Get.find();
  // @override
  // void initState() {
  //   foodMoodSocialController.getDuo();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: !authController.activeInternet
          ? Colors.red
          : context.theme.scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<ProfilePageController>(
            id: "foodmoodsocial",
            // assignId: true,
            builder: (controller2) {
              int swipeTime = controller2.meSocial!.data()!["swipeTime"] ?? 0;
              int dailyLimit =
                  controller2.meSocial!.data()!["dailyLimit"] ?? 30;
              if (foodMoodSocialController.firstInit &&
                  controller2.meSocial != null) {
                foodMoodSocialController.getDuo();
              }
              return GetBuilder<FoodMoodSocialController>(
                builder: (controller) {
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
                  }
                  if (controller2.meSocial!.data()!["foodMoodSocial"]) {
                    if (controller2.meSocial!.data()!["allFilled"]) {
                      if (swipeTime >= dailyLimit) {
                        return GetBuilder<GeneralController>(
                          id: "generalfoodsocial",
                          builder: (generalController) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    "assets/dailyLimit.png",
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Siz limitə çatdınız",
                                    style: GoogleFonts.quicksand(
                                      color: context.iconColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: controller.loadingIncreaseLimit,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.green,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await controller.increaseLimit(controller2
                                              .meSocial!
                                              .data()!["dailyIncreased"] ??
                                          0);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: controller.loadingIncreaseLimit
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Image.asset(
                                                  "assets/advertisements.png",
                                                  color: Colors.white,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Limiti artır +${generalController.foodSocial["oneLimitIncrease"]}",
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "${profilePageController.meSocial!.data()!["dailyIncreased"] ?? 0} / ",
                                        style: GoogleFonts.quicksand(
                                          color: context.iconColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${generalController.foodSocial["dailyLimitIncreaseLimit"] ?? 0}",
                                        style: GoogleFonts.quicksand(
                                          color: context.iconColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (!controller.haveMatch) {
                        if (controller.duos.isNotEmpty) {
                          return SwipeCards(
                            matchEngine: controller.matchEngine,
                            onStackFinished: () {
                              controller.getMoreDuos();
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print("tapped");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      border: Border.all(
                                        color: controller.defineAllPercentage(
                                                  controller.duos[index]
                                                          ["allList"] ??
                                                      [],
                                                  controller2.meSocial!
                                                          .data()!["allList"] ??
                                                      [],
                                                ) ==
                                                100
                                            ? Color(0xFFD4AF37)
                                            : Colors.transparent,
                                        width: controller.defineAllPercentage(
                                                  controller.duos[index]
                                                          ["allList"] ??
                                                      [],
                                                  controller2.meSocial!
                                                          .data()!["allList"] ??
                                                      [],
                                                ) ==
                                                100
                                            ? 2
                                            : 0,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.topCenter,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 250,
                                                child: Stack(
                                                  fit: StackFit.loose,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 200,
                                                      child: ClipRRect(
                                                        child: Image.network(
                                                          controller.duos[index]
                                                                  [
                                                                  "backgroundImage"] ??
                                                              "",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 100,
                                                      right: 20,
                                                      left: 20,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 7,
                                                                  sigmaY: 7),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: controller.duos[
                                                                              index]
                                                                          [
                                                                          "premium"] ??
                                                                      false
                                                                  ? Color(0xFFe1ad21)
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : context
                                                                      .theme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            height: 150,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 50,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                              .duos[index]
                                                                          [
                                                                          "name"],
                                                                      style: GoogleFonts
                                                                          .quicksand(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    // Builder(
                                                                    //   builder: (context) {
                                                                    //     if (controller.meSocial!
                                                                    //             .data()!["birthday"] !=
                                                                    //         null) {
                                                                    //       DateTime birthday = controller
                                                                    //           .meSocial!
                                                                    //           .data()!["birthday"]
                                                                    //           .toDate();
                                                                    //       return Row(
                                                                    //         crossAxisAlignment:
                                                                    //             CrossAxisAlignment
                                                                    //                 .center,
                                                                    //         mainAxisAlignment:
                                                                    //             MainAxisAlignment
                                                                    //                 .center,
                                                                    //         children: [
                                                                    //           Padding(
                                                                    //             padding:
                                                                    //                 const EdgeInsets
                                                                    //                         .symmetric(
                                                                    //                     horizontal: 5),
                                                                    //             child: Container(
                                                                    //               height: 5,
                                                                    //               width: 5,
                                                                    //               decoration:
                                                                    //                   BoxDecoration(
                                                                    //                 borderRadius:
                                                                    //                     BorderRadius
                                                                    //                         .circular(
                                                                    //                             10),
                                                                    //                 color: context
                                                                    //                         .isDarkMode
                                                                    //                     ? Colors.white
                                                                    //                     : Colors.black,
                                                                    //               ),
                                                                    //             ),
                                                                    //           ),
                                                                    //           Text(
                                                                    //             (birthday
                                                                    //                         .difference(
                                                                    //                           DateTime
                                                                    //                               .now(),
                                                                    //                         )
                                                                    //                         .inDays /
                                                                    //                     365)
                                                                    //                 .abs()
                                                                    //                 .toStringAsFixed(0)
                                                                    //                 .toString(),
                                                                    //             style: GoogleFonts
                                                                    //                 .quicksand(
                                                                    //               fontWeight:
                                                                    //                   FontWeight.bold,
                                                                    //               fontSize: 16,
                                                                    //             ),
                                                                    //           ),
                                                                    //         ],
                                                                    //       );
                                                                    //     } else {
                                                                    //       return SizedBox();
                                                                    //     }
                                                                    //   },
                                                                    // )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                  ),
                                                                  child: GetBuilder<
                                                                      FoodMoodSocialController>(
                                                                    builder:
                                                                        (controller) {
                                                                      if (controller
                                                                              .duos !=
                                                                          null) {
                                                                        return Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            ConstrainedBox(
                                                                              constraints: const BoxConstraints(
                                                                                minWidth: 50,
                                                                              ),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                constraints: BoxConstraints(
                                                                                  minWidth: 50,
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    vertical: 4,
                                                                                    horizontal: 10,
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${controller.duos[index]["likerTime"] ?? 0}",
                                                                                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                      ),
                                                                                      Text(
                                                                                        "Bəyənildi",
                                                                                        style: GoogleFonts.quicksand(),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                              child: VerticalDivider(),
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Text(
                                                                                  "${controller.duos[index]["hereTime"] ?? 0}",
                                                                                  style: GoogleFonts.quicksand(color: context.iconColor, fontWeight: FontWeight.bold, fontSize: 22),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 26,
                                                                                  width: 26,
                                                                                  child: Image.asset(
                                                                                    'assets/wave.png',
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                              child: VerticalDivider(),
                                                                            ),
                                                                            ConstrainedBox(
                                                                              constraints: BoxConstraints(
                                                                                minWidth: 50,
                                                                              ),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                constraints: BoxConstraints(
                                                                                  minWidth: 50,
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    vertical: 4,
                                                                                    horizontal: 10,
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${controller.duos[index]["gifts"] ?? 0}",
                                                                                        style: GoogleFonts.quicksand(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 20,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        "Hədiyyə",
                                                                                        style: GoogleFonts.quicksand(),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      } else {
                                                                        return SizedBox();
                                                                      }
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 50,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            25,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: controller.duos[index]
                                                                              [
                                                                              "premium"] ??
                                                                          false
                                                                      ? Color(
                                                                          0xFFe1ad21)
                                                                      : Colors.blue[
                                                                          900],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      100,
                                                                    ),
                                                                    onTap: () {
                                                                      Get.to(
                                                                        () =>
                                                                            UserProfile(
                                                                          userId:
                                                                              controller.duos[index]["userId"],
                                                                        ),
                                                                        transition:
                                                                            Transition.size,
                                                                        preventDuplicates:
                                                                            false,
                                                                      );
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 100,
                                                                              width: 100,
                                                                              child: Image.network(
                                                                                controller.duos[index]["userPhoto"],
                                                                                filterQuality: FilterQuality.low,
                                                                                isAntiAlias: false,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // CircleAvatar(
                                                                          //   radius: 50,
                                                                          //   backgroundImage: NetworkImage(
                                                                          //     controller.me!
                                                                          //         .data()!["userPhoto"],

                                                                          //   ),
                                                                          // ),
                                                                          // Positioned(
                                                                          //   bottom: 0,
                                                                          //   right: 0,
                                                                          //   child: Container(
                                                                          //     decoration: BoxDecoration(
                                                                          //       borderRadius:
                                                                          //           BorderRadius.circular(
                                                                          //         50,
                                                                          //       ),
                                                                          //       color: Colors.blue,
                                                                          //       border: Border.all(
                                                                          //         width: 2,
                                                                          //         color: context
                                                                          //             .theme.primaryColor
                                                                          //             .withOpacity(0.3),
                                                                          //       ),
                                                                          //     ),
                                                                          //     child: Padding(
                                                                          //       padding:
                                                                          //           EdgeInsets.all(3.0),
                                                                          //       child: Icon(
                                                                          //         Icons.add,
                                                                          //         color: Colors.white,
                                                                          //       ),
                                                                          //     ),
                                                                          //   ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                  right: 5,
                                                  left: 5,
                                                  bottom: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    onTap: () {
                                                      Get.to(
                                                        () => UserProfile(
                                                          userId: controller
                                                                  .duos[index]
                                                              ["userId"],
                                                        ),
                                                        transition:
                                                            Transition.size,
                                                        preventDuplicates:
                                                            false,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Profilə bax",
                                                          style: GoogleFonts
                                                              .encodeSans(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                  top: 0,
                                                  right: 5,
                                                  left: 5,
                                                  bottom: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    onTap: () {
                                                      // Get.bottomSheet(
                                                      //   InviteGame(),
                                                      //   isScrollControlled:
                                                      //       true,
                                                      //   backgroundColor: context
                                                      //       .theme.canvasColor,
                                                      //   shape:
                                                      //       const RoundedRectangleBorder(
                                                      //     borderRadius:
                                                      //         BorderRadius.only(
                                                      //       topLeft:
                                                      //           Radius.circular(
                                                      //               20),
                                                      //       topRight:
                                                      //           Radius.circular(
                                                      //               20),
                                                      //     ),
                                                      //   ),
                                                      // );
                                                      Get.snackbar(
                                                        "Tezliklə",
                                                        "Tezliklə FoodMood-un təklif etdiyi əyləncəli və qazandırıcı oyunları dostlarınızla və digər insanlarla oynaya biləcəksiniz!",
                                                        backgroundColor:
                                                            Colors.pink,
                                                        borderRadius: 5,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Oyuna dəvət et",
                                                          style: GoogleFonts
                                                              .encodeSans(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Tese(
                                              //   foodPercent:
                                              //       controller.defineFoodPercentage(
                                              //     controller.duos[index]
                                              //             ["foodList"] ??
                                              //         [],
                                              //     controller2.meSocial!
                                              //             .data()!["foodList"] ??
                                              //         [],
                                              //   ),
                                              //   drinkPercent: controller
                                              //       .defineDrinkPercentage(
                                              //     controller.duos[index]
                                              //             ["foodList"] ??
                                              //         [],
                                              //     controller2.meSocial!
                                              //             .data()!["foodList"] ??
                                              //         [],
                                              //   ),
                                              //   restaurantPercent: controller
                                              //       .defineRestaurantPercentage(
                                              //     controller.duos[index]
                                              //             ["foodList"] ??
                                              //         [],
                                              //     controller2.meSocial!
                                              //             .data()!["foodList"] ??
                                              //         [],
                                              //   ),
                                              // ),

                                              //yemek-icmek
                                              GetBuilder<GeneralController>(
                                                id: "generalfoodsocial",
                                                builder: (controller4) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 5,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: context
                                                                      .isDarkMode
                                                                  ? HexColor(controller4
                                                                          .foodSocial[
                                                                      "swipeFoodColorDark"])
                                                                  : HexColor(controller4
                                                                          .foodSocial[
                                                                      "swipeFoodColor"]),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/sushi-2.png",
                                                                    scale: 5,
                                                                  ),
                                                                  Text(
                                                                    """Yemək - ${controller.defineFoodPercentage(
                                                                      controller.duos[index]
                                                                              [
                                                                              "foodList"] ??
                                                                          [],
                                                                      controller2
                                                                              .meSocial!
                                                                              .data()!["foodList"] ??
                                                                          [],
                                                                    )}%""",
                                                                    style: GoogleFonts
                                                                        .quicksand(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: context
                                                                      .isDarkMode
                                                                  ? HexColor(
                                                                      controller4
                                                                              .foodSocial[
                                                                          "swipeDrinkColorDark"],
                                                                    )
                                                                  : HexColor(
                                                                      controller4
                                                                              .foodSocial[
                                                                          "swipeDrinkColor"],
                                                                    ),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/cocktail.png",
                                                                    scale: 5,
                                                                  ),
                                                                  Text(
                                                                    """İçmək - ${controller.defineDrinkPercentage(
                                                                      controller.duos[index]
                                                                              [
                                                                              "drinkList"] ??
                                                                          [],
                                                                      controller2
                                                                              .meSocial!
                                                                              .data()!["drinkList"] ??
                                                                          [],
                                                                    )}%""",
                                                                    style: GoogleFonts
                                                                        .quicksand(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              //restoranlar
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  right: 5,
                                                  left: 5,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        context.theme.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Image.asset(
                                                          controller
                                                              .defineRestaurantImage(
                                                            controller.duos[index]
                                                                        [
                                                                        "restaurantList"] !=
                                                                    null
                                                                ? controller.duos[
                                                                        index][
                                                                    "restaurantList"][0]
                                                                : 22,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Image.asset(
                                                          controller
                                                              .defineRestaurantImage(
                                                            controller.duos[index]
                                                                        [
                                                                        "restaurantList"] !=
                                                                    null
                                                                ? controller.duos[
                                                                        index][
                                                                    "restaurantList"][1]
                                                                : 24,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Image.asset(
                                                          controller
                                                              .defineRestaurantImage(
                                                            controller.duos[index]
                                                                        [
                                                                        "restaurantList"] !=
                                                                    null
                                                                ? controller.duos[
                                                                        index][
                                                                    "restaurantList"][2]
                                                                : 27,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${controller.defineAllPercentage(
                                                          controller.duos[index]
                                                                  ["allList"] ??
                                                              [],
                                                          controller2.meSocial!
                                                                      .data()![
                                                                  "allList"] ??
                                                              [],
                                                        )}%",
                                                        style: GoogleFonts
                                                            .encodeSans(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // _buildDistanceTrackerExample(context),
                                              //imagesFilled(),
                                              //_buildTextLabels(context),
                                              //Text("Restoran zovqleriviz x faiz"),
                                              // Material(
                                              //   child: InkWell(
                                              //     onTap: () {
                                              //       int percent = controller
                                              //           .defineFoodPercentage(
                                              //         controller.duos[index]
                                              //             ["foodList"],
                                              //         controller2.meSocial!
                                              //             .data()!["foodList"],
                                              //       );
                                              //       print(percent);
                                              //     },
                                              //   ),
                                              // ),
                                              const SizedBox(
                                                height: 100,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                //     stops: [
                                                //   0.5,
                                                //   0.8,
                                                // ],
                                                colors: [
                                                  Get.isDarkMode
                                                      ? Colors.black
                                                          .withOpacity(0.96)
                                                      : Colors.white
                                                          .withOpacity(0.96),
                                                  Get.isDarkMode
                                                      ? Colors.black
                                                          .withOpacity(0.5)
                                                      : Colors.white
                                                          .withOpacity(0.5),
                                                  context.theme.primaryColor
                                                      .withOpacity(0.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: controller
                                                      .defineLikeColor(
                                                    controller2.meSocial!
                                                                .data()![
                                                            "likedUsers"] ??
                                                        [],
                                                    controller2.meSocial!
                                                                .data()![
                                                            "likerUsers"] ??
                                                        [],
                                                    controller.duos[index]
                                                        ["userId"],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Material(
                                                  color: controller
                                                      .defineLikeColor(
                                                    controller2.meSocial!
                                                                .data()![
                                                            "likedUsers"] ??
                                                        [],
                                                    controller2.meSocial!
                                                                .data()![
                                                            "likerUsers"] ??
                                                        [],
                                                    controller.duos[index]
                                                        ["userId"],
                                                  ),
                                                  elevation: 3,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    onTap: () {
                                                      controller.matchEngine
                                                          .currentItem!
                                                          .like();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: controller
                                                          .defineLikeButton(
                                                        controller2.meSocial!
                                                                    .data()![
                                                                "likedUsers"] ??
                                                            [],
                                                        controller2.meSocial!
                                                                    .data()![
                                                                "likerUsers"] ??
                                                            [],
                                                        controller.duos[index]
                                                            ["userId"],
                                                        controller.duos[index]
                                                            ["allList"],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //const SizedBox(width: 30),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      context.theme.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Material(
                                                  elevation: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color:
                                                      context.theme.cardColor,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    onTap: () {
                                                      controller.matchEngine
                                                          .currentItem!
                                                          .nope();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: controller
                                                                  .defineLikeType(
                                                                controller2.meSocial!
                                                                            .data()![
                                                                        "likedUsers"] ??
                                                                    [],
                                                                controller2.meSocial!
                                                                            .data()![
                                                                        "likerUsers"] ??
                                                                    [],
                                                                controller.duos[
                                                                        index]
                                                                    ["userId"],
                                                              ) ==
                                                              1
                                                          ? Icon(
                                                              Icons.close,
                                                              size: 50,
                                                              color: context
                                                                  .iconColor,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: 50,
                                                              color: context
                                                                  .iconColor,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bugünlük buqədər",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.pink,
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.pink,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        if (!controller2.meSocial!
                                            .data()!["foodMoodSocial"]) {
                                          Get.snackbar(
                                            "FoodMood Social aktiv deyil!",
                                            "Profil səhifəsindən ayarlar bölməsindən FoodMood Social ayarlarında aktiv edə bilərsiniz.",
                                            duration:
                                                const Duration(seconds: 5),
                                            dismissDirection:
                                                SnackDismissDirection
                                                    .HORIZONTAL,
                                          );
                                        } else {
                                          if (!controller2.meSocial!
                                              .data()!["allFilled"]) {
                                            Get.snackbar(
                                              "FoodMood Social məlumatları tamamlanmanyıb!",
                                              "Profil səhifəsindən ayarlar bölməsindən FoodMood Social ayarlarında məlumatları tamamlaya bilərsiniz.",
                                              duration:
                                                  const Duration(seconds: 5),
                                              dismissDirection:
                                                  SnackDismissDirection
                                                      .HORIZONTAL,
                                            );
                                          } else {
                                            controller.getDuo();
                                          }
                                        }
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/mathbackground-2.png"),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          height: double.infinity,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 10,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Image.network(
                                            controller
                                                .matchedUser!["userPhoto"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      controller.matchedUser!["name"],
                                      style: GoogleFonts.encodeSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${controller.matchedUser!["name"]} da sizinlə \n restorana getmək istəyir",
                                      style: GoogleFonts.encodeSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          onTap: () {
                                            controller.writeMessage();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              "Mesaj yaz",
                                              style: GoogleFonts.encodeSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          onTap: () {
                                            controller.writeMessage();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Davam et",
                                              style: GoogleFonts.encodeSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: context.iconColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ConfettiWidget(
                                  numberOfParticles: 20,
                                  emissionFrequency: 0.05,
                                  maxBlastForce: 30,
                                  minBlastForce: 15,
                                  confettiController:
                                      controller.controllerCenter,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  shouldLoop:
                                      true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ], // manually specify the colors to be used
                                  createParticlePath: controller
                                      .drawStar, // define a custom shape/path.
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ConfettiWidget(
                                  numberOfParticles: 20,
                                  emissionFrequency: 0.05,
                                  maxBlastForce: 30,
                                  minBlastForce: 15,
                                  confettiController:
                                      controller.controllerCenterLeft,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  shouldLoop:
                                      true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ], // manually specify the colors to be used
                                  createParticlePath: controller
                                      .drawStar, // define a custom shape/path.
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "FoodMood Social məlumatlarınızı tamamlayın",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => CompleteSignUp(
                                    username: controller2.meSocial!
                                        .data()!["userName"],
                                    name: controller2.meSocial!.data()!["name"],
                                    photoUrl: "photoUrl",
                                    userId: "userId",
                                  ),
                                );
                              },
                              child: Text(
                                "Məlumatları tamamla",
                                style: GoogleFonts.quicksand(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        "FoodMood Social aktiv deyil\n Ayarlardan aktiv edə bilərsiniz",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              );
            },
          ),
          Positioned(
            top: 20,
            right: 0,
            child: GetBuilder<GeneralController>(
              id: "generalfoodsocial",
              builder: (controller) {
                if (generalController.foodSocial["seenAdsRequiredPercent"] ??
                    true) {
                  return Container(
                    decoration: BoxDecoration(
                      color: HexColor(
                        generalController.foodSocial["percentLabelColor"],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                    ),
                    height: 40,
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        ),
                        onTap: () {
                          Get.dialog(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.asset(
                                            "assets/advertisements.png",
                                            color: context.iconColor,
                                          ),
                                        ),
                                        Text(
                                          "Bu nədir?",
                                          style: GoogleFonts.quicksand(
                                            color: context.iconColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          generalController
                                              .foodSocial["whatIsAdsPercent"],
                                          style: GoogleFonts.quicksand(
                                            color: context.iconColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/advertisements.png",
                                color: HexColor(
                                  generalController
                                      .foodSocial["percentLabelTextColor"],
                                ),
                              ),
                            ),
                            Text(
                              generalController.foodSocial["adsRequired"] == 0
                                  ? "Free"
                                  : "${generalController.foodSocial["adsRequired"]}%",
                              style: GoogleFonts.encodeSans(
                                color: HexColor(
                                  generalController
                                      .foodSocial["percentLabelTextColor"],
                                ),
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (generalController.foodSocial["adsRequired"] !=
                                0)
                              Icon(
                                Icons.arrow_downward,
                                color: HexColor(
                                  generalController
                                      .foodSocial["percentLabelTextColor"],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            child: GetBuilder<FoodMoodSocialController>(
              builder: (foodmoodsocial) {
                if (foodmoodsocial.duos.isEmpty) {
                  return const SizedBox();
                } else {
                  return GetBuilder<ProfilePageController>(
                    id: "foodmoodsocial",
                    builder: (controller2) {
                      return GetBuilder<GeneralController>(
                        id: "generalfoodsocial",
                        builder: (controller) {
                          if (generalController.foodSocial["seenDailyLimit"] ??
                              true) {
                            return Container(
                              decoration: BoxDecoration(
                                color: HexColor(
                                  generalController
                                      .foodSocial["limitLabelColor"],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              height: 40,
                              child: Material(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  onTap: () {
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
                                                color:
                                                    context.theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.asset(
                                                      "assets/dailyLimit.png",
                                                    ),
                                                  ),
                                                  Text(
                                                    "Bu nədir?",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: context.iconColor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    generalController
                                                            .foodSocial[
                                                        "whatIsLimit"],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: context.iconColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "assets/dailyLimit.png",
                                          //color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${profilePageController.meSocial!.data()!["swipeTime"] ?? 0}/",
                                        style: GoogleFonts.encodeSans(
                                          color: HexColor(
                                            generalController.foodSocial[
                                                "limitLabelTextColor"],
                                          ),
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "${profilePageController.meSocial!.data()!["dailyLimit"] ?? 30}",
                                        style: GoogleFonts.encodeSans(
                                          color: HexColor(
                                            generalController.foodSocial[
                                                "limitLabelTextColor"],
                                          ),
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            child: GetBuilder<ProfilePageController>(
                id: "foodmoodsocial",
                builder: (controller2) {
                  return GetBuilder<GeneralController>(
                    id: "generalfoodsocial",
                    builder: (controller) {
                      if (generalController.foodSocial["seenGameLimit"] ??
                          false) {
                        return Container(
                          decoration: BoxDecoration(
                            color: HexColor(
                              generalController.foodSocial["limitLabelColor"],
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          height: 40,
                          child: Material(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              onTap: () {
                                Get.dialog(
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: context.theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset(
                                                  "assets/dailyLimit.png",
                                                ),
                                              ),
                                              Text(
                                                "Bu nədir?",
                                                style: GoogleFonts.quicksand(
                                                  color: context.iconColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                generalController
                                                    .foodSocial["whatIsLimit"],
                                                style: GoogleFonts.quicksand(
                                                  color: context.iconColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      "assets/crystal-ball.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${profilePageController.meSocial!.data()!["dailyLimit"]}",
                                    style: GoogleFonts.encodeSans(
                                      color: HexColor(
                                        generalController
                                            .foodSocial["limitLabelTextColor"],
                                      ),
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
