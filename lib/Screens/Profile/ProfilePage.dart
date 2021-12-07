// ignore_for_file: file_names

import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/MainController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Profile/AddPhotoBottom.dart';
import 'package:foodmood/Screens/Profile/BackgroundPhotoOptions.dart';
import 'package:foodmood/Screens/Profile/ChangeProfilePictureBottomSheet.dart';
import 'package:foodmood/Screens/Profile/MoodXBottom.dart';
import 'package:foodmood/Screens/Profile/SettingBottom.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilePageController profilePageController = Get.find();
  MainController mainController = Get.find();
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (authController.activeInternet) {
            bool? photoAdded = await Get.bottomSheet<bool>(
              const AddPhotoBottom(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              backgroundColor: context.theme.canvasColor,
              isScrollControlled: true,
            );
          } else {
            Get.snackbar(
              "Internet bağlantısı yoxdur!",
              "Cihazınızın internetə bağlı olduğuna əmin olun.",
              backgroundColor: Colors.red.withOpacity(0.8),
              borderRadius: 5,
              dismissDirection: SnackDismissDirection.HORIZONTAL,
              snackStyle: SnackStyle.FLOATING,
            );
          }
        },
        backgroundColor: context.theme.primaryColor,
        child: Icon(
          Icons.add,
          color: context.iconColor,
          size: 35,
        ),
      ),
      extendBodyBehindAppBar: true,
      key: profilePageController.scaffoldState,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: GetBuilder<ProfilePageController>(
            builder: (controller) {
              if (controller.meSocial != null) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AppBar(
                    leadingWidth: 100,
                    leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    context.theme.primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GetBuilder<ProfilePageController>(
                                builder: (controller) {
                                  if (controller.meSocial != null) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        if (authController.activeInternet) {
                                          Get.bottomSheet(
                                            const MoodXBottom(),
                                            persistent: false,
                                            isScrollControlled: true,
                                            backgroundColor:
                                                context.theme.canvasColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Get.snackbar(
                                            "Internet bağlantısı yoxdur!",
                                            "Cihazınızın internetə bağlı olduğuna əmin olun.",
                                            backgroundColor:
                                                Colors.red.withOpacity(0.8),
                                            borderRadius: 5,
                                            dismissDirection:
                                                SnackDismissDirection
                                                    .HORIZONTAL,
                                            snackStyle: SnackStyle.FLOATING,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                profilePageController.meSocial!
                                                            .data()!["moodx"] >
                                                        1000000
                                                    ? "${(profilePageController.meSocial!.data()!["moodx"] / 1000000).toStringAsFixed(0)} M"
                                                    : profilePageController
                                                                    .meSocial!
                                                                    .data()![
                                                                "moodx"] >
                                                            1000
                                                        ? "${(profilePageController.meSocial!.data()!["moodx"] / 1000).toStringAsFixed(0)} K"
                                                        : profilePageController
                                                            .meSocial!
                                                            .data()!["moodx"]
                                                            .toString(),
                                                style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: context.iconColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              "MX",
                                              style: GoogleFonts.quicksand(
                                                color: context.iconColor,
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
                          )
                        ]),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    backgroundColor:
                        controller.meSocial!.data()!["premium"] ?? false
                            ? const Color(0xFFe1ad21).withOpacity(0.5)
                            : context.theme.primaryColor.withOpacity(0.5),
                    elevation: 0,
                    title: GetBuilder<ProfilePageController>(
                      builder: (controller) {
                        if (controller.meSocial != null) {
                          return Text(
                            controller.meSocial!.data()!["userName"] ?? "",
                            style: GoogleFonts.quicksand(
                                color: defineWhiteBlack()),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
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
                                color: Colors.transparent,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    Get.bottomSheet(
                                      const Setting(),
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.settings,
                                      color: context.iconColor,
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
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
      body: GetBuilder<ProfilePageController>(
        builder: (controller) {
          if (controller.meSocial != null) {
            return RefreshIndicator(
              onRefresh: profilePageController.onRefresh,
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
                                  controller.meSocial!
                                      .data()!["backgroundImage"],
                                ),
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
                                color: controller.meSocial!
                                            .data()!["specialBackground"] ??
                                        false
                                    ? Colors.transparent
                                    : Colors.redAccent[400],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    if (authController.activeInternet) {
                                      Get.bottomSheet(
                                        const BackgroundPhotoOptions(),
                                        isScrollControlled: true,
                                        backgroundColor:
                                            context.theme.canvasColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Internet bağlantısı yoxdur!",
                                        "Cihazınızın internetə bağlı olduğuna əmin olun.",
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        borderRadius: 5,
                                        dismissDirection:
                                            SnackDismissDirection.HORIZONTAL,
                                        snackStyle: SnackStyle.FLOATING,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: controller.meSocial!
                                                .data()!["specialBackground"] ??
                                            false
                                        ? SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                "assets/premium.png"),
                                          )
                                        : const Icon(
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
                                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.meSocial!
                                                .data()!["premium"] ??
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            controller.meSocial!
                                                .data()!["name"],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              if (controller.meSocial!
                                                      .data()!["birthday"] !=
                                                  null) {
                                                DateTime birthday = controller
                                                    .meSocial!
                                                    .data()!["birthday"]
                                                    .toDate();
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: Container(
                                                        height: 5,
                                                        width: 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: context
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
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
                                                      style:
                                                          GoogleFonts.quicksand(
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
                                            GetBuilder<ProfilePageController>(
                                          builder: (controller) {
                                            if (controller.meSocial != null) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: 50),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                              minWidth: 50),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${controller.meSocial!.data()!["likerTime"] ?? 0}",
                                                              style: GoogleFonts
                                                                  .quicksand(
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
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "${controller.meSocial!.data()!["hereTime"] ?? 0}",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                color: context
                                                                    .iconColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 22),
                                                      ),
                                                      SizedBox(
                                                        height: 26,
                                                        width: 26,
                                                        child: Image.asset(
                                                          'assets/wave.png',
                                                        ),
                                                      )
                                                      // Text(
                                                      //   "Here",
                                                      //   style: GoogleFonts
                                                      //       .encodeSans(
                                                      //     fontWeight:
                                                      //         FontWeight.bold,
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                    child: VerticalDivider(),
                                                  ),
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 50,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 50,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 4,
                                                          horizontal: 10,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${controller.meSocial!.data()!["gifts"] ?? 0}",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
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
                                        color: controller.meSocial!
                                                    .data()!["premium"] ??
                                                false
                                            ? const Color(0xFFe1ad21)
                                            : Colors.blue[900],
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          onTap: () {
                                            if (authController.activeInternet) {
                                              Get.bottomSheet(
                                                const ChangeProfilePictureBottomSheet(),
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    context.theme.canvasColor,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Get.snackbar(
                                                "Internet bağlantısı yoxdur!",
                                                "Cihazınızın internetə bağlı olduğuna əmin olun.",
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                borderRadius: 5,
                                                dismissDirection:
                                                    SnackDismissDirection
                                                        .HORIZONTAL,
                                                snackStyle: SnackStyle.FLOATING,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        controller.meSocial!
                                                                .data()![
                                                            "userPhoto"],
                                                      ),
                                                      isAntiAlias: true,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    GetBuilder<ProfilePageController>(
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
                                    MediaQuery.of(context).size.width * 0.40,
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
                                    title: Text(
                                      "Şəkli sil",
                                      style: GoogleFonts.encodeSans(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    trailingIcon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      await controller.deleteImage(
                                        controller.images[index].id,
                                      );
                                      Get.back();
                                    },
                                  ),
                                ],
                                onPressed: () {},
                                child: OpenContainer(
                                  closedBuilder: (context, func) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image(
                                          image: CachedNetworkImageProvider(
                                            controller.images[index]
                                                .data()!["imageUrl"],
                                            cacheKey: controller.images[index]
                                                .data()!["imageUrl"],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        if (controller.images[index]
                                                .data()!["inRestaurant"] ??
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
                                    );
                                  },
                                  openBuilder: (context, func) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image(
                                          image: CachedNetworkImageProvider(
                                            controller.images[index]
                                                .data()!["imageUrl"],
                                            cacheKey: controller.images[index]
                                                .data()!["imageUrl"],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: SafeArea(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    context.theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100,
                                                ),
                                              ),
                                              child: Material(
                                                color:
                                                    context.theme.primaryColor,
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
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 5),
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
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                          () => RestaurantPage(
                                                            restaurantId: controller
                                                                    .images[index]
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
                                                          child: Image.network(
                                                            controller.images[
                                                                        index]
                                                                    .data()![
                                                                "restaurantImage"],
                                                            fit: BoxFit.cover,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .medium,
                                                            isAntiAlias: true,
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
                                                            controller.images[
                                                                            index]
                                                                        .data()![
                                                                    "restaurantName"] ??
                                                                "",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .location_pin,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              controller.images[
                                                                              index]
                                                                          .data()![
                                                                      "locationName"] ??
                                                                  "",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                fontSize: 16,
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
                            },
                          );
                        } else {
                          return Text(
                            "Şəkil yoxdur",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          );
                        }
                      },
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
    );
  }
}
