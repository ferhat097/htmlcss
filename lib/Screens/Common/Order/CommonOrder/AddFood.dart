// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AddFoodController.dart';
import 'package:foodmood/Controllers/MenuPageController.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/UserProfileController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../DarkModeController.dart';

class AddFood extends StatefulWidget {
  final String orderId;
  final int tableNumber;
  final String restaurantId;
  const AddFood(
      {Key? key,
      required this.orderId,
      required this.tableNumber,
      required this.restaurantId})
      : super(key: key);

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  dispose() {
    Get.delete<AddFoodController>();
    super.dispose();
  }

  AddFoodController addFoodController = Get.put(AddFoodController());
  MenuPageController menuPageController = Get.put(MenuPageController());
  OrderController orderController = Get.find();
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  ProfilePageController profilePageController = Get.find();
  @override
  void initState() {
    print(widget.restaurantId);
    menuPageController.getMenu(widget.restaurantId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: defineMainBackgroundColor(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: Scaffold(
          body: buildSearch(),
        ));
  }

  Widget buildSearch() {
    return FloatingSearchBar(
      hint: 'Axtar',
      elevation: 0,
      backdropColor: context.theme.primaryColor,
      backgroundColor: context.theme.primaryColor,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      //axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      //width: isPortrait ? 600 : 500,
      width: 600,
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
            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 5,
                  width: 5,
                );
              },
              itemCount: controller.searcedMenu.length,
              itemBuilder: (context, index2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        onTap: () {},
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
                                          controller.searcedMenu[index2]
                                              ["foodImage"],
                                          controller.searcedMenu[index2]
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
                                            controller.searcedMenu[index2]
                                                ["name"],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            "${controller.searcedMenu[index2]["price"]} Azn",
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
                              GetBuilder<AddFoodController>(
                                builder: (controller2) {
                                  return IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: defineTextFieldColor(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        defineTextFieldColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (addFoodController
                                                          .menuList!
                                                          .where((element) =>
                                                              element[
                                                                  "foodId"] ==
                                                              controller.searcedMenu[
                                                                      index2]
                                                                  ["foodId"])
                                                          .isNotEmpty) {
                                                        addFoodController.increaseAmount(
                                                            controller
                                                                    .searcedMenu[
                                                                index2],
                                                            false,
                                                            food: addFoodController
                                                                .menuList!
                                                                .where((element) =>
                                                                    element[
                                                                        "foodId"] ==
                                                                    controller
                                                                            .searcedMenu[index2]
                                                                        [
                                                                        "foodId"])
                                                                .first);
                                                      } else {
                                                        addFoodController
                                                            .increaseAmount(
                                                          controller
                                                                  .searcedMenu[
                                                              index2],
                                                          true,
                                                        );
                                                      }
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Icon(Icons.add,
                                                        size: 40),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 25,
                                                child: Center(
                                                  child: Text(
                                                    addFoodController.menuList!
                                                            .where((element) =>
                                                                element[
                                                                    "foodId"] ==
                                                                controller.searcedMenu[
                                                                        index2]
                                                                    ["foodId"])
                                                            .isNotEmpty
                                                        ? addFoodController
                                                            .menuList!
                                                            .where((element) =>
                                                                element[
                                                                    "foodId"] ==
                                                                controller.searcedMenu[
                                                                        index2]
                                                                    ["foodId"])
                                                            .first["amount"]
                                                            .toString()
                                                        : "0",
                                                    style: GoogleFonts.quicksand(
                                                        color:
                                                            defineWhiteBlack(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: defineTextFieldColor(),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: () {
                                                      addFoodController.decreaseAmount(
                                                          addFoodController
                                                              .menuList!
                                                              .where((element) =>
                                                                  element[
                                                                      "foodId"] ==
                                                                  controller.searcedMenu[
                                                                          index2]
                                                                      [
                                                                      "foodId"])
                                                              .first);
                                                    },
                                                    child: addFoodController
                                                            .menuList!
                                                            .where((element) =>
                                                                element[
                                                                    "foodId"] ==
                                                                controller.searcedMenu[
                                                                        index2]
                                                                    ["foodId"])
                                                            .isNotEmpty
                                                        ? addFoodController
                                                                    .menuList!
                                                                    .where((element) =>
                                                                        element[
                                                                            "foodId"] ==
                                                                        controller.searcedMenu[index2]
                                                                            ["foodId"])
                                                                    .first["amount"] ==
                                                                1
                                                            ? Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 20),
                                                              )
                                                            : Icon(Icons.remove, size: 40)
                                                        : Icon(
                                                            Icons.circle,
                                                            size: 40,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
      body: SlidingUpPanel(
        backdropTapClosesPanel: true,
        backdropEnabled: true,
        minHeight: 150,
        //parallaxEnabled: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        collapsed: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Get.isDarkMode ? Colors.black87 : Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              GetBuilder<AddFoodController>(
                builder: (controller) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: double.infinity,
                                height: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${addFoodController.menuList!.length} yemək seçildi",
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${addFoodController.definePrice()} AZN",
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      if (addFoodController
                                          .menuList!.isNotEmpty) {
                                        addFoodController.addFood(
                                            widget.tableNumber,
                                            orderController.order!.id,
                                            widget.restaurantId,
                                            profilePageController.meSocial!
                                                .data()!["name"]);
                                        Get.back();
                                        Get.snackbar("Yemək əlavə olundu", '');
                                      }
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Tamamla",
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        panel: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Get.isDarkMode ? Colors.black45 : Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GetBuilder<AddFoodController>(
                    builder: (controller) {
                      if (controller.menuList!.isNotEmpty) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                              width: 5,
                            );
                          },
                          itemCount: addFoodController.menuList!.length,
                          itemBuilder: (context, index2) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      // Get.to(
                                      //     () => FoodDetail(
                                      //           menu: addFoodController.menuList[index],
                                      //         ),
                                      //     preventDuplicates: false);
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
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    height: 90,
                                                    width: 90,
                                                    child: menuPageController
                                                        .defineFoodImage(
                                                            addFoodController
                                                                        .menuList![
                                                                    index2]
                                                                ["foodImage"],
                                                            addFoodController
                                                                        .menuList![
                                                                    index2]
                                                                ["categoryId"]),
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
                                                        addFoodController
                                                                .menuList![
                                                            index2]["name"],
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                      ),
                                                      Text(
                                                        "${addFoodController.menuList![index2]["price"]} Azn",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        defineTextFieldColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              defineTextFieldColor(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: InkWell(
                                                            onTap: () {
                                                              addFoodController
                                                                  .increaseAmount(
                                                                      {}, false,
                                                                      food: addFoodController
                                                                              .menuList![
                                                                          index2]);
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Icon(
                                                                Icons.add,
                                                                size: 40),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 25,
                                                        child: Center(
                                                          child: Text(
                                                            addFoodController
                                                                .menuList![
                                                                    index2]
                                                                    ["amount"]
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    color:
                                                                        defineWhiteBlack(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              defineTextFieldColor(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            onTap: () {
                                                              addFoodController
                                                                  .decreaseAmount(
                                                                      addFoodController
                                                                              .menuList![
                                                                          index2]);
                                                            },
                                                            child: addFoodController
                                                                            .menuList![index2]
                                                                        [
                                                                        "amount"] ==
                                                                    1
                                                                ? Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            20),
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .remove,
                                                                    size: 40),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                      } else {
                        return Center(
                          child: Text(
                            "Seçili yemək yoxdur",
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              color: context.iconColor,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: GetBuilder<MenuPageController>(
                        builder: (controller) {
                          if (controller.menus.isNotEmpty) {
                            // if (controller.state) {
                            //   menuPageController.tabController = TabController(
                            //       length: menuPageController.menus.length,
                            //       vsync: this);
                            //   menuPageController.tabController?.animateTo(0);
                            //   controller.state = false;
                            // }
                            //  print(menuPageController.tabController!.index);
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
                                      //controller: menuPageController.tabController,
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
                                          GoogleFonts.quicksand(
                                              color: Colors.black87),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: TabBarView(
                                          // controller:
                                          //     menuPageController.tabController,
                                          children: List.generate(
                                            controller.menus.values.length,
                                            (index) => Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return SizedBox(
                                                          height: 5,
                                                          width: 5,
                                                        );
                                                      },
                                                      itemCount: controller
                                                          .menus.entries
                                                          .elementAt(index)
                                                          .value
                                                          .length,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              gradient:
                                                                  LinearGradient(
                                                                colors:
                                                                    defineMainCardGradient(),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Material(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                onTap: () {
                                                                  // Get.to(
                                                                  //     () =>
                                                                  //         FoodDetail(
                                                                  //           menu: controller
                                                                  //               .menus
                                                                  //               .entries
                                                                  //               .elementAt(
                                                                  //                   index)
                                                                  //               .value[index2],
                                                                  //         ),
                                                                  //     preventDuplicates:
                                                                  //         false);
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              child: SizedBox(
                                                                                height: 90,
                                                                                width: 90,
                                                                                child: controller.defineFoodImage(controller.menus.entries.elementAt(index).value[index2].data()["foodImage"], controller.menus.entries.elementAt(index).value[index2].data()["categoryId"]),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Flexible(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    controller.menus.entries.elementAt(index).value[index2].data()["name"],
                                                                                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${controller.menus.entries.elementAt(index).value[index2].data()["price"]} Azn",
                                                                                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      GetBuilder<
                                                                          AddFoodController>(
                                                                        builder:
                                                                            (controller2) {
                                                                          return IntrinsicHeight(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  height: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color: defineTextFieldColor(),
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        decoration: BoxDecoration(color: defineTextFieldColor(), borderRadius: BorderRadius.circular(10)),
                                                                                        child: Material(
                                                                                          color: Colors.transparent,
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              if (addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty) {
                                                                                                addFoodController.increaseAmount(controller.menus.entries.elementAt(index).value[index2].data(), false, food: addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first);
                                                                                              } else {
                                                                                                addFoodController.increaseAmount(
                                                                                                  controller.menus.entries.elementAt(index).value[index2].data(),
                                                                                                  true,
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            child: Icon(Icons.add, size: 40),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 25,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty ? addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first["amount"].toString() : "0",
                                                                                            style: GoogleFonts.quicksand(color: defineWhiteBlack(), fontWeight: FontWeight.bold, fontSize: 18),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        decoration: BoxDecoration(color: defineTextFieldColor(), borderRadius: BorderRadius.circular(10)),
                                                                                        child: Material(
                                                                                          color: Colors.transparent,
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: InkWell(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            onTap: () {
                                                                                              addFoodController.decreaseAmount(addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first);
                                                                                            },
                                                                                            child: addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty
                                                                                                ? addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first["amount"] == 1
                                                                                                    ? Padding(
                                                                                                        padding: EdgeInsets.all(10),
                                                                                                        child: Icon(Icons.delete, size: 20),
                                                                                                      )
                                                                                                    : Icon(Icons.remove, size: 40)
                                                                                                : Icon(
                                                                                                    Icons.circle,
                                                                                                    size: 40,
                                                                                                    color: Colors.transparent,
                                                                                                  ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
