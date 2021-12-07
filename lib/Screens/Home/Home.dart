// ignore_for_file: file_names

import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/HomeController.dart';
import 'package:foodmood/Screens/Common/DiscountDetailPage.dart';
import 'package:foodmood/Screens/Common/FoodDetail.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/SendRestaurant.dart';
import 'package:foodmood/Screens/Home/HastagDetail.dart';
import 'package:foodmood/Screens/Home/SendFood.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../DarkModeController.dart';
import '../../FoodMoodLogo.dart';

class Home extends StatefulWidget {
  final bool isAnonym;
  const Home({Key? key, required this.isAnonym}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeController = Get.find();
  @override
  void initState() {
    homeController.getuserStatistic(false, [], [], []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: Column(
        children: [
          GetBuilder<HomeController>(
            id: "hastags",
            builder: (controller) {
              return Container(
                width: double.infinity,
                color: context.theme.appBarTheme.backgroundColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 60,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              IgnorePointer(
                                ignoring: controller.loadingwhereIGoToday,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () async {
                                        Map<String, dynamic> restaurantMap =
                                            await homeController
                                                .whereIGoToday();
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
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 0,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          child: SizedBox(
                                                            height: 150,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                Image.network(
                                                              restaurantMap[
                                                                  "restaurantImage"],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          restaurantMap[
                                                              "restaurantName"],
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 18,
                                                            color: context
                                                                .iconColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .lightBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          child: Material(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              onTap: () {
                                                                Get.off(
                                                                  () =>
                                                                      RestaurantPage(
                                                                    restaurantId:
                                                                        restaurantMap[
                                                                            "restaurantId"],
                                                                  ),
                                                                  transition:
                                                                      Transition
                                                                          .size,
                                                                );
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  "Restorana bax",
                                                                  style: GoogleFonts
                                                                      .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   "salam",
                                                        //   style: GoogleFonts
                                                        //       .quicksand(
                                                        //     color:
                                                        //         context.iconColor,
                                                        //     fontWeight:
                                                        //         FontWeight.w600,
                                                        //     fontSize: 18,
                                                        //   ),
                                                        //   textAlign:
                                                        //       TextAlign.center,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            if (controller.loadingwhereIGoToday)
                                              const Center(
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                            if (controller.loadingwhereIGoToday)
                                              const SizedBox(
                                                width: 8,
                                              ),
                                            Text(
                                              "Bugün hara gedim?",
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.red,
                              //     borderRadius: BorderRadius.circular(5),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       "Ismarla",
                              //       style: GoogleFonts.quicksand(
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              Builder(
                                builder: (context) {
                                  if (controller.hastags.isNotEmpty) {
                                    return SizedBox(
                                      height: 40,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: controller.hastags.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                minWidth: 70.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: HexColor(
                                                    controller.hastags[index]
                                                        .data()!["hastagColor"],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    onTap: () {
                                                      Get.bottomSheet(
                                                        HastagDetail(
                                                          hastagId:
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "hastagId"],
                                                          hastagName:
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "hastagName"],
                                                          infoText:
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "infoText"],
                                                          hastagColor:
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "hastagColor"],
                                                          textColor:
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "textColor"],
                                                        ),
                                                        isScrollControlled:
                                                            true,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "#${controller.hastags[index].data()!["hastagName"]}",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            color: HexColor(
                                                              controller
                                                                      .hastags[
                                                                          index]
                                                                      .data()![
                                                                  "textColor"],
                                                            ),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      "Sizə özəl FoodMood Hastag mövcud deyil",
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          GetBuilder<GeneralController>(
            id: "generaladControll",
            builder: (controller) {
              if (controller.adControll.isNotEmpty) {
                if (controller.adControll["isHomeBanner"]) {
                  return FutureBuilder<AdWidget>(
                    future: homeController.loadAds(),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: context.theme.cardColor),
                          child: GetBuilder<HomeController>(
                            id: "foodMoodRestaurant",
                            builder: (controller) {
                              if (controller.foodMoodRestaurant.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "FoodMood seçimi",
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 145,
                                        width: double.infinity,
                                        child: CarouselSlider.builder(
                                          options: CarouselOptions(
                                            aspectRatio: 1,
                                            viewportFraction: 145 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            //height: 145,
                                            scrollDirection: Axis.horizontal,
                                            //viewportFraction: 0.7,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                const Duration(seconds: 2),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 300),
                                          ),
                                          itemCount: homeController
                                              .foodMoodRestaurant.length,
                                          itemBuilder:
                                              (context, index, index2) {
                                            return Column(
                                              children: [
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      onTap: () {
                                                        Get.to(
                                                            () => RestaurantPage(
                                                                restaurantId:
                                                                    controller
                                                                        .foodMoodRestaurant[
                                                                            index]
                                                                        .id),
                                                            transition:
                                                                Transition
                                                                    .size);
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Image(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            homeController
                                                                    .foodMoodRestaurant[
                                                                        index]
                                                                    .data()![
                                                                "restaurantImage"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  homeController
                                                      .foodMoodRestaurant[index]
                                                      .data()!["restaurantName"],
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          defineWhiteBlack()),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            );
                                          },
                                        )
                                        // child: ListView.separated(
                                        //   shrinkWrap: true,
                                        //   scrollDirection: Axis.horizontal,
                                        //   separatorBuilder: (context, index) {
                                        //     return SizedBox(
                                        //       width: 5,
                                        //     );
                                        //   },
                                        //   itemCount: homeController
                                        //       .foodMoodRestaurant.length,
                                        //   itemBuilder: (context, index) {
                                        //     return Column(
                                        //       children: [
                                        //         Container(
                                        //           width: 120,
                                        //           height: 120,
                                        //           decoration: BoxDecoration(
                                        //             color: Colors.grey[200],
                                        //             borderRadius:
                                        //                 BorderRadius.circular(5),
                                        //           ),
                                        //           child: Material(
                                        //             color: Colors.transparent,
                                        //             borderRadius:
                                        //                 BorderRadius.circular(5),
                                        //             child: InkWell(
                                        //               borderRadius:
                                        //                   BorderRadius.circular(5),
                                        //               onTap: () {
                                        //                 Get.to(
                                        //                     () => RestaurantPage(
                                        //                         restaurantId: controller
                                        //                             .foodMoodRestaurant[
                                        //                                 index]
                                        //                             .id),
                                        //                     transition:
                                        //                         Transition.size);
                                        //               },
                                        //               child: ClipRRect(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                         5),
                                        //                 child: Image.network(
                                        //                   homeController
                                        //                           .foodMoodRestaurant[
                                        //                               index]
                                        //                           .data()![
                                        //                       "restaurantImage"],
                                        //                   fit: BoxFit.cover,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //           height: 5,
                                        //         ),
                                        //         Text(
                                        //           homeController
                                        //               .foodMoodRestaurant[index]
                                        //               .data()!["restaurantName"],
                                        //           style: GoogleFonts.quicksand(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: defineWhiteBlack()),
                                        //         )
                                        //       ],
                                        //     );
                                        //   },
                                        // ),
                                        )
                                  ],
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "FoodMood seçimi",
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 140,
                                      child: Center(
                                        child: Text(
                                          "FoodMood tövsiyyələri yoxdur",
                                          style: GoogleFonts.quicksand(),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: GetBuilder<HomeController>(
                            id: "foods",
                            builder: (controller) {
                              if (controller.foods.isNotEmpty) {
                                return Container(
                                  height: 170,
                                  width: double.infinity,
                                  color: context.theme.cardColor,
                                  child: CarouselSlider.builder(
                                    itemCount: controller.foods.length,
                                    itemBuilder: (context, index, index2) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    context.theme.primaryColor,
                                              ),
                                              width: 300,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 0,
                                                horizontal: 5,
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                      FoodDetail(
                                                        foodId: controller
                                                            .foods[index]
                                                            .data()!["foodId"],
                                                      ),
                                                      isScrollControlled: true,
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
                                                  },
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                          maxWidth: 120,
                                                          minHeight:
                                                              double.infinity,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(5),
                                                          ),
                                                          child: Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              controller.foods[
                                                                          index]
                                                                      .data()![
                                                                  "foodImage"],
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              //stops: [0.2, 0.5, 0.9],
                                                              colors: [
                                                                Colors.black87,
                                                                // Colors.black54,
                                                                Colors
                                                                    .transparent,

                                                                // Colors.transparent,
                                                              ],
                                                              begin: Alignment
                                                                  .bottomCenter,
                                                              end: Alignment
                                                                  .topCenter,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          height: 30,
                                                          child: Center(
                                                            child: Text(
                                                              controller.foods[
                                                                          index]
                                                                      .data()![
                                                                  "name"],
                                                              style: GoogleFonts
                                                                  .oswald(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 15,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: context.theme
                                                                .canvasColor
                                                                .withOpacity(
                                                                    0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              50,
                                                            ),
                                                          ),
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              50,
                                                            ),
                                                            color: context.theme
                                                                .canvasColor
                                                                .withOpacity(
                                                                    0.4),
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              onTap: () {
                                                                Get.bottomSheet(
                                                                  SendFood(
                                                                      food: controller
                                                                          .foods[
                                                                              index]
                                                                          .data()!),
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      context
                                                                          .theme
                                                                          .canvasColor,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 2,
                                                                        right:
                                                                            4,
                                                                        top: 3,
                                                                        bottom:
                                                                            3),
                                                                child: Icon(
                                                                  Icons.share,
                                                                  color: context
                                                                      .iconColor!
                                                                      .withOpacity(
                                                                          0.9),
                                                                  size: 23,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      // Container(
                                                      //   constraints: const BoxConstraints(
                                                      //     maxWidth: 150,
                                                      //   ),
                                                      //   child: Column(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment.start,
                                                      //     mainAxisAlignment:
                                                      //         MainAxisAlignment.center,
                                                      //     children: [
                                                      //       Text(
                                                      //         controller.foods[index]
                                                      //             .data()!["name"],
                                                      //         style: GoogleFonts.quicksand(
                                                      //           fontWeight: FontWeight.w600,
                                                      //           fontSize: 15,
                                                      //         ),
                                                      //         overflow: TextOverflow.visible,
                                                      //         maxLines: 3,
                                                      //       ),
                                                      //       if (controller.foods[index]
                                                      //           .data()!["isDiscount"])
                                                      //         Row(
                                                      //           children: [
                                                      //             Text(
                                                      //               "${controller.foods[index].data()!["price"].toString()} AZN",
                                                      //               style: GoogleFonts
                                                      //                   .encodeSans(
                                                      //                 fontSize: 18,
                                                      //                 decoration:
                                                      //                     TextDecoration
                                                      //                         .lineThrough,
                                                      //                 color: context
                                                      //                         .isDarkMode
                                                      //                     ? Colors.white60
                                                      //                     : Colors.black54,
                                                      //                 fontWeight:
                                                      //                     FontWeight.w700,
                                                      //               ),
                                                      //               overflow:
                                                      //                   TextOverflow.visible,
                                                      //               maxLines: 1,
                                                      //             ),
                                                      //             const SizedBox(
                                                      //               width: 5,
                                                      //             ),
                                                      //             Text(
                                                      //               "${controller.foods[index].data()!["discountPrice"].toString()} AZN",
                                                      //               style:
                                                      //                   GoogleFonts.quicksand(
                                                      //                       fontWeight:
                                                      //                           FontWeight
                                                      //                               .bold,
                                                      //                       fontSize: 18,
                                                      //                       color: context
                                                      //                           .iconColor),
                                                      //             )
                                                      //           ],
                                                      //         )
                                                      //       else
                                                      //         Text(
                                                      //           "${controller.foods[index].data()!["price"].toString()} AZN",
                                                      //           style: GoogleFonts.quicksand(
                                                      //               fontWeight:
                                                      //                   FontWeight.bold,
                                                      //               fontSize: 18),
                                                      //         )
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  "assets/graffiti-heart-shape.png",
                                                  color: Colors.pink,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${controller.foods[index].data()!["like"] ?? 0}",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                height: 15,
                                                child: VerticalDivider(
                                                  color: context.iconColor,
                                                  thickness: 0.5,
                                                ),
                                              ),
                                              Text(
                                                "${controller.foods[index].data()!["price"] ?? 0}",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                "AZN",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    options: CarouselOptions(
                                      scrollDirection: Axis.horizontal,
                                      viewportFraction: 0.6,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 2),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 300),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Text(
                      "Endirimlər",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GetBuilder<HomeController>(
                    id: "foodMoodDiscount",
                    builder: (controller) {
                      if (controller.foodMoodDiscounts.isNotEmpty) {
                        return Column(
                          children: [
                            // Text("Gunun teklifi"),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: CarouselSlider.builder(
                                itemCount: controller.foodMoodDiscounts.length,
                                itemBuilder: (context, index, index2) {
                                  return Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          controller.foodMoodDiscounts[index]
                                              .data()!["coverPhoto"],
                                        ),
                                      ),
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 0,
                                          sigmaY: 0,
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                DiscountDetail(
                                                  discountId: controller
                                                      .foodMoodDiscounts[index]
                                                      .id,
                                                ),
                                                isScrollControlled: true,
                                                backgroundColor: context
                                                    .theme.backgroundColor,
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
                                            },
                                            child: Stack(
                                              //fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white,
                                                        Colors.white54,
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
                                                        vertical: 10,
                                                      ),
                                                      child: foodMoodLogo(),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "${controller.foodMoodDiscounts[index].data()!["restaurantName"]}'dən",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    // backgroundColor: Colors.red,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          controller.foodMoodDiscounts[
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
                                                                            .circular(5),
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
                                                                            .circular(5),
                                                                  ),
                                                                  child: Text(
                                                                    " seçilmiş yeməklərə ",
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
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                controller.foodMoodDiscounts[
                                                                    index]
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
                                                                    .circular(
                                                                        10),
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
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Get
                                                                          .isDarkMode
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
                                                                        .person),
                                                              ),
                                                              Text(
                                                                " ${controller.foodMoodDiscounts[index].data()!["maxNumber"]}",
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
                                                                    .circular(
                                                                        10),
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
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Get
                                                                          .isDarkMode
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .date_range_rounded,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                              GetBuilder<
                                                                  HomeController>(
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
                                                            BorderRadius
                                                                .circular(200),
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
                                                          Image.asset(
                                                              "assets/discount.png",
                                                              scale: 3,
                                                              color:
                                                                  Colors.red),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${controller.foodMoodDiscounts[index].data()!["discount"]}%",
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
                          height: 100,
                          child: Center(
                            child: Text(
                              "FoodMood tövsiyyələri yoxdur",
                              style: GoogleFonts.quicksand(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 5),
                    child: Text(
                      "Ən çox bəyənilənlər",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GetBuilder<HomeController>(
                    id: "popularFood",
                    builder: (controller) {
                      if (controller.popularFoods.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.popularFoods.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: context.theme.primaryColor,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 0,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(0),
                                      onTap: () {
                                        Get.bottomSheet(
                                          FoodDetail(
                                            foodId: controller
                                                .popularFoods[index]
                                                .data()!["foodId"],
                                          ),
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        fit: StackFit.loose,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(0),
                                            ),
                                            child: Image(
                                              image: CachedNetworkImageProvider(
                                                controller.popularFoods[index]
                                                    .data()!["foodImage"],
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  //stops: [0.2, 0.5, 0.9],
                                                  colors: [
                                                    Colors.black87,
                                                    // Colors.black54,
                                                    Colors.transparent,

                                                    // Colors.transparent,
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                ),
                                              ),
                                              height: 30,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  controller.popularFoods[index]
                                                      .data()!["name"],
                                                  style: GoogleFonts.oswald(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 19,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: context.theme.canvasColor
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  50,
                                                ),
                                              ),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  50,
                                                ),
                                                color: context.theme.canvasColor
                                                    .withOpacity(0.4),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                      SendFood(
                                                          food: controller
                                                              .popularFoods[
                                                                  index]
                                                              .data()!),
                                                      isScrollControlled: true,
                                                      backgroundColor: context
                                                          .theme.canvasColor,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            20,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 2,
                                                      right: 4,
                                                      top: 3,
                                                      bottom: 3,
                                                    ),
                                                    child: Icon(
                                                      Icons.share,
                                                      color: context.iconColor!
                                                          .withOpacity(0.9),
                                                      size: 23,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          // Container(
                                          //   constraints: const BoxConstraints(
                                          //     maxWidth: 150,
                                          //   ),
                                          //   child: Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.center,
                                          //     children: [
                                          //       Text(
                                          //         controller.foods[index]
                                          //             .data()!["name"],
                                          //         style: GoogleFonts.quicksand(
                                          //           fontWeight: FontWeight.w600,
                                          //           fontSize: 15,
                                          //         ),
                                          //         overflow: TextOverflow.visible,
                                          //         maxLines: 3,
                                          //       ),
                                          //       if (controller.foods[index]
                                          //           .data()!["isDiscount"])
                                          //         Row(
                                          //           children: [
                                          //             Text(
                                          //               "${controller.foods[index].data()!["price"].toString()} AZN",
                                          //               style: GoogleFonts
                                          //                   .encodeSans(
                                          //                 fontSize: 18,
                                          //                 decoration:
                                          //                     TextDecoration
                                          //                         .lineThrough,
                                          //                 color: context
                                          //                         .isDarkMode
                                          //                     ? Colors.white60
                                          //                     : Colors.black54,
                                          //                 fontWeight:
                                          //                     FontWeight.w700,
                                          //               ),
                                          //               overflow:
                                          //                   TextOverflow.visible,
                                          //               maxLines: 1,
                                          //             ),
                                          //             const SizedBox(
                                          //               width: 5,
                                          //             ),
                                          //             Text(
                                          //               "${controller.foods[index].data()!["discountPrice"].toString()} AZN",
                                          //               style:
                                          //                   GoogleFonts.quicksand(
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .bold,
                                          //                       fontSize: 18,
                                          //                       color: context
                                          //                           .iconColor),
                                          //             )
                                          //           ],
                                          //         )
                                          //       else
                                          //         Text(
                                          //           "${controller.foods[index].data()!["price"].toString()} AZN",
                                          //           style: GoogleFonts.quicksand(
                                          //               fontWeight:
                                          //                   FontWeight.bold,
                                          //               fontSize: 18),
                                          //         )
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                          "assets/graffiti-heart-shape.png",
                                          color: Colors.pink,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${controller.popularFoods[index].data()!["like"] ?? 0}",
                                        style: GoogleFonts.encodeSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 22,
                                          child: VerticalDivider(
                                            color: context.iconColor,
                                            thickness: 0.5,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${controller.popularFoods[index].data()!["price"] ?? 0}",
                                        style: GoogleFonts.encodeSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        "AZN",
                                        style: GoogleFonts.encodeSans(
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
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                  // GetBuilder<HomeController>(
                  //   id: "followedDiscount",
                  //   builder: (controller) {
                  //     if (controller.followedRestaurantDiscounts.isNotEmpty) {
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(
                  //               "Izlədiklərim",
                  //               style: GoogleFonts.quicksand(
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //           GridView.builder(
                  //             padding: EdgeInsets.zero,
                  //             itemCount:
                  //                 controller.followedRestaurantDiscounts.length,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             shrinkWrap: true,
                  //             gridDelegate:
                  //                 const SliverGridDelegateWithFixedCrossAxisCount(
                  //                     crossAxisCount: 1,
                  //                     mainAxisSpacing: 5,
                  //                     crossAxisSpacing: 5,
                  //                     childAspectRatio: 2 / 1),
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 color: Colors.amber,
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     } else {
                  //       return const SizedBox();
                  //     }
                  //   },
                  // ),
                  // GetBuilder<HomeController>(
                  //   id: "discountForYou",
                  //   builder: (controller) {
                  //     if (controller.forYouDiscounts.isNotEmpty) {
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(
                  //               "Sizin üçün",
                  //               style: GoogleFonts.quicksand(
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ),
                  //           GridView.builder(
                  //             padding: EdgeInsets.zero,
                  //             itemCount: controller.forYouDiscounts.length,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             shrinkWrap: true,
                  //             gridDelegate:
                  //                 const SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 1,
                  //               mainAxisSpacing: 5,
                  //               crossAxisSpacing: 5,
                  //               childAspectRatio: 2 / 1,
                  //             ),
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 margin: const EdgeInsets.all(10),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(10),
                  //                   image: DecorationImage(
                  //                     fit: BoxFit.cover,
                  //                     image: NetworkImage(
                  //                       controller.forYouDiscounts[index]
                  //                           .data()!["coverPhoto"],
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 width: double.infinity,
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(5),
                  //                   child: BackdropFilter(
                  //                     filter: ImageFilter.blur(
                  //                       sigmaX: 0,
                  //                       sigmaY: 0,
                  //                     ),
                  //                     child: Material(
                  //                       color: Colors.transparent,
                  //                       borderRadius: BorderRadius.circular(5),
                  //                       child: InkWell(
                  //                         onTap: () {
                  //                           Get.bottomSheet(
                  //                             DiscountDetail(
                  //                               discountId: controller
                  //                                   .forYouDiscounts[index].id,
                  //                             ),
                  //                             isScrollControlled: true,
                  //                             backgroundColor:
                  //                                 context.theme.backgroundColor,
                  //                             shape:
                  //                                 const RoundedRectangleBorder(
                  //                               borderRadius: BorderRadius.only(
                  //                                 topLeft: Radius.circular(20),
                  //                                 topRight: Radius.circular(20),
                  //                               ),
                  //                             ),
                  //                           );
                  //                         },
                  //                         child: Stack(
                  //                           //fit: StackFit.expand,
                  //                           children: [
                  //                             Container(
                  //                               decoration: const BoxDecoration(
                  //                                 gradient: LinearGradient(
                  //                                   colors: [
                  //                                     Colors.white,
                  //                                     Colors.white54,
                  //                                     Colors.transparent
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Column(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.start,
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Padding(
                  //                                   padding: const EdgeInsets
                  //                                           .symmetric(
                  //                                       horizontal: 40,
                  //                                       vertical: 10),
                  //                                   child: foodMoodLogo(),
                  //                                 ),
                  //                                 Padding(
                  //                                   padding: const EdgeInsets
                  //                                           .symmetric(
                  //                                       horizontal: 10),
                  //                                   child: Column(
                  //                                     children: [
                  //                                       Text(
                  //                                         "${controller.forYouDiscounts[index].data()!["restaurantName"]}'dən",
                  //                                         style: GoogleFonts
                  //                                             .quicksand(
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .bold,
                  //                                                 // backgroundColor: Colors.red,
                  //                                                 fontSize: 20,
                  //                                                 color: Colors
                  //                                                     .black),
                  //                                       ),
                  //                                       const SizedBox(
                  //                                         height: 5,
                  //                                       ),
                  //                                       controller.forYouDiscounts[
                  //                                                           index]
                  //                                                       .data()![
                  //                                                   "menutype"] ==
                  //                                               1
                  //                                           ? Container(
                  //                                               decoration:
                  //                                                   BoxDecoration(
                  //                                                 color: Colors
                  //                                                     .red,
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             5),
                  //                                               ),
                  //                                               child: Text(
                  //                                                 " bütün menyu'ya ",
                  //                                                 style: GoogleFonts.quicksand(
                  //                                                     fontWeight:
                  //                                                         FontWeight
                  //                                                             .bold,
                  //                                                     fontSize:
                  //                                                         20,
                  //                                                     color: Colors
                  //                                                         .white),
                  //                                               ),
                  //                                             )
                  //                                           : Container(
                  //                                               decoration:
                  //                                                   BoxDecoration(
                  //                                                 color: Colors
                  //                                                     .red,
                  //                                                 borderRadius:
                  //                                                     BorderRadius
                  //                                                         .circular(
                  //                                                             5),
                  //                                               ),
                  //                                               child: Text(
                  //                                                 "seçilmiş yeməklərə",
                  //                                                 style: GoogleFonts.quicksand(
                  //                                                     fontWeight:
                  //                                                         FontWeight
                  //                                                             .bold,
                  //                                                     fontSize:
                  //                                                         20,
                  //                                                     color: Colors
                  //                                                         .white),
                  //                                               ),
                  //                                             ),
                  //                                       Text(
                  //                                         "endirim",
                  //                                         style: GoogleFonts
                  //                                             .quicksand(
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .bold,
                  //                                                 fontSize: 20,
                  //                                                 color: Colors
                  //                                                     .black),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                             controller.forYouDiscounts[index]
                  //                                             .data()![
                  //                                         "durationtype"] ==
                  //                                     1
                  //                                 ? Positioned(
                  //                                     top: 10,
                  //                                     right: 10,
                  //                                     child: Container(
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(10),
                  //                                         gradient:
                  //                                             RadialGradient(
                  //                                           radius: 2,
                  //                                           colors:
                  //                                               Get.isDarkMode
                  //                                                   ? [
                  //                                                       Colors
                  //                                                           .black38,
                  //                                                       Colors
                  //                                                           .black26,
                  //                                                       Colors
                  //                                                           .transparent
                  //                                                     ]
                  //                                                   : [
                  //                                                       Colors
                  //                                                           .white70,
                  //                                                       Colors
                  //                                                           .white60,
                  //                                                       Colors
                  //                                                           .transparent
                  //                                                     ],
                  //                                         ),
                  //                                       ),
                  //                                       child: Row(
                  //                                         mainAxisSize:
                  //                                             MainAxisSize.min,
                  //                                         children: [
                  //                                           Container(
                  //                                             decoration:
                  //                                                 BoxDecoration(
                  //                                               color: Get.isDarkMode
                  //                                                   ? Colors
                  //                                                       .black
                  //                                                   : Colors
                  //                                                       .white,
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           20),
                  //                                             ),
                  //                                             child: const Icon(
                  //                                                 Icons.person),
                  //                                           ),
                  //                                           Text(
                  //                                             " ${controller.forYouDiscounts[index].data()!["maxNumber"]}",
                  //                                             style: GoogleFonts
                  //                                                 .quicksand(),
                  //                                           ),
                  //                                           const SizedBox(
                  //                                             width: 4,
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   )
                  //                                 : Positioned(
                  //                                     top: 10,
                  //                                     right: 10,
                  //                                     child: Container(
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(10),
                  //                                         gradient:
                  //                                             RadialGradient(
                  //                                           radius: 2,
                  //                                           colors:
                  //                                               Get.isDarkMode
                  //                                                   ? [
                  //                                                       Colors
                  //                                                           .black38,
                  //                                                       Colors
                  //                                                           .black26,
                  //                                                       Colors
                  //                                                           .transparent
                  //                                                     ]
                  //                                                   : [
                  //                                                       Colors
                  //                                                           .white70,
                  //                                                       Colors
                  //                                                           .white60,
                  //                                                       Colors
                  //                                                           .transparent
                  //                                                     ],
                  //                                         ),
                  //                                       ),
                  //                                       child: Row(
                  //                                         mainAxisSize:
                  //                                             MainAxisSize.min,
                  //                                         children: [
                  //                                           Container(
                  //                                             height: 25,
                  //                                             width: 25,
                  //                                             decoration:
                  //                                                 BoxDecoration(
                  //                                               color: Get.isDarkMode
                  //                                                   ? Colors
                  //                                                       .black
                  //                                                   : Colors
                  //                                                       .white,
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           20),
                  //                                             ),
                  //                                             child: const Icon(
                  //                                               Icons
                  //                                                   .date_range_rounded,
                  //                                               size: 15,
                  //                                             ),
                  //                                           ),
                  //                                           GetBuilder<
                  //                                               HomeController>(
                  //                                             id: "endTime",
                  //                                             //assignId: true,
                  //                                             //global: false,
                  //                                             builder:
                  //                                                 (controller2) {
                  //                                               return Text(
                  //                                                 controller
                  //                                                     .defineEndTime(),
                  //                                                 style: GoogleFonts
                  //                                                     .quicksand(),
                  //                                               );
                  //                                             },
                  //                                           ),
                  //                                           const SizedBox(
                  //                                             width: 4,
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                             Positioned(
                  //                               bottom: 0,
                  //                               right: 0,
                  //                               child: Transform.rotate(
                  //                                 angle: 5.8,
                  //                                 child: Container(
                  //                                   height: 100,
                  //                                   width: 100,
                  //                                   decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             200),
                  //                                     gradient:
                  //                                         const RadialGradient(
                  //                                       colors: [
                  //                                         Colors.black54,
                  //                                         Colors.black12,
                  //                                         Colors.transparent,
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                   child: Stack(
                  //                                     alignment:
                  //                                         Alignment.center,
                  //                                     children: [
                  //                                       Image.asset(
                  //                                         "assets/discount.png",
                  //                                         scale: 3,
                  //                                         color: Colors.red,
                  //                                       ),
                  //                                       Column(
                  //                                         mainAxisSize:
                  //                                             MainAxisSize.max,
                  //                                         crossAxisAlignment:
                  //                                             CrossAxisAlignment
                  //                                                 .center,
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .center,
                  //                                         children: [
                  //                                           Text(
                  //                                             "${controller.forYouDiscounts[index].data()!["discount"]}%",
                  //                                             style: GoogleFonts
                  //                                                 .quicksand(
                  //                                               color: Colors
                  //                                                   .white,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .bold,
                  //                                               fontSize: 26,
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       )
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     } else {
                  //       return const SizedBox();
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          )
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(
          //                 "FoodMood seçimi",
          //                 style: GoogleFonts.quicksand(
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             Container(
          //               height: 140,
          //               child: ListView.separated(
          //                 shrinkWrap: true,
          //                 scrollDirection: Axis.horizontal,
          //                 separatorBuilder: (context, index) {
          //                   return SizedBox(
          //                     width: 5,
          //                   );
          //                 },
          //                 itemCount: 30,
          //                 itemBuilder: (context, index) {
          //                   return Column(
          //                     children: [
          //                       Container(
          //                         width: 120,
          //                         height: 120,
          //                         decoration: BoxDecoration(
          //                           color: Colors.grey[200],
          //                           borderRadius: BorderRadius.circular(5),
          //                         ),
          //                         child: Text(""),
          //                       ),
          //                       Text("restaurantname")
          //                     ],
          //                   );
          //                 },
          //               ),
          //             )
          //           ],
          //         ),
          //         Column(
          //           children: [
          //             // Text("Gunun teklifi"),
          //             Container(
          //               height: 200,
          //               width: double.infinity,
          //               child: CarouselSlider.builder(
          //                 itemCount: 10,
          //                 itemBuilder: (context, index, index2) {
          //                   return Container(
          //                     margin: EdgeInsets.symmetric(horizontal: 5),
          //                     decoration: BoxDecoration(
          //                       color: Colors.pink,
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                   );
          //                 },
          //                 options: CarouselOptions(viewportFraction: 0.8),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Divider(),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(
          //                 "Izlədiklərim",
          //                 style: GoogleFonts.quicksand(
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             GridView.builder(
          //               padding: EdgeInsets.zero,
          //               itemCount: 10,
          //               physics: NeverScrollableScrollPhysics(),
          //               shrinkWrap: true,
          //               gridDelegate:
          //                   SliverGridDelegateWithFixedCrossAxisCount(
          //                       crossAxisCount: 1,
          //                       mainAxisSpacing: 5,
          //                       crossAxisSpacing: 5,
          //                       childAspectRatio: 2 / 1),
          //               itemBuilder: (context, index) {
          //                 return Container(
          //                   color: Colors.amber,
          //                 );
          //               },
          //             ),
          //           ],
          //         ),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(
          //                 "Sizin üçün",
          //                 style: GoogleFonts.quicksand(
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             GridView.builder(
          //               padding: EdgeInsets.zero,
          //               itemCount: 10,
          //               physics: NeverScrollableScrollPhysics(),
          //               shrinkWrap: true,
          //               gridDelegate:
          //                   SliverGridDelegateWithFixedCrossAxisCount(
          //                       crossAxisCount: 1,
          //                       mainAxisSpacing: 5,
          //                       crossAxisSpacing: 5,
          //                       childAspectRatio: 2 / 1),
          //               itemBuilder: (context, index) {
          //                 return Container(
          //                   color: Colors.amber,
          //                 );
          //               },
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
