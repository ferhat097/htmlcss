import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MenuPageController.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/CompleteOrder/CompleteOrderBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../DarkModeController.dart';
import 'AddFood.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;
  final int tableNumber;
  final String restaurantId;
  const OrderDetail(
      {Key? key,
      required this.orderId,
      required this.tableNumber,
      required this.restaurantId})
      : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          GetBuilder<OrderController>(
            builder: (controller) {
              if (controller.foods.isNotEmpty) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: controller.foods.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
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
                                  //   () => FoodDetail(
                                  //     menu: controller
                                  //         .menus.entries
                                  //         .elementAt(index)
                                  //         .value[index2],
                                  //   ),
                                  // );
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
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 90,
                                                width: 90,
                                                child:
                                                    controller.defineFoodImage(
                                                        controller.foods[index]
                                                                .data()![
                                                            "foodImage"],
                                                        controller.foods[index]
                                                                .data()![
                                                            "categoryId"]),
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
                                                    controller.foods[index]
                                                        .data()!["foodName"],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${controller.foods[index].data()!["price"].toString()} Azn",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                      ),
                                                      Text(
                                                        " - ${controller.foods[index].data()!["amount"].toString()}X",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      GetBuilder<OrderController>(
                                        id: "endTime",
                                        builder: (controller) {
                                          if (controller.foods[index]
                                              .data()!["status"]) {
                                            return Container(
                                              child:
                                                  controller.defineFoodStatus(
                                                controller.foods[index]
                                                    .data()!["status"],
                                                controller.foods[index].data()![
                                                    "orderedStartTime"],
                                                widget.orderId,
                                                controller.foods[index].id,
                                                widget.tableNumber,
                                                orderComplete: controller
                                                        .foods[index]
                                                        .data()![
                                                    "orderedCompleteTime"],
                                              ),
                                            );
                                          } else {
                                            return IntrinsicHeight(
                                              child: Container(
                                                child:
                                                    controller.defineFoodStatus(
                                                  controller.foods[index]
                                                      .data()!["status"],
                                                  controller.foods[index]
                                                          .data()![
                                                      "orderedStartTime"],
                                                  widget.orderId,
                                                  controller.foods[index].id,
                                                  widget.tableNumber,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
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
                );
              } else {
                return Expanded(
                  child: Center(
                    child: SizedBox(
                      child: Text(
                        "Hərşey hazırdır \n Sifarişə başla",
                        style: GoogleFonts.quicksand(fontSize: 22),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          GetBuilder<OrderController>(
            builder: (controller) {
              if (controller.order != null) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: defineTextFieldColor()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: defineTextFieldColor(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ödənilməli məbləğ: ",
                                    style: GoogleFonts.quicksand(fontSize: 22),
                                  ),
                                  Text(
                                    "${controller.order!.data()!["totalAmount"]} AZN",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (controller.order!.data()!["isDeposit"])
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: defineTextFieldColor(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Deposit: ",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 22),
                                        ),
                                        Text(
                                          "${controller.order!.data()!["deposit"]} AZN",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: double.infinity,
                                  child: Center(
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          Get.bottomSheet(
                                              AddFood(
                                                tableNumber: widget.tableNumber,
                                                orderId: widget.orderId,
                                                restaurantId:
                                                    widget.restaurantId,
                                              ),
                                              isScrollControlled: true);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Center(
                                              child: Text(
                                                "Yemək əlavə et",
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Opacity(
                                  opacity: !(controller.order!
                                              .data()!["amount"] >=
                                          controller.order!.data()!["deposit"])
                                      ? 0.5
                                      : 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: double.infinity,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () async {
                                          if (controller.order!
                                              .data()!["isDeposit"]) {
                                            if (controller.order!
                                                    .data()!["amount"] >=
                                                controller.order!
                                                    .data()!["deposit"]) {
                                              Get.bottomSheet(
                                                CompleteOrderBottomSheet(),
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    context.theme.canvasColor,
                                                shape: RoundedRectangleBorder(
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
                                                  "Hesabınız depositdən çox olmalıdır",
                                                  "");
                                            }
                                          } else {
                                            Get.bottomSheet(
                                              CompleteOrderBottomSheet(),
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
                                          }

                                          // await orderController.completeOrder(
                                          //     widget.restaurantId,
                                          //     widget.tableNumber,
                                          //     widget.orderId);
                                          // Get.delete<OrderController>();
                                          // Get.back();
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              "Bitir",
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
