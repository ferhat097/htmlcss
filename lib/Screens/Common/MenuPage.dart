// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MenuPageController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:foodmood/Screens/Common/Order/OrderPage.dart';
import 'package:foodmood/Screens/Common/OrderPasswordDialog.dart';
import 'package:foodmood/Screens/Home/SendFood.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../DarkModeController.dart';
import 'FoodDetail.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;
  final bool fromQr;
  final int? tableNumber;
  const MenuPage({
    Key? key,
    required this.restaurantId,
    required this.fromQr,
    this.tableNumber,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    menuPageController.getMenu(widget.restaurantId);
    if (widget.fromQr) {
      menuPageController.checkTable(widget.restaurantId, widget.tableNumber!);
    }
    super.initState();
  }

  MenuPageController menuPageController = Get.put(MenuPageController());
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defineMainBackgroundColor(),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(child: builSearchedPage()),
        ),
      ),
    );
  }

  Widget builSearchedPage() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Axtar',
      elevation: 0,
      backdropColor: context.theme.primaryColor,
      backgroundColor: context.theme.primaryColor,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        menuPageController.searchFood(query);
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              menuPageController.state = true;
              menuPageController.getMenu(widget.restaurantId);
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return GetBuilder<MenuPageController>(
          builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.searcedMenu.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: defineMainCardGradient(),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.bottomSheet(
                            FoodDetail(
                              foodId: controller.searcedMenu[index]["foodId"],
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: controller.defineFoodImage(
                                          controller.searcedMenu[index]
                                              ["foodImage"],
                                          controller.searcedMenu[index]
                                              ["categoryId"],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.searcedMenu[index]
                                                ["name"],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            "${controller.searcedMenu[index]["price"]} Azn",
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  gradient: Get.isDarkMode
                                      ? LinearGradient(colors: [
                                          Colors.black,
                                          Color(Colors.grey[900]!.value),
                                        ])
                                      : LinearGradient(
                                          colors: [
                                            Color(Colors.grey[50]!.value),
                                            Color(Colors.grey[100]!.value),
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      Get.bottomSheet(
                                        SendFood(
                                          food: controller.searcedMenu[index],
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
                                      child: Icon(
                                        Icons.share,
                                        color: defineWhiteBlack(),
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
                  ),
                );
              },
            );
          },
        );
      },
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
          //   child: IntrinsicHeight(
          //     child: Row(
          //       children: [
          //         Container(
          //           height: double.infinity,
          //           decoration: BoxDecoration(
          //             color: context.theme.canvasColor,
          //             borderRadius: BorderRadius.circular(5),
          //           ),
          //           child: Material(
          //             borderRadius: BorderRadius.circular(5),
          //             color: Colors.transparent,
          //             child: InkWell(
          //               borderRadius: BorderRadius.circular(5),
          //               onTap: () {
          //                 Get.back();
          //               },
          //               child: Padding(
          //                 padding:
          //                     const EdgeInsets.symmetric(horizontal: 10),
          //                 child: Icon(widget.fromQr
          //                     ? Icons.cancel
          //                     : Icons.arrow_back_ios_new),
          //               ),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 5,
          //         ),
          //         Expanded(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               //color: Colors.grey[200]!.withOpacity(0.8),
          //               gradient: Get.isDarkMode
          //                   ? LinearGradient(colors: [
          //                       Colors.black54,
          //                       // Color(Colors
          //                       //     .grey[800]!.value)
          //                       Colors.black45
          //                     ])
          //                   : LinearGradient(colors: [
          //                       Color(Colors.blueGrey[50]!.value)
          //                           .withOpacity(0.8),
          //                       Color(0xFFe4eef0).withOpacity(0.8),
          //                     ]),
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             child: Row(
          //               children: [
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Icon(
          //                   Icons.search,
          //                   color: Colors.grey,
          //                 ),
          //                 Expanded(
          //                   child: TextField(
          //                     decoration: InputDecoration(
          //                       border: InputBorder.none,
          //                       hintText: "Axtar",
          //                       contentPadding: EdgeInsets.all(5),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Container(
          //           height: double.infinity,
          //           decoration: BoxDecoration(
          //               color: defineTextFieldColor(),
          //               borderRadius: BorderRadius.circular(10)),
          //           child: Material(
          //             borderRadius: BorderRadius.circular(10),
          //             color: Colors.transparent,
          //             child: InkWell(
          //               borderRadius: BorderRadius.circular(10),
          //               onTap: () {
          //                 menuPageController.state = true;
          //                 menuPageController.getMenu(widget.restaurantId);
          //               },
          //               child: Padding(
          //                 padding:
          //                     const EdgeInsets.symmetric(horizontal: 10),
          //                 child: Icon(Icons.refresh),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: GetBuilder<MenuPageController>(
              builder: (controller) {
                if (controller.menus.isNotEmpty) {
                  // if (controller.state) {
                  //   menuPageController.tabController = TabController(
                  //       length: menuPageController.menus.length, vsync: this);
                  //   menuPageController.tabController?.animateTo(0);
                  //   controller.state = false;
                  // }
                  // print(menuPageController.tabController!.index);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: DefaultTabController(
                      length: menuPageController.menus.length,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabs: controller.menus.keys
                                .map(
                                  (e) => Text(
                                    e['categoryName'].toString(),
                                    style: GoogleFonts.quicksand(
                                        color: defineWhiteBlack(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )
                                .toList(),
                            labelPadding: EdgeInsets.all(20),
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            unselectedLabelStyle:
                                GoogleFonts.quicksand(color: Colors.black87),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TabBarView(
                                //controller: menuPageController.tabController,
                                children: List.generate(
                                  controller.menus.values.length,
                                  (index) => Container(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 5,
                                          width: 5,
                                        );
                                      },
                                      itemCount: controller.menus.entries
                                          .elementAt(index)
                                          .value
                                          .length,
                                      itemBuilder: (context, index2) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              gradient: LinearGradient(
                                                colors:
                                                    defineMainCardGradient(),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () {
                                                  Get.bottomSheet(
                                                    FoodDetail(
                                                      foodId: controller
                                                          .menus.entries
                                                          .elementAt(index)
                                                          .value[index2]
                                                          .data()["foodId"],
                                                    ),
                                                    isScrollControlled: true,
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: SizedBox(
                                                                height: 90,
                                                                width: 90,
                                                                child: controller.defineFoodImage(
                                                                    controller
                                                                            .menus
                                                                            .entries
                                                                            .elementAt(
                                                                                index)
                                                                            .value[
                                                                                index2]
                                                                            .data()[
                                                                        "foodImage"],
                                                                    controller
                                                                        .menus
                                                                        .entries
                                                                        .elementAt(
                                                                            index)
                                                                        .value[
                                                                            index2]
                                                                        .data()["categoryId"]),
                                                                // child: controller.menus.entries.elementAt(index).value[index2].data()[
                                                                //                 "foodImage"] !=
                                                                //             null &&
                                                                //         controller
                                                                //             .menus
                                                                //             .entries
                                                                //             .elementAt(
                                                                //                 index)
                                                                //             .value[
                                                                //                 index2]
                                                                //             .data()[
                                                                //                 "foodImage"]
                                                                //             .isNotEmpty
                                                                // ? Image.network(controller
                                                                //         .menus
                                                                //         .entries
                                                                //         .elementAt(
                                                                //             index)
                                                                //         .value[
                                                                //             index2]
                                                                //         .data()[
                                                                //     "foodImage"])
                                                                //     : Image.network(
                                                                //         firebaseRemoteConfigController
                                                                //             .menuCategory
                                                                //             .entries
                                                                //             .where(
                                                                //               (element) =>
                                                                //                   element.value["categoryId"] ==
                                                                //                   controller.menus.entries.elementAt(index).value[index2].data()["categoryId"],
                                                                //             )
                                                                //             .first
                                                                //             .value["categoryPhoto"]),
                                                                // child: Image
                                                                //     .network(
                                                                //   controller
                                                                //       .menus
                                                                //       .entries
                                                                //       .elementAt(
                                                                //           index)
                                                                //       .value[
                                                                //           index2]
                                                                //       .data()["foodImage"],
                                                                // ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .menus
                                                                        .entries
                                                                        .elementAt(
                                                                            index)
                                                                        .value[
                                                                            index2]
                                                                        .data()["name"],
                                                                    style: GoogleFonts.quicksand(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    "${controller.menus.entries.elementAt(index).value[index2].data()["price"]} Azn",
                                                                    style: GoogleFonts.quicksand(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          gradient: Get
                                                                  .isDarkMode
                                                              ? LinearGradient(
                                                                  colors: [
                                                                      Colors
                                                                          .black,
                                                                      Color(Colors
                                                                          .grey[
                                                                              900]!
                                                                          .value),
                                                                    ])
                                                              : LinearGradient(
                                                                  colors: [
                                                                    Color(Colors
                                                                        .grey[
                                                                            50]!
                                                                        .value),
                                                                    Color(Colors
                                                                        .grey[
                                                                            100]!
                                                                        .value),
                                                                  ],
                                                                ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () {
                                                              Get.bottomSheet(
                                                                SendFood(
                                                                    food: controller
                                                                        .menus
                                                                        .entries
                                                                        .elementAt(
                                                                            index)
                                                                        .value[
                                                                            index2]
                                                                        .data()),
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
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons.share,
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
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
          // if (widget.fromQr)
          // GetBuilder<MenuPageController>(
          //   builder: (controller) {
          //     return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //       future: controller.getRestaurant(widget.restaurantId),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           if (snapshot.data!.data()!["isActiveTableOrder"]) {
          //             return IgnorePointer(
          //               ignoring: controller.busy == null,
          //               child: Container(
          //                 height: 70,
          //                 width: double.infinity,
          //                 decoration: BoxDecoration(
          //                   color: defineTextFieldColor(),
          //                 ),
          //                 child: Container(
          //                   margin: EdgeInsets.all(10),
          //                   width: double.infinity,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5),
          //                     color: Colors.green,
          //                   ),
          //                   child: Material(
          //                     color: Colors.transparent,
          //                     borderRadius: BorderRadius.circular(5),
          //                     child: InkWell(
          //                       borderRadius: BorderRadius.circular(5),
          //                       onTap: () {
          //                         if (!controller.busy!) {
          //                           Get.off(
          //                             () => OrderPage(
          //                               createOrder: true,
          //                               restaurantId: widget.restaurantId,
          //                               tableNumber: widget.tableNumber!,
          //                               orderId: controller.orderId,
          //                               needJoin: false,
          //                             ),
          //                           );
          //                         } else {
          //                           Get.dialog(
          //                             OrderPasswordDialog(
          //                               tableNumber: widget.tableNumber!,
          //                               restaurantId: widget.restaurantId,
          //                             ),
          //                           );
          //                         }
          //                       },
          //                       child: Center(
          //                         child: controller.busy != null
          //                             ? Text(
          //                                 controller.busy!
          //                                     ? "Sifariş əlavə et"
          //                                     : "Sifarişə başla",
          //                                 style: GoogleFonts.quicksand(
          //                                     color: Colors.white,
          //                                     fontWeight: FontWeight.bold),
          //                               )
          //                             : CircularProgressIndicator(),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             );
          //           } else {
          //             // ignore: avoid_unnecessary_containers
          //             return Container(
          //               child: Text(
          //                 "Masadan sifariş aktiv deyil",
          //                 style: GoogleFonts.quicksand(),
          //               ),
          //             );
          //           }
          //         } else {
          //           return SizedBox();
          //         }
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
