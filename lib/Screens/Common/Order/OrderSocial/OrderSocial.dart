import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/TableSendAwaysController.dart';
import 'package:foodmood/Controllers/TableSocialController.dart';
import 'package:foodmood/Screens/Common/Order/OrderSocial/TableSendAways.dart';
import 'package:foodmood/Screens/Common/Order/OrderSocial/UserSocialFeaturesBottomSheet.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../DarkModeController.dart';

class OrderSocial extends StatefulWidget {
  final String restaurantId;
  final String orderId;
  final int tableNumber;
  const OrderSocial(
      {Key? key,
      required this.restaurantId,
      required this.orderId,
      required this.tableNumber})
      : super(key: key);

  @override
  _OrderSocialState createState() => _OrderSocialState();
}

class _OrderSocialState extends State<OrderSocial> {
  OrderController orderController = Get.find();
  TableSocialController tableSocialController =
      Get.put(TableSocialController());
  TableSendAwaysController tableSendAwaysController =
      Get.put(TableSendAwaysController());
  @override
  void initState() {
    tableSocialController.listenSocialUser(widget.restaurantId);
    tableSocialController.meSocialListen(widget.restaurantId);
    tableSendAwaysController.listenTableSendAways(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        automaticallyImplyLeading: false,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[900] : Colors.white12,
                borderRadius: BorderRadius.circular(50),
              ),
              height: 45,
              width: 45,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    orderController.orderPageController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/table.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "FoodMoodSocial",
          style: GoogleFonts.quicksand(color: defineWhiteBlack()),
        ),
      ),
      body: GetBuilder<TableSocialController>(builder: (controller) {
        if (controller.me != null) {
          return Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "FoodMoodSocial",
                        style: GoogleFonts.quicksand(fontSize: 16),
                      ),
                      Switch.adaptive(
                        value: controller.tableSocial,
                        onChanged: (value) async {
                          await tableSocialController.changeTableSocial(
                            value,
                            widget.restaurantId,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              GetBuilder<TableSendAwaysController>(
                builder: (controller) {
                  if (controller.sendAways.isNotEmpty) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: controller.sendAways
                                .where((element) =>
                                    element.data()!["accepted"] == false)
                                .isNotEmpty
                            ? Colors.pink
                            : context.theme.backgroundColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              TableSendAways(),
                              isScrollControlled: true,
                              backgroundColor: context.theme.primaryColor,
                              shape: RoundedRectangleBorder(
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
                                Text(
                                  tableSocialController.me!
                                          .data()!["tableSocial"]
                                      ? controller.sendAways
                                              .where((element) =>
                                                  element.data()!["accepted"] ==
                                                  false)
                                              .isNotEmpty
                                          ? "Yeni ismarlama var"
                                          : "İsmarlamalar"
                                      : "Yeni ismarlamalara bağlıdır",
                                  style: GoogleFonts.quicksand(
                                      color: controller.sendAways
                                              .where((element) =>
                                                  element.data()!["accepted"] ==
                                                  false)
                                              .isNotEmpty
                                          ? Colors.white
                                          : context.theme.textTheme.bodyText1!
                                              .color),
                                ),
                                tableSocialController.me!.data()!["tableSocial"]
                                    ? Image.asset(
                                        "assets/sendaway.png",
                                        scale: 16,
                                      )
                                    : Icon(Icons.cancel,
                                        size: 30, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              if (controller.me!.data()!["tableSocial"])
                Expanded(
                  child: GetBuilder<TableSocialController>(
                    builder: (controller) {
                      if (controller.tableSocials.isNotEmpty) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: controller.tableSocials.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return Container(
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: defineTextFieldColor(),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      print(controller.tableSocials[index].id);
                                      Get.bottomSheet(
                                        UserSocialFeaturesBottomSheet(
                                          userId:
                                              controller.tableSocials[index].id,
                                          orderId: controller
                                              .tableSocials[index]
                                              .data()!["orderId"],
                                          tableNumber: controller
                                              .tableSocials[index]
                                              .data()!["tableNumber"],
                                        ),
                                        isScrollControlled: true,
                                        backgroundColor:
                                            context.theme.canvasColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      );
                                      // Get.to(
                                      //   () => UserProfile(
                                      //     userId:
                                      //         controller.tableSocials[index].id,
                                      //   ),
                                      // );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
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
                                                    controller
                                                        .tableSocials[index]
                                                        .data()!["userPhoto"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  top: 10,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                        color: Colors.red),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                        "best",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            // color: defineTextFieldColor(),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Masa ${controller.tableSocials[index].data()!["tableNumber"]}",
                                                      style: GoogleFonts.quicksand(
                                                          color:
                                                              defineWhiteBlack(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .tableSocials[index]
                                                          .data()!["userName"],
                                                      style: GoogleFonts.quicksand(
                                                          color:
                                                              defineWhiteBlack(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                        );
                      } else {
                        return Center(
                          child: Text("Istifadeci yoxdur"),
                        );
                      }
                    },
                  ),
                )
            ],
          );
        } else
          return SizedBox();
      }),
    );
  }
}
