import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/CompleteOrder/CompleteOrderWithFoodMoodAccountBottom.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/CompleteOrder/CompletewitCouponBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteOrderBottomSheet extends StatefulWidget {
  const CompleteOrderBottomSheet({Key? key}) : super(key: key);

  @override
  _CompleteOrderBottomSheetState createState() =>
      _CompleteOrderBottomSheetState();
}

class _CompleteOrderBottomSheetState extends State<CompleteOrderBottomSheet> {
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.order != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Sifarişi bitir",
                    style: GoogleFonts.quicksand(fontSize: 18),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ümumi ödəniləcək məbləğ:",
                          style: GoogleFonts.quicksand(fontSize: 18),
                        ),
                        Text(
                          "${controller.order!.data()!["totalAmount"]} AZN",
                          style: GoogleFonts.quicksand(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          orderController.activeProgress(true);
                        String result =  await orderController.payWithCash();
                        },
                        child: Center(
                          child: Text(
                            "Nəğd ödə",
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {},
                        child: Center(
                          child: Text(
                            "Onlayn ödə",
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          height: 40,
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
                                Get.bottomSheet(
                                  CompletewithCouponBottomSheet(
                                    restaurantId: controller.order!
                                        .data()!["restaurantId"],
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: context.theme.canvasColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Kupon",
                                  style: GoogleFonts.quicksand(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  "FoodMood Credit",
                                  style: GoogleFonts.quicksand(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Get.bottomSheet(
                            CompleteOrderWithFoodMoodAccount(),
                            isScrollControlled: true,
                            backgroundColor: context.theme.canvasColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "FoodMood hesabımdan",
                            style: GoogleFonts.quicksand(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "İsmarla kodu ilə",
                        style: GoogleFonts.quicksand(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text("Hesab artıq ödənilib"),
            );
          }
        },
      ),
    );
  }
}
