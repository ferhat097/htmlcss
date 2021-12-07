import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/SendAwayMenuController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../DarkModeController.dart';

class SendAwayMenuBottomSheet extends StatefulWidget {
  final String sendAwayId;
  const SendAwayMenuBottomSheet({Key? key, required this.sendAwayId})
      : super(key: key);

  @override
  _SendAwayMenuBottomSheetState createState() =>
      _SendAwayMenuBottomSheetState();
}

class _SendAwayMenuBottomSheetState extends State<SendAwayMenuBottomSheet> {
  SendAwayMenuController sendAwayMenuController =
      Get.put(SendAwayMenuController());
  OrderController orderController = Get.find();
  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();
  @override
  void dispose() {
    Get.delete<SendAwayMenuController>();
    super.dispose();
  }

  @override
  void initState() {
    sendAwayMenuController.getSendAwayMenu(
        orderController.order!.id, widget.sendAwayId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GetBuilder<SendAwayMenuController>(
          builder: (controller) {
            return Column(
              children: [
                Text(
                  "İsmarlanan menyu",
                  style: GoogleFonts.quicksand(fontSize: 20),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.sendAwayFoods.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: controller.sendAwayFoods[index]
                                                              .data()![
                                                          "foodImage"] !=
                                                      null &&
                                                  controller
                                                      .sendAwayFoods[index]
                                                      .data()!["foodImage"]
                                                      .isNotEmpty
                                              ? Image.network(
                                                  controller
                                                      .sendAwayFoods[index]
                                                      .data()!["foodImage"],
                                                  scale: 6,
                                                )
                                              : Image.network(
                                                  firebaseRemoteConfigController
                                                      .menuCategory.entries
                                                      .where((element) =>
                                                          element.value[
                                                              "categoryId"] ==
                                                          controller
                                                              .sendAwayFoods[index]
                                                              .data()!["categoryId"])
                                                      .first
                                                      .value["categoryPhoto"]),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.sendAwayFoods[index]
                                                  .data()!["foodName"],
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${controller.sendAwayFoods[index].data()!["price"].toString()} Azn",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  " - ${controller.sendAwayFoods[index].data()!["amount"].toString()}X",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
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
              ],
            );
          },
        ),
      ),
    );
  }
}
