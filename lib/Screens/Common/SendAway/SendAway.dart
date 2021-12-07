import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmood/Controllers/MenuPageController.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/SendAwayController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Common/SendAway/SendAwayConfirmDialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../DarkModeController.dart';

class SendAway extends StatefulWidget {
  final bool fromTable;
  final String restaurantId;
  final int tableNumber;
  final String orderId;
  final String toUserId;
  const SendAway(
      {Key? key,
      required this.fromTable,
      required this.restaurantId,
      required this.tableNumber,
      required this.orderId,
      required this.toUserId})
      : super(key: key);

  @override
  _SendAwayState createState() => _SendAwayState();
}

class _SendAwayState extends State<SendAway> {
  @override
  void initState() {
    print(widget.restaurantId);
    if (widget.fromTable) {
      menuPageController.getMenu(widget.restaurantId);
    }

    super.initState();
  }

  SendAwayController sendAwayController = Get.put(SendAwayController());
  MenuPageController menuPageController = Get.put(MenuPageController());
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (widget.fromTable) {
      print("ok1");
      return Scaffold(
        body: Container(
          child: SlidingUpPanel(
            backdropTapClosesPanel: true,
            backdropEnabled: true,
            minHeight: 120,
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GetBuilder<SendAwayController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.menuList!.length.toString()} yemək seçildi",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          "${controller.definePrice()} AZN",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
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
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        print(widget.tableNumber);
                                        print(orderController.order!.id);

                                        if (sendAwayController.menuList !=
                                                null &&
                                            sendAwayController
                                                .menuList!.isNotEmpty) {
                                          Get.dialog(SendAwayConfirmDialog(
                                            orderId: widget.orderId,
                                            toUserId: widget.toUserId,
                                            tableNumber: widget.tableNumber,
                                          ));
                                        } else {
                                          Get.snackbar("Yemək seçin",
                                              "Ismarlamaq üçün menyudan ən az bir yemək seçin");
                                        }

                                        // if (controller.menuList!.isNotEmpty) {
                                        //   controller.addFood(
                                        //       widget.tableNumber,
                                        //       orderController.order!.id,
                                        //       widget.restaurantId);
                                        // }
                                      },
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            "İsmarla",
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GetBuilder<SendAwayController>(
                        builder: (controller) {
                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 5,
                                width: 5,
                              );
                            },
                            itemCount: controller.menuList!.length,
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
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 90,
                                                  width: 90,
                                                  child: controller.menuList![
                                                                      index2][
                                                                  "foodImage"] !=
                                                              null &&
                                                          controller
                                                              .menuList![index2]
                                                                  ["foodImage"]
                                                              .isNotEmpty
                                                      ? Image.network(controller
                                                              .menuList![index2]
                                                          ["foodImage"])
                                                      : Image.network(
                                                          firebaseRemoteConfigController
                                                                  .menuCategory
                                                                  .entries
                                                                  .where(
                                                                    (element) =>
                                                                        element.value[
                                                                            "categoryId"] ==
                                                                        controller.menuList![index2]
                                                                            [
                                                                            "categoryId"],
                                                                  )
                                                                  .first
                                                                  .value[
                                                              "categoryPhoto"],
                                                        ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .menuList![index2]
                                                          ["name"],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                    ),
                                                    Text(
                                                      "${controller.menuList![index2]["price"].toString()} Azn",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                    ),
                                                  ],
                                                )
                                              ],
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
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: InkWell(
                                                              onTap: () {
                                                                controller.increaseAmount(
                                                                    {}, false,
                                                                    food: controller
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
                                                              controller
                                                                  .menuList![
                                                                      index2]
                                                                      ["amount"]
                                                                  .toString(),
                                                              style: GoogleFonts.quicksand(
                                                                  color:
                                                                      defineWhiteBlack(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
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
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              onTap: () {
                                                                controller.decreaseAmount(
                                                                    controller
                                                                            .menuList![
                                                                        index2]);
                                                              },
                                                              child: controller.menuList![
                                                                              index2]
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Icon(Icons.arrow_back_ios_new),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      //color: Colors.grey[200]!.withOpacity(0.8),
                                      gradient: Get.isDarkMode
                                          ? LinearGradient(colors: [
                                              Colors.black54,
                                              // Color(Colors
                                              //     .grey[800]!.value)
                                              Colors.black45
                                            ])
                                          : LinearGradient(colors: [
                                              Color(Colors.blueGrey[50]!.value)
                                                  .withOpacity(0.8),
                                              Color(0xFFe4eef0)
                                                  .withOpacity(0.8),
                                            ]),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Axtar",
                                              contentPadding: EdgeInsets.all(5),
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
                        ),
                        SizedBox(
                          height: 5,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: TabBarView(
                                              // controller:
                                              //     menuPageController.tabController,
                                              children: List.generate(
                                                controller.menus.values.length,
                                                (index) => Container(
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
                                                                horizontal: 10),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
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
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              90,
                                                                          width:
                                                                              90,
                                                                          child: controller.menus.entries.elementAt(index).value[index2].data()["foodImage"] != null && controller.menus.entries.elementAt(index).value[index2].data()["foodImage"].isNotEmpty
                                                                              ? Image.network(controller.menus.entries.elementAt(index).value[index2].data()["foodImage"])
                                                                              : Image.network(firebaseRemoteConfigController.menuCategory.entries
                                                                                  .where(
                                                                                    (element) => element.value["categoryId"] == controller.menus.entries.elementAt(index).value[index2].data()["categoryId"],
                                                                                  )
                                                                                  .first
                                                                                  .value["categoryPhoto"]),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              controller.menus.entries.elementAt(index).value[index2].data()["name"],
                                                                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 18),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${controller.menus.entries.elementAt(index).value[index2].data()["price"].toString()} Azn",
                                                                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    GetBuilder<
                                                                        SendAwayController>(
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
                                                                                            if (sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty) {
                                                                                              sendAwayController.increaseAmount(controller.menus.entries.elementAt(index).value[index2].data(), false, food: sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first);
                                                                                            } else {
                                                                                              sendAwayController.increaseAmount(
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
                                                                                          sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty ? sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first["amount"].toString() : "0",
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
                                                                                            sendAwayController.decreaseAmount(sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first);
                                                                                          },
                                                                                          child: sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty
                                                                                              ? sendAwayController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).first["amount"] == 1
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
                                                                              // Container(
                                                                              //   decoration:
                                                                              //       BoxDecoration(
                                                                              //     color: Colors.grey[200],
                                                                              //     gradient: Get.isDarkMode
                                                                              //         ? LinearGradient(colors: [
                                                                              //             Colors.black,
                                                                              //             Color(Colors.grey[900]!.value),
                                                                              //           ])
                                                                              //         : LinearGradient(
                                                                              //             colors: [
                                                                              //               Color(Colors.grey[50]!.value),
                                                                              //               Color(Colors.grey[100]!.value),
                                                                              //             ],
                                                                              //           ),
                                                                              //     borderRadius: BorderRadius.circular(10),
                                                                              //   ),
                                                                              //   child:
                                                                              //       Material(
                                                                              //     borderRadius: BorderRadius.circular(10),
                                                                              //     color: Colors.transparent,
                                                                              //     child: InkWell(
                                                                              //       borderRadius: BorderRadius.circular(10),
                                                                              //       onTap: () {
                                                                              //         if (addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isEmpty) {
                                                                              //           addFoodController.addFoodtoList(controller.menus.entries.elementAt(index).value[index2].data());
                                                                              //         } else {
                                                                              //           addFoodController.deleteFoodfromList(controller.menus.entries.elementAt(index).value[index2].data());
                                                                              //         }
                                                                              //       },
                                                                              //       child: Padding(
                                                                              //         padding: const EdgeInsets.all(8.0),
                                                                              //         child: !addFoodController.menuList!.where((element) => element["foodId"] == controller.menus.entries.elementAt(index).value[index2].data()["foodId"]).isNotEmpty
                                                                              //             ? Icon(
                                                                              //                 Icons.add,
                                                                              //                 color: defineWhiteBlack(),
                                                                              //               )
                                                                              //             : Icon(
                                                                              //                 Icons.check,
                                                                              //                 color: defineWhiteBlack(),
                                                                              //               ),
                                                                              //       ),
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
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
                                            ),
                                          ),
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
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.topLeft,
              children: [
                //  Text("Restoran secin"),
                GetBuilder<SendAwayController>(builder: (controller) {
                  if (controller.selectedRestaurant.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Text(
                            "İsmarladığınız restoran:",
                            style: GoogleFonts.quicksand(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 80,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  child: Image.network(
                                    controller
                                        .selectedRestaurant["restaurantPhoto"],
                                    height: 80,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  controller
                                      .selectedRestaurant["restaurantName"],
                                  style: GoogleFonts.quicksand(),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "İsmarladığınız məbləğ:",
                            style: GoogleFonts.quicksand(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              inputFormatters: [],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "AZN - lə",
                                hintStyle: GoogleFonts.quicksand(),
                                contentPadding: EdgeInsets.only(left: 5),
                              ),
                            ),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "İsmarladığının hesabı indi ödəmə üsulunu seçsəniz hesabı indi onlayn kart vasitəsi ilə ödəyəcəksiniz. Qarşı tərəf İsmarlamanı qəbul etdikdən sonra ismarla kodunu istifadə edərək həmin restoranda ödədiyiniz məbləğdə sifariş verə bilər vəya sifarişi tamamlaya bilər. Qarşı tərəf İsmarlamanı qəbul etmədikdə ödədiyiniz məbləğ yenidən sizin hesabınıza göndərilir")
                            ]),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: context.theme.primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("İndi ödə"),
                            ),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "Hesabı daha sonra ödəmə üsulunu seçsəniz restorana getdikdən sonra hesabı digər ödəmə üsulları ilə ödəyəcəksiniz")
                            ]),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: context.theme.primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Daha sonra ödə"),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                FloatingSearchBar(
                  backgroundColor: context.theme.primaryColor,
                  backdropColor: context.theme.primaryColor,
                  isScrollControlled: true,
                  padding: EdgeInsets.zero,
                  hint: "Restoran Axtarın",
                  onQueryChanged: (query) {
                    if (query.isEmpty) {
                      sendAwayController.setSearchedState(false);
                    } else {
                      sendAwayController.searchDelayFunction(query);
                    }
                  },
                  builder: (context, transition) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GetBuilder<SendAwayController>(
                        builder: (controller) {
                          if (controller.isSearched) {
                            if (controller.searchResults != null) {
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    controller.searchResults!.hits.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: context.theme.backgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          Get.to(
                                            () => RestaurantPage(
                                              restaurantId: controller
                                                  .searchResults!
                                                  .hits[index]
                                                  .data["restaurantId"],
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5),
                                                    ),
                                                    child: Image.network(
                                                      controller.searchResults!
                                                              .hits[index].data[
                                                          "restaurantImage"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    controller
                                                        .searchResults!
                                                        .hits[index]
                                                        .data["restaurantName"],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
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
                              return Text("Netice tapilmadi");
                            }
                          } else {
                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.firstRestaurants.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.backgroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Get.to(
                                          () => RestaurantPage(
                                            restaurantId: controller
                                                .firstRestaurants[index]
                                                .data()!["restaurantId"],
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(5),
                                                  ),
                                                  child: Image.network(
                                                    controller.firstRestaurants[
                                                                index]
                                                            .data()![
                                                        "restaurantImage"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        controller
                                                                .firstRestaurants[
                                                                    index]
                                                                .data()![
                                                            "restaurantName"],
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Container(
                                                        height: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            onTap: () {
                                                              sendAwayController.setSelectedRestaurant(
                                                                  controller
                                                                          .firstRestaurants[
                                                                              index]
                                                                          .data()![
                                                                      "restaurantId"],
                                                                  controller
                                                                          .firstRestaurants[
                                                                              index]
                                                                          .data()![
                                                                      "restaurantName"],
                                                                  controller
                                                                      .firstRestaurants[
                                                                          index]
                                                                      .data()!["restaurantImage"]);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      8),
                                                              child: Text(
                                                                "Seç",
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                        color: Colors
                                                                            .white),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
