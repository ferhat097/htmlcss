// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/DiscountDetailController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../DarkModeController.dart';
import '../../FoodMoodLogo.dart';
import 'FoodDetail.dart';
import 'RestaurantPage/RestaurantPage.dart';

class DiscountDetail extends StatefulWidget {
  final String discountId;
  const DiscountDetail({Key? key, required this.discountId}) : super(key: key);

  @override
  _DiscountDetailState createState() => _DiscountDetailState();
}

class _DiscountDetailState extends State<DiscountDetail> {
  DiscountDetailController discountDetailController =
      Get.put(DiscountDetailController());
  @override
  void initState() {
    discountDetailController.listenDiscountQuery(widget.discountId);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DiscountDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.discountId);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: GetBuilder<DiscountDetailController>(
        builder: (controller) {
          if (controller.discount != null) {
            return Column(
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        controller.discount!.data()!["coverPhoto"] ?? "",
                      ),
                    ),
                  ),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              DiscountDetail(
                                discountId: controller.discount!.id,
                              ),
                              isScrollControlled: true,
                              backgroundColor: context.theme.backgroundColor,
                              shape: const RoundedRectangleBorder(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    child: foodMoodLogo(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${controller.discount!.data()!["restaurantName"] ?? ""}'dən",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              // backgroundColor: Colors.red,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        controller.discount!
                                                    .data()!["menutype"] ==
                                                1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  " bütün menyu'ya ",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  "seçilmiş yeməklərə",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                        Text(
                                          "endirim",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // controller.discount!.data()!["durationtype"] ??
                              //        == 1
                              //     ? Positioned(
                              //         top: 10,
                              //         right: 10,
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //             gradient: RadialGradient(
                              //               radius: 2,
                              //               colors: Get.isDarkMode
                              //                   ? [
                              //                       Colors.black38,
                              //                       Colors.black26,
                              //                       Colors.transparent
                              //                     ]
                              //                   : [
                              //                       Colors.white70,
                              //                       Colors.white60,
                              //                       Colors.transparent
                              //                     ],
                              //             ),
                              //           ),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               Container(
                              //                 decoration: BoxDecoration(
                              //                   color: Get.isDarkMode
                              //                       ? Colors.black
                              //                       : Colors.white,
                              //                   borderRadius:
                              //                       BorderRadius.circular(20),
                              //                 ),
                              //                 child: const Icon(Icons.person),
                              //               ),
                              //               Text(
                              //                 " ${controller.discount!.data()!["maxNumber"] ?? 0}",
                              //                 style: GoogleFonts.quicksand(),
                              //               ),
                              //               const SizedBox(
                              //                 width: 4,
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     :
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: RadialGradient(
                                      radius: 2,
                                      colors: Get.isDarkMode
                                          ? [
                                              Colors.black38,
                                              Colors.black26,
                                              Colors.transparent
                                            ]
                                          : [
                                              Colors.white70,
                                              Colors.white60,
                                              Colors.transparent
                                            ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.date_range_rounded,
                                          size: 15,
                                        ),
                                      ),
                                      GetBuilder<DiscountDetailController>(
                                        id: "endTime",
                                        //assignId: true,
                                        //global: false,
                                        builder: (controller2) {
                                          return Text(
                                            controller.defineEndTime(),
                                            style: GoogleFonts.quicksand(),
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
                                      borderRadius: BorderRadius.circular(200),
                                      gradient: const RadialGradient(
                                        colors: [
                                          Colors.black54,
                                          Colors.black12,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset("assets/discount.png",
                                            scale: 3, color: Colors.red),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${controller.discount!.data()!["discount"] ?? 0}%",
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Text(
                                  // controller.discount!
                                  //             .data()!["durationtype"] ==
                                  //         1
                                  //     ? "Endirim sayı":
                                  "Endirimin bitmə vaxtı",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      // child: controller.discount!
                                      //             .data()!["durationtype"] ==
                                      //         1
                                      //     ? Row(
                                      //         children: [
                                      //           Text(
                                      //             "Son:",
                                      //             style: GoogleFonts.quicksand(
                                      //                 fontWeight: FontWeight.bold),
                                      //           ),
                                      //           SizedBox(
                                      //             width: 5,
                                      //           ),
                                      //           Text(
                                      //             "5 nəfər",
                                      //             style: GoogleFonts.quicksand(
                                      //                 fontWeight: FontWeight.bold),
                                      //           )
                                      //         ],
                                      //       )
                                      //     :
                                      Row(
                                    children: [
                                      Text(
                                        "14 mart 14:30 - 15 mart 15:30",
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (controller.discount!.data()!["menutype"] == 2)
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: Text(
                                    "Endirimə daxil olan yeməklər:",
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (controller.foods.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.foods.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Container(
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            gradient: LinearGradient(
                                              colors: defineMainCardGradient(),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                Get.bottomSheet(
                                                  FoodDetail(
                                                    foodId: controller
                                                        .foods[index]["foodId"],
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                        child: Image.network(
                                                          controller
                                                                  .foods[index]
                                                              ["foodImage"],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            controller.foods[
                                                                        index][
                                                                    "foodName"] ??
                                                                "",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          controller.foods[
                                                                      index]
                                                                  ["isDiscount"]
                                                              ? Row(
                                                                  children: [
                                                                    Text(
                                                                      "${controller.foods[index]["price"].toStringAsFixed(2) ?? 0} Azn",
                                                                      style: GoogleFonts.quicksand(
                                                                          fontSize:
                                                                              16,
                                                                          decoration:
                                                                              TextDecoration.lineThrough),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "${controller.foods[index]["discountPrice"].toStringAsFixed(2) ?? 0} Azn",
                                                                      style: GoogleFonts.quicksand(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Text(
                                                                  "${controller.foods[index]["price"] ?? 0} Azn",
                                                                  style: GoogleFonts.quicksand(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      gradient: Get.isDarkMode
                                                          ? LinearGradient(
                                                              colors: [
                                                                  Colors.black,
                                                                  Color(Colors
                                                                      .grey[
                                                                          900]!
                                                                      .value),
                                                                ])
                                                          : LinearGradient(
                                                              colors: [
                                                                Color(Colors
                                                                    .grey[50]!
                                                                    .value),
                                                                Color(Colors
                                                                    .grey[100]!
                                                                    .value),
                                                              ],
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.info,
                                                            color:
                                                                defineWhiteBlack(),
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
                                  ),
                              ],
                            ),
                          )
                        else
                          Container(
                            child: Center(
                              child: Text("Endirim bütün menyu'ya aiddir",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  )),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Material(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        print(discountDetailController.discount!.id);
                        Get.off(
                          () => RestaurantPage(
                            restaurantId: discountDetailController.discount!
                                .data()!["restaurantId"],
                          ),
                        );
                      },
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Restorana get",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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
    );
  }
}
