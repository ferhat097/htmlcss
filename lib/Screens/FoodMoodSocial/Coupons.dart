import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/CouponsController.dart';
import 'package:foodmood/Screens/FoodMoodSocial/ViewRestaurantsBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  CouponsController couponsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Endirim Kuponlarım",
          style: GoogleFonts.quicksand(),
        ),
      ),
      body: GetBuilder<CouponsController>(
        builder: (controller) {
          if (controller.coupons.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 5,
                  );
                },
                itemCount: controller.coupons.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/couponPhoto.png",
                                scale: 12,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.coupons[index].data()!["couponName"],
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kupon Limiti:",
                                style: GoogleFonts.quicksand(),
                              ),
                              if (controller.coupons[index]
                                  .data()!["unLimited"])
                                Text(
                                  "Limitsiz",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                )
                              else
                                Text(
                                  "${controller.coupons[index].data()!["couponLimit"].toString()} AZN",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bitmə tarixi:",
                                style: GoogleFonts.quicksand(),
                              ),
                              if (controller.coupons[index]
                                  .data()!["unExpired"])
                                Text(
                                  "müddətsiz",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                )
                              else
                                Text(
                                  "${controller.coupons[index].data()!["expiredTime"].toDate().year.toString()},  ${DateFormat('MMM', "az_AZ").format(controller.coupons[index].data()!["expiredTime"].toDate())},  ${controller.coupons[index].data()!["expiredTime"].toDate().day.toString()}",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Keçərli restoranlar:",
                                style: GoogleFonts.quicksand(),
                              ),
                              if (!controller.coupons[index]
                                  .data()!["allRestaurant"])
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: context.theme.canvasColor),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Get.bottomSheet(
                                            ViewRestaurantBottomSheet(
                                              couponId:
                                                  controller.coupons[index].id,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            backgroundColor:
                                                context.theme.canvasColor);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "Restoranları gör",
                                          style: GoogleFonts.quicksand(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  child: Text(
                                    "Bütün restoranlarda",
                                    style: GoogleFonts.quicksand(),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text(
                  "Kuponlarınız yoxdur",
                  style: GoogleFonts.quicksand(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
