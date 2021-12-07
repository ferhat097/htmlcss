// ignore_for_file: file_names

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/RestaurantPageController.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/MenuPage.dart';
import 'package:foodmood/Screens/Common/ReportComment.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/FeatureDetail.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/FollowAcceptDialog.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/HastagDetail.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RatingRestaurant.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/WriteCommentBottom.dart';
import 'package:foodmood/Screens/Common/TablePage.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:foodmood/Screens/Login/LoginSplash.dart';
import 'package:foodmood/Screens/Search/DirectionBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../FirebaseRemoteConfigController.dart';
import '../../../FoodMoodLogo.dart';
import '../DiscountDetailPage.dart';
import 'HeresListBottom.dart';
import 'SendRestaurant.dart';

class RestaurantPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  @override
  void initState() {
    restaurantPageController.getImages(widget.restaurantId);
    restaurantPageController.getRestaurantMain(widget.restaurantId);
    restaurantPageController.listenRestaurantDiscounts(widget.restaurantId);
    restaurantPageController.getFoodMoodSocial(widget.restaurantId);
    restaurantPageController.listenRestaurantHeres(widget.restaurantId);
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      profilePageController = Get.find();
      restaurantPageController.listenRestaurantComments(widget.restaurantId);
    }
    super.initState();
  }

  RestaurantPageController restaurantPageController =
      Get.put(RestaurantPageController());
  late ProfilePageController profilePageController;
  SearchController searchController = Get.find();
  AuthController authController = Get.find();
  double top = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isopened) {
          return [
            SliverAppBar(
              backgroundColor: Get.isDarkMode
                  ? Colors.black87
                  : Colors.white.withOpacity(0.9),
              expandedHeight: 300,
              collapsedHeight: 60,
              backwardsCompatibility: true,
              pinned: true,
              floating: true,
              snap: true,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  top = constraints.biggest.height;
                  if (top > 108) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: top / 347,
                      child: SizedBox(
                        height: 350,
                        child: GetBuilder<RestaurantPageController>(
                          builder: (controller) {
                            if (controller.images.isNotEmpty) {
                              return Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  CarouselSlider.builder(
                                    carouselController:
                                        controller.carouselController,
                                    itemCount: controller.images.length,
                                    itemBuilder: (context, index, index2) {
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: context.theme.primaryColor,
                                        ),
                                        child: Image.network(
                                          controller.images[index]
                                              .data()!["imageUrl"],
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      viewportFraction: 1,
                                      aspectRatio: 1,
                                      onPageChanged: (index, reasen) {
                                        controller
                                            .changeCurrentImageIndex(index);
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 20,
                                      color: Colors.black38,
                                      child:
                                          GetBuilder<RestaurantPageController>(
                                        id: "dot",
                                        builder: (controller) {
                                          return DotsIndicator(
                                            dotsCount: controller.images.length,
                                            position: controller
                                                .currentImageIndex
                                                .toDouble(),
                                            decorator: const DotsDecorator(
                                              color: Colors.white,
                                              activeColor: Colors.red,
                                              size: Size.square(
                                                12,
                                              ),
                                              activeSize: Size.square(
                                                12,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox(
                                child: Center(
                                  child: Text(
                                    "Şəkil yoxdur",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              title: GetBuilder<RestaurantPageController>(
                builder: (controller) {
                  if (controller.restaurant != null) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          controller.restaurant!.data()!["restaurantName"],
                          style: GoogleFonts.comfortaa(
                            color: defineWhiteBlack(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black87 : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios_new),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: defineWhiteBlack(),
              ),
              actions: [
                GetBuilder<RestaurantPageController>(builder: (controller) {
                  if (controller.restaurant != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        restaurantPageController.restaurant!
                                .data()!["restaurantFeatures"]
                                .contains(10)
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  "assets/isLive.png",
                                  color: Colors.white,
                                  scale: 19,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                })
              ],
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<GeneralController>(
                  id: "generaladControll",
                  builder: (controller) {
                    if (controller.adControll.isNotEmpty) {
                      if (controller.adControll["isRestaurantPageBanner"]) {
                        return FutureBuilder<AdWidget>(
                          future: restaurantPageController.loadAds(),
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
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<RestaurantPageController>(
                  id: "heres",
                  builder: (controller) {
                    if (controller.restaurant != null) {
                      return GetBuilder<SearchController>(
                        id: "iamhere",
                        builder: (controller2) {
                          return IgnorePointer(
                            ignoring: controller.loadingIamHere,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: controller
                                                  .defineHeres(controller.heres)
                                              ? Colors.lightBlueAccent
                                              : Colors.redAccent[400],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Material(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                            onTap: () async {
                                              bool active = await authController
                                                  .getConnectivity();
                                              if (active) {
                                                if (!FirebaseAuth.instance
                                                    .currentUser!.isAnonymous) {
                                                  GeoPoint geoPoint = controller
                                                      .restaurant!
                                                      .data()!["location"];
                                                  await controller.iamhere(
                                                    LatLng(geoPoint.latitude,
                                                        geoPoint.longitude),
                                                    controller.restaurant!
                                                            .data()![
                                                        "restaurantId"],
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                      "Burda olduğunuzu bildirmək üçün qeydiyyatdan keçin və ya daxil olun",
                                                      "");
                                                }
                                              } else {
                                                Get.snackbar(
                                                  "Internet bağlantısı yoxdur!",
                                                  "Cihazınızın internetə bağlı olduğuna əmin olun.",
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  borderRadius: 5,
                                                  dismissDirection:
                                                      SnackDismissDirection
                                                          .HORIZONTAL,
                                                  snackStyle:
                                                      SnackStyle.FLOATING,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Image.asset(
                                                    //   "assets/levelplate.png",
                                                    //   scale: 22,
                                                    //   color: Colors.white,
                                                    // ),
                                                    controller.loadingIamHere
                                                        ? CircularProgressIndicator(
                                                            color: context
                                                                .iconColor,
                                                          )
                                                        : Image.asset(
                                                            "assets/wave.png",
                                                            scale: 8,
                                                          ),

                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "burdayam",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              bool connectivity =
                                                  authController.activeInternet;
                                              if (connectivity) {
                                                if (!FirebaseAuth.instance
                                                    .currentUser!.isAnonymous) {
                                                  Get.bottomSheet(
                                                    const HeresListBottom(),
                                                    isScrollControlled: true,
                                                    backgroundColor: context
                                                        .theme.canvasColor,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                      "Burda olanları görə bilmək üçün qeydiyyatdan keçin və ya daxil olun",
                                                      "");
                                                }
                                              } else {
                                                Get.snackbar(
                                                  "Internet bağlantısı yoxdur!",
                                                  "Cihazınızın internetə bağlı olduğuna əmin olun.",
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  borderRadius: 5,
                                                  dismissDirection:
                                                      SnackDismissDirection
                                                          .HORIZONTAL,
                                                  snackStyle:
                                                      SnackStyle.FLOATING,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                          "assets/girl-face.png",
                                                          color:
                                                              context.iconColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5),
                                                        child: Text(
                                                          "${controller.hereFemale.length}",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                          "assets/boy-face.png",
                                                          color:
                                                              context.iconColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 5,
                                                        ),
                                                        child: Text(
                                                          "${controller.hereMale.length} ",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                GetBuilder<RestaurantPageController>(builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueAccent,
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            Get.bottomSheet(
                              SendRestaurant(
                                restaurant: controller.restaurant!.data()!,
                              ),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
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
                            child: Center(
                              child: Text(
                                "Göndər",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                GetBuilder<RestaurantPageController>(
                  builder: (controller) {
                    if (controller.restaurant != null) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: defineTextFieldColor(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: restaurantPageController
                                                .defineOpenedStatus(
                                                    controller.restaurant!
                                                        .data()!["openTime"],
                                                    controller.restaurant!
                                                        .data()!["closeTime"])
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      restaurantPageController
                                              .defineOpenedStatus(
                                                  controller.restaurant!
                                                      .data()!["openTime"],
                                                  controller.restaurant!
                                                      .data()!["closeTime"])
                                          ? "Açıqdır"
                                          : "Bağlıdır",
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  restaurantPageController.defineTimeText(
                                      controller.restaurant!
                                          .data()!["openTime"],
                                      controller.restaurant!
                                          .data()!["closeTime"]),
                                  style: GoogleFonts.quicksand(
                                    color: defineWhiteBlack(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
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
                GetBuilder<RestaurantPageController>(
                  builder: (controller) {
                    if (controller.restaurant != null) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5.0, left: 8, right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: defineTextFieldColor(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                Get.bottomSheet(
                                  DirectionBottom(
                                    latLng: controller.restaurant!
                                        .data()!["location"],
                                    restaurant: controller.restaurant!.data()!,
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: context.theme.canvasColor,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              controller.restaurant!
                                                  .data()!["locationName"],
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Xəritədə bax",
                                      style: GoogleFonts.quicksand(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                // GetBuilder<RestaurantPageController>(
                //   builder: (controller) {
                //     if (controller.restaurant != null) {
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 8,
                //           vertical: 5,
                //         ),
                //         child: Container(
                //           width: double.infinity,
                //           height: 40,
                //           decoration: BoxDecoration(
                //             color: context.theme.primaryColor,
                //             borderRadius: BorderRadius.circular(5),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                       height: 20,
                //                       width: 20,
                //                       decoration: BoxDecoration(
                //                         color: controller.restaurant!.data()![
                //                                     "isActiveTableOrder"] ??
                //                                 false
                //                             ? Colors.green
                //                             : Colors.red,
                //                         borderRadius: BorderRadius.circular(50),
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       width: 5,
                //                     ),
                //                     Text(
                //                       "Masadan Sifariş",
                //                       style: GoogleFonts.quicksand(),
                //                     ),
                //                   ],
                //                 ),
                //                 Text(
                //                   controller.restaurant!
                //                               .data()!["isActiveTableOrder"] ??
                //                           false
                //                       ? "Aktivdir"
                //                       : "Aktiv deyil",
                //                   style: GoogleFonts.quicksand(
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //       );
                //     } else {
                //       return const SizedBox();
                //     }
                //   },
                // ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<RestaurantPageController>(
                  builder: (controller) {
                    if (controller.restaurant != null) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[800],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                  ),
                                  child: Material(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      onTap: () {
                                        if (!FirebaseAuth.instance.currentUser!
                                            .isAnonymous) {
                                          Get.bottomSheet(
                                            RatingRestaurant(
                                              restaurantId: widget.restaurantId,
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
                                        } else {
                                          Get.snackbar(
                                              "Səs vermək üçün qeydiyyatdan keçin və ya daxil olun",
                                              "");
                                        }
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Image.asset(
                                              //   "assets/levelplate.png",
                                              //   scale: 22,
                                              //   color: Colors.white,
                                              // ),
                                              const Icon(
                                                Icons.add_box,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "səs ver",
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: RatingBarIndicator(
                                            rating: controller.restaurant!
                                                .data()!["rating"]
                                                .toDouble(),
                                            itemBuilder: (context, index) {
                                              return Icon(
                                                Icons.star,
                                                color: Colors.yellow[800],
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                ),
                GetBuilder<RestaurantPageController>(
                  id: "hastag",
                  builder: (controller) {
                    if (controller.hastags.isNotEmpty) {
                      return SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.hastags.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 5,
                              );
                            },
                            itemBuilder: (context, index) {
                              return ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 70.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HexColor(
                                      controller.hastags[index]
                                          .data()!["hastagColor"],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Get.bottomSheet(
                                            HastagDetail(
                                              hastag: controller.hastags[index]
                                                  .data()!,
                                            ),
                                            isScrollControlled: true);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "#${controller.hastags[index].data()!["hastagName"]}",
                                            style: GoogleFonts.quicksand(
                                                color: HexColor(controller
                                                    .hastags[index]
                                                    .data()!["textColor"]),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: defineTextFieldColor(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Bu restoran üçün hastag mövcud deyil",
                                style: GoogleFonts.quicksand(
                                    color: defineWhiteBlack(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                GetBuilder<RestaurantPageController>(
                  builder: (controller) {
                    if (firebaseRemoteConfigController.features.isNotEmpty &&
                        controller.restaurant != null) {
                      List featuresList = controller.restaurant!
                              .data()!["restaurantFeatures"] ??
                          [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Özəlliklər",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: 60,
                              child: GridView.builder(
                                itemCount: firebaseRemoteConfigController
                                    .features.length,
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(50),
                                      color: featuresList.contains(
                                              firebaseRemoteConfigController
                                                  .features.entries
                                                  .elementAt(index)
                                                  .value["id"])
                                          ? Colors.green
                                          : Get.isDarkMode
                                              ? Colors.black54
                                              : Colors.grey[200],
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          Get.bottomSheet(
                                            FeatureDetail(
                                              feature:
                                                  firebaseRemoteConfigController
                                                      .features.entries
                                                      .elementAt(index)
                                                      .value,
                                              exist: featuresList.contains(
                                                  firebaseRemoteConfigController
                                                      .features.entries
                                                      .elementAt(index)
                                                      .value["id"]),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Image.network(
                                            firebaseRemoteConfigController
                                                .features.entries
                                                .elementAt(index)
                                                .value["featuresImage"],
                                            color: featuresList.contains(
                                                    firebaseRemoteConfigController
                                                        .features.entries
                                                        .elementAt(index)
                                                        .value["id"])
                                                ? Colors.white
                                                : context.iconColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Get.to(
                            () => MenuPage(
                              restaurantId: widget.restaurantId,
                              fromQr: false,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "MENYU",
                              style: GoogleFonts.encodeSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      // if (!authController.firebaseAuth.currentUser!.isAnonymous)
                      //   Flexible(
                      //     child: GetBuilder<ProfilePageController>(
                      //       builder: (controller) {
                      //         return Container(
                      //           width: double.infinity,
                      //           decoration: BoxDecoration(
                      //             color: profilePageController
                      //                     .followedRestaurant
                      //                     .contains(widget.restaurantId)
                      //                 ? Colors.pink
                      //                 : context.theme.primaryColor,
                      //             borderRadius: BorderRadius.circular(5),
                      //           ),
                      //           child: Material(
                      //             borderRadius: BorderRadius.circular(5),
                      //             color: Colors.transparent,
                      //             child: InkWell(
                      //               borderRadius: BorderRadius.circular(5),
                      //               onTap: () {
                      //                 if (!FirebaseAuth
                      //                     .instance.currentUser!.isAnonymous) {
                      //                   if (profilePageController
                      //                       .followedRestaurant
                      //                       .contains(widget.restaurantId)) {
                      //                     restaurantPageController
                      //                         .unfollow(widget.restaurantId);
                      //                   } else {
                      //                     Get.dialog(
                      //                       FollowAcceptDialog(
                      //                         restaurantId: widget.restaurantId,
                      //                       ),
                      //                     );
                      //                   }
                      //                 } else {
                      //                   Get.snackbar(
                      //                       "Restoranı izləmək üçün qeydiyyatdan keçin və ya daxil olun",
                      //                       "");
                      //                 }
                      //               },
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Center(
                      //                   child: Text(
                      //                     profilePageController
                      //                             .followedRestaurant
                      //                             .contains(widget.restaurantId)
                      //                         ? "İzlənilir"
                      //                         : "İzlə",
                      //                     style: GoogleFonts.quicksand(
                      //                       color: profilePageController
                      //                               .followedRestaurant
                      //                               .contains(
                      //                                   widget.restaurantId)
                      //                           ? Colors.white
                      //                           : context.iconColor,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 16,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                String phoneNumber = restaurantPageController
                                    .restaurant!
                                    .data()!["personalPhoneNumber"];
                                launch("tel:$phoneNumber");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Zəng et",
                                        style: GoogleFonts.encodeSans(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: GetBuilder<RestaurantPageController>(
                          builder: (controller) {
                            if (controller.restaurant != null) {
                              return Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: restaurantPageController.restaurant!
                                                    .data()![
                                                "isActiveTableOrder"] ??
                                            false
                                        ? Colors.greenAccent[700]
                                        : context.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(3),
                                      onTap: () {
                                        Get.snackbar(
                                          "Masalar tezliklə əlavə olunacaq!",
                                          "Masaların şəkli, yerləşmə yeri, rezervasiya, masadan sifariş kimi özəlliklər tezliklə aktiv olacaq!",
                                          backgroundColor: Colors.red,
                                          borderRadius: 5,
                                          colorText: Colors.white,
                                        );
                                        // Get.to(
                                        //   () => TablePage(
                                        //     restaurantId: widget.restaurantId,
                                        //     isActiveTableOrder:
                                        //         restaurantPageController
                                        //                 .restaurant!
                                        //                 .data()![
                                        //             "isActiveTableOrder"],
                                        //   ),
                                        // );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Image.asset(
                                                  "assets/table.png",
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Masalar",
                                                style: GoogleFonts.encodeSans(
                                                  // color: restaurantPageController
                                                  //             .restaurant!
                                                  //             .data()![
                                                  //         "isActiveTableOrder"]
                                                  //     ? Colors.white
                                                  //     : context.iconColor,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                const Divider(),
                GetBuilder<RestaurantPageController>(
                  id: "discount",
                  builder: (controller) {
                    if (controller.discounts.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Endirim və təkliflər",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: CarouselSlider.builder(
                              itemCount: controller.discounts.length,
                              itemBuilder: (context, index, index2) {
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        controller.discounts[index]
                                            .data()!["coverPhoto"],
                                      ),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 3, sigmaY: 3),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              DiscountDetail(
                                                discountId: controller
                                                    .discounts[index].id,
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  context.theme.backgroundColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            //fit: StackFit.expand,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.white70,
                                                      Colors.transparent
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 40,
                                                        vertical: 10),
                                                    child: foodMoodLogo(),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "${controller.discounts[index].data()!["restaurantName"]}'dən",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  // backgroundColor: Colors.red,
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        controller.discounts[
                                                                            index]
                                                                        .data()![
                                                                    "menutype"] ==
                                                                1
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Text(
                                                                  " bütün menyu'ya ",
                                                                  style: GoogleFonts.quicksand(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                            : Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Text(
                                                                  "seçilmiş yeməklərə",
                                                                  style: GoogleFonts.quicksand(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                        Text(
                                                          "endirim",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              controller.discounts[index]
                                                              .data()![
                                                          "durationtype"] ==
                                                      1
                                                  ? Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          gradient:
                                                              RadialGradient(
                                                            radius: 2,
                                                            colors:
                                                                Get.isDarkMode
                                                                    ? [
                                                                        Colors
                                                                            .black38,
                                                                        Colors
                                                                            .black26,
                                                                        Colors
                                                                            .transparent
                                                                      ]
                                                                    : [
                                                                        Colors
                                                                            .white70,
                                                                        Colors
                                                                            .white60,
                                                                        Colors
                                                                            .transparent
                                                                      ],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: const Icon(
                                                                  Icons.person),
                                                            ),
                                                            Text(
                                                              " ${controller.discounts[index].data()!["maxNumber"]}",
                                                              style: GoogleFonts
                                                                  .quicksand(),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          gradient:
                                                              RadialGradient(
                                                            radius: 2,
                                                            colors:
                                                                Get.isDarkMode
                                                                    ? [
                                                                        Colors
                                                                            .black38,
                                                                        Colors
                                                                            .black26,
                                                                        Colors
                                                                            .transparent
                                                                      ]
                                                                    : [
                                                                        Colors
                                                                            .white70,
                                                                        Colors
                                                                            .white60,
                                                                        Colors
                                                                            .transparent
                                                                      ],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: 25,
                                                              width: 25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .date_range_rounded,
                                                                size: 15,
                                                              ),
                                                            ),
                                                            GetBuilder<
                                                                RestaurantPageController>(
                                                              id: "endTime",
                                                              //assignId: true,
                                                              //global: false,
                                                              builder:
                                                                  (controller2) {
                                                                return Text(
                                                                  controller
                                                                      .defineEndTime(),
                                                                  style: GoogleFonts
                                                                      .quicksand(),
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Transform.rotate(
                                                  angle: 5.8,
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      gradient:
                                                          const RadialGradient(
                                                        colors: [
                                                          Colors.black54,
                                                          Colors.black12,
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          child: Image.asset(
                                                              "assets/discount.png",
                                                              scale: 7,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${controller.discounts[index].data()!["discount"]}%",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 26,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(viewportFraction: 0.8),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Endirimlər mövcud deyil",
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                GetBuilder<RestaurantPageController>(
                  id: "foodmoodsocial",
                  builder: (controller) {
                    print(controller.restaurant!.id);
                    if (controller.foodMoodSocial.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "FoodMood Social",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: 105,
                              child: GridView.builder(
                                itemCount: controller.foodMoodSocial.length,
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1, mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: restaurantPageController
                                              .defineUserColor(controller
                                                  .foodMoodSocial[index]
                                                  .data()!["point"]),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                controller.foodMoodSocial[index]
                                                    .data()!["userPhoto"]),
                                            radius: 39,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        controller.foodMoodSocial[index]
                                            .data()!["userName"],
                                        style: GoogleFonts.quicksand(
                                            color: defineWhiteBlack(),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  );
                                },
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
                if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                  GetBuilder<RestaurantPageController>(
                    builder: (controller) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Şərhlər",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Material(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                      onTap: () {
                                        if (authController.activeInternet) {
                                          Get.bottomSheet(
                                            WriteCommentBottom(
                                              restaurantId: widget.restaurantId,
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
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Şərh yaz",
                                            style: GoogleFonts.quicksand(),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (controller.comments.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 15,
                                  );
                                },
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.comments.length,
                                itemBuilder: (context, index) {
                                  return Builder(builder: (context) {
                                    List likedUsers = controller.comments[index]
                                            .data()!["likedUsers"] ??
                                        [];
                                    return GestureDetector(
                                      onDoubleTap: () {
                                        if (likedUsers.contains(FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                          controller.likeComment(
                                              controller.comments[index].id,
                                              false);
                                        } else {
                                          controller.likeComment(
                                            controller.comments[index].id,
                                            true,
                                          );
                                        }
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.all(0),
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (controller
                                                                        .comments[
                                                                            index]
                                                                        .data()![
                                                                    "fromId"] !=
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid) {
                                                              Get.to(
                                                                () =>
                                                                    UserProfile(
                                                                  userId: controller
                                                                      .comments[
                                                                          index]
                                                                      .data()!["fromId"],
                                                                ),
                                                                preventDuplicates:
                                                                    false,
                                                                transition:
                                                                    Transition
                                                                        .size,
                                                              );
                                                            }
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                              controller
                                                                      .comments[
                                                                          index]
                                                                      .data()![
                                                                  "fromPhoto"],
                                                            ),
                                                            radius: 30,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 100,
                                                              minHeight: 50,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  controller
                                                                      .comments[
                                                                          index]
                                                                      .data()!["fromName"],
                                                                  style: GoogleFonts
                                                                      .encodeSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    controller
                                                                        .comments[
                                                                            index]
                                                                        .data()!["comment"],
                                                                    maxLines: 4,
                                                                    style: GoogleFonts
                                                                        .quicksand(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  FocusedMenuHolder(
                                                    menuBoxDecoration:
                                                        BoxDecoration(
                                                      color: context
                                                          .theme.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    openWithTap: true,
                                                    onPressed: () {},
                                                    menuItems: [
                                                      if (controller.comments[
                                                                      index]
                                                                  .data()![
                                                              "fromId"] !=
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid)
                                                        FocusedMenuItem(
                                                          backgroundColor:
                                                              Colors.red,
                                                          title: Text(
                                                            "Şikayət et",
                                                            style: GoogleFonts
                                                                .encodeSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          trailingIcon:
                                                              const Icon(
                                                            Icons.report,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            Get.bottomSheet(
                                                              ReportComment(
                                                                what: 1,
                                                                id1: controller
                                                                    .restaurant!
                                                                    .id,
                                                                id2: controller
                                                                    .comments[
                                                                        index]
                                                                    .id,
                                                                reportedUserId:
                                                                    controller.comments[
                                                                            index]
                                                                        [
                                                                        "fromId"],
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
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      if (controller.comments[
                                                                      index]
                                                                  .data()![
                                                              "fromId"] ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid)
                                                        FocusedMenuItem(
                                                          backgroundColor:
                                                              context.theme
                                                                  .canvasColor,
                                                          title: Text(
                                                            "Sil",
                                                            style: GoogleFonts
                                                                .encodeSans(
                                                              color: context
                                                                  .iconColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          trailingIcon: Icon(
                                                            Icons.close,
                                                            color: context
                                                                .iconColor,
                                                          ),
                                                          onPressed: () {
                                                            controller
                                                                .removeComment(
                                                              controller
                                                                  .comments[
                                                                      index]
                                                                  .id,
                                                            );
                                                          },
                                                        )
                                                    ],
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        100,
                                                      ),
                                                      child: InkWell(
                                                        // onTap: () {},
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Icon(
                                                          Icons.more_horiz,
                                                          size: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image.asset(
                                                        "assets/graffiti-heart-shape.png",
                                                        color: likedUsers.contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                            ? Colors.pink
                                                            : context.iconColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: context
                                                            .iconColor!
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${controller.comments[index].data()!["like"] ?? 0}",
                                                      style: GoogleFonts
                                                          .encodeSans(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    if (!likedUsers.contains(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid))
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Bəyənmək üçün iki dəfə toxun",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Şərh yoxdur",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: context.iconColor,
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Rəyləri oxumaq və rəy yazmaq üçün",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const LoginSplash());
                          },
                          child: Text(
                            "Qeydiyyatdan keç vəya daxil ol",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
