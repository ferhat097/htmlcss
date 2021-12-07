// ignore_for_file: unused_import, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:foodmood/Controllers/FoodDetailController.dart';
import 'package:foodmood/Screens/Home/SendFood.dart';
import 'package:foodmood/Screens/Home/WriteCommentFood.dart';
import 'package:foodmood/Screens/Login/LoginSplash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../DarkModeController.dart';
import 'ReportComment.dart';
import 'RestaurantPage/RestaurantPage.dart';
import 'UserProfile.dart';

class FoodDetail extends StatefulWidget {
  //final Map<String, dynamic> food;
  final String foodId;
  //final bool fromDiscount;
  const FoodDetail({Key? key, required this.foodId}) : super(key: key);

  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  FoodDetailController foodDetailController = Get.put(FoodDetailController());
  @override
  void initState() {
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      foodDetailController.listenFoodComment(widget.foodId);
    }

    foodDetailController.listenFoodQuery(widget.foodId);

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<FoodDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: GetBuilder<FoodDetailController>(builder: (controller) {
        if (controller.food != null) {
          List likedUsers = controller.food!["likedUsers"] ?? [];
          int like = controller.food!["like"] ?? 0;
          return Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                                minHeight: 250,
                                minWidth: double.infinity,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  controller.food!["foodImage"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.food!["name"].toUpperCase(),
                                    style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (controller.food!["isDiscount"] ?? false)
                              Positioned(
                                top: 20,
                                left: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${controller.food!["price"].toString()} AZN",
                                          style: GoogleFonts.encodeSans(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${controller.food!["discountPrice"].toString()} AZN",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              // margin:
                              //     const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Container(
                                  //   width: double.infinity,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.pink.withOpacity(0.5),
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(5.0),
                                  //     child: Center(
                                  //       child: Text(
                                  //         widget.food["name"],
                                  //         style: GoogleFonts.oswald(
                                  //           fontWeight: FontWeight.w900,
                                  //           fontSize: 20,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 100,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: context.theme.primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            controller.food!["isDiscount"]
                                                ? "${controller.food!["discountPrice"].toString()} AZN"
                                                : "${controller.food!["price"].toString()} AZN",
                                            style: GoogleFonts.encodeSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onDoubleTap: () {
                                          if (!FirebaseAuth.instance
                                              .currentUser!.isAnonymous) {
                                            bool like;
                                            if (likedUsers.contains(FirebaseAuth
                                                .instance.currentUser!.uid)) {
                                              like = false;
                                            } else {
                                              like = true;
                                            }

                                            foodDetailController.likeFood(
                                              controller.food!["foodId"],
                                              like,
                                            );
                                          }
                                        },
                                        onTap: () {},
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image.asset(
                                            "assets/graffiti-heart-shape.png",
                                            color: likedUsers.contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                ? Colors.pink
                                                : context.iconColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 100,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: context.theme.primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  "assets/graffiti-heart-shape.png",
                                                  color: Colors.pink,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                like.toString(),
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(5),
                                      //       color: context.theme.primaryColor),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(10),
                                      //     child: Text(
                                      //       "${widget.food["preparedTime"].toString()} dəq",
                                      //       style: GoogleFonts.quicksand(
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 16),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  if (!FirebaseAuth
                                      .instance.currentUser!.isAnonymous)
                                    if (likedUsers.contains(
                                        FirebaseAuth.instance.currentUser!.uid))
                                      Text(
                                        "Bəyənənləri görmək üçün toxun",
                                        style: GoogleFonts.encodeSans(),
                                      )
                                    else
                                      Text(
                                        "Bəyənmək üçün iki dəfə toxun",
                                        style: GoogleFonts.encodeSans(),
                                      )
                                  else
                                    Text(
                                      "Bəyənmək üçün qeydiyyatdan keç",
                                      style: GoogleFonts.encodeSans(),
                                    ),

                                  if (controller.food!["info"] != null &&
                                      controller.food!["info"] != "")
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        controller.food!["info"],
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  if (controller.food!["composition"] != null)
                                    Wrap(
                                      children: List.generate(
                                        controller.food!["composition"].length,
                                        (index) => Text(
                                          "${controller.food!["composition"][index]}, ",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Material(
                                        color: Colors.green,
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          onTap: () {
                                            Get.bottomSheet(
                                              SendFood(food: controller.food!),
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  context.theme.canvasColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                "PAYLAŞ",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  if (!FirebaseAuth
                                      .instance.currentUser!.isAnonymous)
                                    GetBuilder<FoodDetailController>(
                                      builder: (controller) {
                                        if (controller.comments.isNotEmpty) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Rəylər",
                                                      style: GoogleFonts
                                                          .encodeSans(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color:
                                                            context.iconColor,
                                                      ),
                                                    ),
                                                    Material(
                                                      elevation: 3,
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        onTap: () {
                                                          Get.bottomSheet(
                                                            WriteCommentFood(
                                                              foodId: controller
                                                                      .food![
                                                                  "foodId"],
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
                                                                  20,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "RƏY YAZ",
                                                                style: GoogleFonts
                                                                    .encodeSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              ListView.separated(
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 5,
                                                  );
                                                },
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    controller.comments.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onDoubleTap: () {
                                                      List likedUsers = controller
                                                                      .comments[
                                                                  index]
                                                              ["likedUsers"] ??
                                                          [];
                                                      if (likedUsers.contains(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)) {
                                                        controller.likeComment(
                                                          controller.comments[
                                                                  index]
                                                              ["commentId"],
                                                          controller.comments[
                                                              index]["foodId"],
                                                          false,
                                                        );
                                                      } else {
                                                        controller.likeComment(
                                                          controller.comments[
                                                                  index]
                                                              ["commentId"],
                                                          controller.comments[
                                                              index]["foodId"],
                                                          true,
                                                        );
                                                      }
                                                    },
                                                    child: Card(
                                                      elevation: 0,
                                                      margin: EdgeInsets.zero,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (controller.comments[index]["fromId"] !=
                                                                              FirebaseAuth.instance.currentUser!.uid) {
                                                                            Get.to(
                                                                              () => UserProfile(
                                                                                userId: controller.comments[index]["fromId"],
                                                                              ),
                                                                              preventDuplicates: false,
                                                                              transition: Transition.size,
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(
                                                                            controller.comments[index]["fromPhoto"],
                                                                          ),
                                                                          radius:
                                                                              30,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          constraints:
                                                                              const BoxConstraints(
                                                                            maxHeight:
                                                                                100,
                                                                            minHeight:
                                                                                50,
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                controller.comments[index]["fromName"],
                                                                                style: GoogleFonts.encodeSans(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                child: Text(
                                                                                  controller.comments[index]["comment"],
                                                                                  maxLines: 4,
                                                                                  style: GoogleFonts.quicksand(
                                                                                    fontSize: 15,
                                                                                    color: context.iconColor,
                                                                                    fontWeight: FontWeight.w600,
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
                                                                FocusedMenuHolder(
                                                                  menuBoxDecoration:
                                                                      BoxDecoration(
                                                                    color: context
                                                                        .theme
                                                                        .primaryColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  openWithTap:
                                                                      true,
                                                                  onPressed:
                                                                      () {},
                                                                  menuItems: [
                                                                    if (controller.comments[index]
                                                                            [
                                                                            "fromId"] !=
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                      FocusedMenuItem(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        title:
                                                                            Text(
                                                                          "Şikayət et",
                                                                          style:
                                                                              GoogleFonts.encodeSans(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                        ),
                                                                        trailingIcon:
                                                                            const Icon(
                                                                          Icons
                                                                              .report,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Get.bottomSheet(
                                                                            ReportComment(
                                                                              what: 1,
                                                                              id1: controller.comments[index]["foodId"],
                                                                              id2: controller.comments[index]["commentId"],
                                                                              reportedUserId: controller.comments[index]["fromId"],
                                                                            ),
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor:
                                                                                context.theme.canvasColor,
                                                                            shape:
                                                                                const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(20),
                                                                                topRight: Radius.circular(20),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    if (controller.comments[index]
                                                                            [
                                                                            "fromId"] ==
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                      FocusedMenuItem(
                                                                        backgroundColor: context
                                                                            .theme
                                                                            .canvasColor,
                                                                        title:
                                                                            Text(
                                                                          "Sil",
                                                                          style:
                                                                              GoogleFonts.encodeSans(
                                                                            color:
                                                                                context.iconColor,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                        ),
                                                                        trailingIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              context.iconColor,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          controller
                                                                              .removeComment(
                                                                            controller.comments[index]["commentId"],
                                                                            controller.comments[index]["foodId"],
                                                                          );
                                                                        },
                                                                      )
                                                                  ],
                                                                  child:
                                                                      Material(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      100,
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      // onTap: () {},
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .more_horiz,
                                                                        size:
                                                                            35,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/graffiti-heart-shape.png",
                                                                      color: controller.comments[index]["likedUsers"].contains(FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid)
                                                                          ? Colors
                                                                              .pink
                                                                          : context
                                                                              .iconColor,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                    width: 5,
                                                                    height: 5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: context
                                                                          .iconColor!
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "${controller.comments[index]["like"] ?? 0}",
                                                                    style: GoogleFonts
                                                                        .encodeSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  if (!controller
                                                                      .comments[
                                                                          index]
                                                                          [
                                                                          "likedUsers"]
                                                                      .contains(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid))
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          "Bəyənmək üçün iki dəfə toxun",
                                                                          style:
                                                                              GoogleFonts.quicksand(
                                                                            fontWeight:
                                                                                FontWeight.w600,
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
                                                },
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: Center(
                                                  child: Text(
                                                    "İlk rəy yazan sən ol!",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  elevation: 3,
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    onTap: () {
                                                      Get.bottomSheet(
                                                        WriteCommentFood(
                                                          foodId: controller
                                                              .food!["foodId"],
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
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                              Icons.add_comment,
                                                              color:
                                                                  Colors.white),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "RƏY YAZ",
                                                            style: GoogleFonts
                                                                .encodeSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    )
                                  else
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rəyləri görmək və rəy yazmaq üçün",
                                            style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.pink,
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(
                                                    () => const LoginSplash());
                                              },
                                              child: Text(
                                                "Qeydiyyatdan keç vəya daxil ol",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // if (!widget.fromDiscount)
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                width: double.infinity,
                child: Material(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  //  color: Colors.pink.withOpacity(0.8),
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    onTap: () {
                      Get.off(
                        () => RestaurantPage(
                          restaurantId: controller.food!["restaurantId"],
                        ),
                      );
                    },
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(
                                  controller.food!["restaurantImage"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  controller.food!["restaurantName"],
                                  style: GoogleFonts.encodeSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Restorana baxmaq üçün toxun",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // child: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Center(
                      //     child: Text(
                      //       "Restorana bax",
                      //       style: GoogleFonts.encodeSans(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 18,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: context.iconColor,
            ),
          );
        }
      }),
    );
  }
}
