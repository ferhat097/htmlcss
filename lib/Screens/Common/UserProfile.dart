// ignore_for_file: file_names

import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/UserProfileController.dart';
import 'package:foodmood/Screens/Common/SendAway/SendAway.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail.dart';
import 'package:foodmood/Screens/FoodMoodSocial/SendGiftBottom.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../DarkModeController.dart';
import 'ReportComment.dart';
import 'RestaurantPage/RestaurantPage.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserProfileController userProfileController = Get.put(
    UserProfileController(),
  );
  ProfilePageController profilePageController = Get.find();
  GeneralController generalController = Get.find();

  @override
  void initState() {
    userProfileController.listenUserSocialInfo(widget.userId);
    userProfileController.listenPrensence(widget.userId);
    userProfileController.getUserImages(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: userProfileController.scaffoldState,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: GetBuilder<UserProfileController>(
          builder: (controller) {
            if (controller.userSocial != null) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AppBar(
                    elevation: 0,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: defineTextFieldColor(),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  Get.back();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14, top: 10, bottom: 10, right: 4),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: context.iconColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: controller.userSocial!["premium"] ?? false
                        ? const Color(0xFFe1ad21).withOpacity(0.5)
                        : context.theme.backgroundColor.withOpacity(0.3),
                    title: Text(
                      controller.userSocial!["userName"] ?? "",
                      style: GoogleFonts.quicksand(color: defineWhiteBlack()),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: defineTextFieldColor(),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    Get.bottomSheet(
                                      SendGiftBottom(
                                        fromConversation: false,
                                        userOrConversationId:
                                            controller.userSocial!["userId"],
                                        user: controller.userSocial!,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/gift.png",
                                      scale: 20,
                                      //color: defineWhiteBlack(),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      body: GetBuilder<UserProfileController>(
        builder: (controller) {
          if (controller.userSocial != null) {
            List blockedUsers = controller.userSocial!["blockedUsers"] ?? [];
            if (blockedUsers.contains(FirebaseAuth.instance.currentUser!.uid)) {
              return const Center(
                child: Text("Istifadəçi sizi blok edib"),
              );
            } else {
              return RefreshIndicator(
                onRefresh: userProfileController.onRefresh,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 80,
                      // ),
                      SizedBox(
                        height: 350,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: ClipRRect(
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      controller
                                              .userSocial!["backgroundImage"] ??
                                          "",
                                      cacheKey: controller
                                              .userSocial!["backgroundImage"] ??
                                          ""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 120,
                              // child: Text("Restorana bax",s),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent[400],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      if (controller.userSocial![
                                              "specialBackground"] ??
                                          false) {
                                      } else {
                                        if (controller.userSocial![
                                                "backgroundRestaurant"] !=
                                            null) {
                                          Get.to(
                                            () => RestaurantPage(
                                              restaurantId:
                                                  controller.userSocial![
                                                      "backgroundRestaurant"],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.touch_app,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 200,
                              right: 20,
                              left: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          controller.userSocial!["premium"] ??
                                                  false
                                              ? const Color(0xFFe1ad21)
                                                  .withOpacity(0.5)
                                              : context.theme.primaryColor
                                                  .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              controller.userSocial!["name"] ??
                                                  "",
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Builder(
                                              builder: (context) {
                                                if (controller.userSocial![
                                                        "birthday"] !=
                                                    null) {
                                                  DateTime birthday = controller
                                                      .userSocial!["birthday"]
                                                      .toDate();
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5),
                                                        child: Container(
                                                          height: 5,
                                                          width: 5,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: context
                                                                  .theme
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                      Text(
                                                        (birthday
                                                                    .difference(
                                                                      DateTime
                                                                          .now(),
                                                                    )
                                                                    .inDays /
                                                                365)
                                                            .abs()
                                                            .toStringAsFixed(0)
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child:
                                              GetBuilder<UserProfileController>(
                                            builder: (controller) {
                                              if (controller.userSocial !=
                                                  null) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 50,
                                                      ),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          onTap: () {
                                                            Get.dialog(
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Material(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: context
                                                                            .theme
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          50,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 20),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 80,
                                                                              width: 80,
                                                                              child: Image.asset(
                                                                                "assets/healthy-food.png",
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              "Bu nədir?",
                                                                              style: GoogleFonts.quicksand(
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 18,
                                                                                color: context.iconColor,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              generalController.foodSocial["whatIsLike"],
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
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${controller.userSocial!["likerTime"] ?? 0}",
                                                                style: GoogleFonts.quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "Bəyənildi",
                                                                style: GoogleFonts
                                                                    .quicksand(),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                      child: VerticalDivider(),
                                                    ),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.dialog(
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Material(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: context
                                                                          .theme
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        50,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                80,
                                                                            width:
                                                                                80,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/wave.png",
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            "Bu nədir?",
                                                                            style:
                                                                                GoogleFonts.quicksand(
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 18,
                                                                              color: context.iconColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            generalController.foodSocial["whatIsHere"],
                                                                            style:
                                                                                GoogleFonts.quicksand(
                                                                              color: context.iconColor,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${controller.userSocial!["hereTime"] ?? 0}",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                color: context
                                                                    .iconColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 26,
                                                              width: 26,
                                                              child:
                                                                  Image.asset(
                                                                'assets/wave.png',
                                                              ),
                                                            )
                                                            // Text(
                                                            //   "Burdayam",
                                                            //   style: GoogleFonts
                                                            //       .encodeSans(
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold,
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                      child: VerticalDivider(),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 50,
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.dialog(
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Material(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: context
                                                                            .theme
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          50,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 20),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 80,
                                                                              width: 80,
                                                                              child: Image.asset(
                                                                                "assets/gift.png",
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              "Bu nədir?",
                                                                              style: GoogleFonts.quicksand(
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 18,
                                                                                color: context.iconColor,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              generalController.foodSocial["whatIsGift"],
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
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${controller.userSocial!["gifts"] ?? 0}",
                                                                style: GoogleFonts.quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "Hədiyyə",
                                                                style: GoogleFonts
                                                                    .quicksand(),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox();
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
                              top: 150,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller.presenceModel !=
                                                  null
                                              ? controller.defineCircularColor(
                                                  controller.userSocial![
                                                          "showOnline"] ??
                                                      false,
                                                  controller.userSocial![
                                                          "premium"] ??
                                                      false,
                                                  controller
                                                      .presenceModel!.online)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                              controller.userSocial![
                                                      "userPhoto"] ??
                                                  "",
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
                      const SizedBox(
                        height: 10,
                      ),
                      GetBuilder<UserProfileController>(
                        builder: (controller) {
                          if (controller.userSocial!["foodMoodSocial"] ??
                              false) {
                            List likedList = profilePageController.meSocial!
                                .data()!["likedUsers"];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: IgnorePointer(
                                        ignoring: false,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: likedList.contains(controller
                                                    .userSocial!["userId"])
                                                ? context.theme.primaryColor
                                                : Colors.pink,
                                            borderRadius: controller
                                                    .userSocial!["isMessaging"]
                                                ? const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  )
                                                : const BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                          ),
                                          child: Material(
                                            borderRadius: controller
                                                    .userSocial!["isMessaging"]
                                                ? const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  )
                                                : const BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: controller
                                                          .userSocial![
                                                      "isMessaging"]
                                                  ? const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    )
                                                  : const BorderRadius.all(
                                                      Radius.circular(5)),
                                              onTap: () {
                                                List likedList =
                                                    profilePageController
                                                        .meSocial!
                                                        .data()!["likedUsers"];
                                                if (likedList.contains(
                                                    controller.userSocial![
                                                        "userId"])) {
                                                  controller.dislike(controller
                                                      .userSocial!["userId"]);
                                                } else {
                                                  controller.like(controller
                                                      .userSocial!["userId"]);
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: likedList.contains(
                                                                  controller
                                                                          .userSocial![
                                                                      "userId"])
                                                              ? Colors.pink
                                                              : context.theme
                                                                  .primaryColor,
                                                        ),
                                                        height: 35,
                                                        width: 35,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Image.asset(
                                                            "assets/healthy-food.png",
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        likedList.contains(
                                                                controller
                                                                        .userSocial![
                                                                    "userId"])
                                                            ? "Bəyəndin"
                                                            : "Bəyən",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: likedList.contains(
                                                                  controller
                                                                          .userSocial![
                                                                      "userId"])
                                                              ? context
                                                                  .iconColor
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    controller.userSocial!["isMessaging"]
                                        ? Flexible(
                                            child: IgnorePointer(
                                              ignoring:
                                                  !controller.checkMessage(
                                                profilePageController.meSocial![
                                                    "foodMoodSocial"],
                                                controller.userSocial![
                                                    "foodMoodSocial"],
                                                profilePageController
                                                    .meSocial!["isRestaurant"],
                                                controller.userSocial![
                                                    "isRestaurant"],
                                                profilePageController.meSocial![
                                                    "isRestaurantId"],
                                                controller.userSocial![
                                                    "isRestaurantId"],
                                              ),
                                              child: Opacity(
                                                opacity:
                                                    controller.checkMessage(
                                                  profilePageController
                                                          .meSocial![
                                                      "foodMoodSocial"],
                                                  controller.userSocial![
                                                      "foodMoodSocial"],
                                                  profilePageController
                                                          .meSocial![
                                                      "isRestaurant"],
                                                  controller.userSocial![
                                                      "isRestaurant"],
                                                  profilePageController
                                                          .meSocial![
                                                      "isRestaurantId"],
                                                  controller.userSocial![
                                                      "isRestaurantId"],
                                                )
                                                        ? 1
                                                        : 0.5,
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.lightBlue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        List blockedUsers =
                                                            controller
                                                                    .userSocial![
                                                                "blockedUsers"];
                                                        if (blockedUsers.contains(
                                                            profilePageController
                                                                .meSocial!
                                                                .id)) {
                                                          Get.snackbar(
                                                              "İstifadəçi sizi blok edib",
                                                              "",
                                                              backgroundColor:
                                                                  Colors.red);
                                                        } else {
                                                          Get.to(
                                                            () => MessageDetail(
                                                              withConversation:
                                                                  false,
                                                              user: controller
                                                                  .userSocial,
                                                              userId: controller
                                                                      .userSocial![
                                                                  "userId"],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Mesaj yaz",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                            // return Center(
                            //   child: Text(
                            //     "FoodMood Social bağlıdır",
                            //     style: GoogleFonts.quicksand(),
                            //   ),
                            // );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // if (userProfileController.userSocial!["isRestaurant"])
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 10),
                      //     child: Container(
                      //       width: double.infinity,
                      //       decoration: BoxDecoration(
                      //           color: context.theme.primaryColor,
                      //           borderRadius: BorderRadius.circular(5)),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Row(
                      //           children: [Text("Restoranda")],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GetBuilder<UserProfileController>(
                          builder: (controller) {
                            if (controller.images.isNotEmpty) {
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.images.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return FocusedMenuHolder(
                                    menuWidth:
                                        MediaQuery.of(context).size.width *
                                            0.40,
                                    blurSize: 5.0,
                                    menuItemExtent: 45,
                                    menuBoxDecoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 100),
                                    animateMenuItems: true,
                                    blurBackgroundColor: Colors.black54,
                                    // Open Focused-Menu on Tap rather than Long Press
                                    menuOffset:
                                        10.0, // Offset value to show menuItem from the selected item
                                    bottomOffsetHeight:
                                        80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                                    menuItems: <FocusedMenuItem>[
                                      // Add Each FocusedMenuItem  for Menu Options
                                      FocusedMenuItem(
                                        backgroundColor: Colors.red,
                                        title: Text(
                                          "Şikayət et",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        trailingIcon: const Icon(
                                          Icons.report,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Get.bottomSheet(
                                            ReportComment(
                                              what: 3,
                                              id1: controller
                                                  .userSocial!["userId"],
                                              id2: controller.images[index].id,
                                              reportedUserId: controller
                                                  .userSocial!["userId"],
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
                                      ),
                                      // FocusedMenuItem(
                                      //   title: Text(
                                      //     "Təklif et",
                                      //     style: GoogleFonts.encodeSans(
                                      //       color: Colors.redAccent,
                                      //     ),
                                      //   ),
                                      //   trailingIcon: const Icon(
                                      //     Icons.send,
                                      //     color: Colors.redAccent,
                                      //   ),
                                      //   onPressed: () async {
                                      //     ///
                                      //   },
                                      // ),
                                    ],
                                    onPressed: () {},
                                    child: OpenContainer(
                                      closedBuilder: (context, func) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    controller.images[index]
                                                        .data()!["imageUrl"],
                                                    cacheKey: controller
                                                        .images[index]
                                                        .data()!["imageUrl"],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                if (controller.images[index]
                                                            .data()![
                                                        "inRestaurant"] ??
                                                    false)
                                                  const Positioned(
                                                    top: 2,
                                                    right: 2,
                                                    child: Icon(
                                                      Icons.location_pin,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      openBuilder: (context, func) {
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Container(
                                              child: Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  controller.images[index]
                                                      .data()!["imageUrl"],
                                                  cacheKey: controller
                                                      .images[index]
                                                      .data()!["imageUrl"],
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: SafeArea(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      100,
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: context
                                                        .theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      100,
                                                    ),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        100,
                                                      ),
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 15,
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 5,
                                                        ),
                                                        child: Icon(
                                                          Icons.arrow_back_ios,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (controller.images[index]
                                                    .data()!["inRestaurant"] ??
                                                false)
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  color: Colors.black54,
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(
                                                              () =>
                                                                  RestaurantPage(
                                                                restaurantId: controller
                                                                        .images[
                                                                            index]
                                                                        .data()![
                                                                    "restaurantId"],
                                                              ),
                                                              preventDuplicates:
                                                                  false,
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child:
                                                                  Image.network(
                                                                controller
                                                                        .images[
                                                                            index]
                                                                        .data()![
                                                                    "restaurantImage"],
                                                                fit: BoxFit
                                                                    .cover,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .medium,
                                                                isAntiAlias:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Text(
                                                                controller
                                                                        .images[
                                                                            index]
                                                                        .data()!["restaurantName"] ??
                                                                    "",
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .location_pin,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  controller
                                                                          .images[
                                                                              index]
                                                                          .data()!["locationName"] ??
                                                                      "",
                                                                  style: GoogleFonts
                                                                      .quicksand(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                  // return Container(
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(2),
                                  //   ),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(2),
                                  //     child: Image.network(
                                  //       controller.images[index]
                                  //           .data()!["imageUrl"],
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // );
                                },
                              );
                            } else {
                              return Text(
                                "Şəkil yoxdur",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
