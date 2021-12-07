import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/CouponsController.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/CompleteOrder/CompletewithCouponConfirmDialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CompletewithCouponBottomSheet extends StatefulWidget {
  final String restaurantId;
  const CompletewithCouponBottomSheet({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _CompletewithCouponBottomSheetState createState() =>
      _CompletewithCouponBottomSheetState();
}

class _CompletewithCouponBottomSheetState
    extends State<CompletewithCouponBottomSheet> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ok");
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<CouponsController>(
        builder: (controller) {
          if (controller.coupons.isNotEmpty) {
            if (controller.coupons
                .where((element) => element
                    .data()!["restaurants"]
                    .contains(widget.restaurantId))
                .isNotEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: ListView.builder(
                  itemCount: controller.coupons
                      .where((element) => element
                          .data()!["restaurants"]
                          .contains(widget.restaurantId))
                      .length,
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
                                  controller.coupons
                                      .where((element) => element
                                          .data()!["restaurants"]
                                          .contains(widget.restaurantId))
                                      .elementAt(index)
                                      .data()!["couponName"],
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
                                if (controller.coupons
                                    .where((element) => element
                                        .data()!["restaurants"]
                                        .contains(widget.restaurantId))
                                    .elementAt(index)
                                    .data()!["unLimited"])
                                  Text(
                                    "Limitsiz",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
                                  )
                                else
                                  Text(
                                    "${controller.coupons.where((element) => element.data()!["restaurants"].contains(widget.restaurantId)).elementAt(index).data()!["couponLimit"].toString()} AZN",
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
                                if (controller.coupons
                                    .where((element) => element
                                        .data()!["restaurants"]
                                        .contains(widget.restaurantId))
                                    .elementAt(index)
                                    .data()!["unExpired"])
                                  Text(
                                    "müddətsiz",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
                                  )
                                else
                                  Text(
                                    "${controller.coupons.where((element) => element.data()!["restaurants"].contains(widget.restaurantId)).elementAt(index).data()!["expiredTime"].toDate().year.toString()},  ${DateFormat('MMM', "az_AZ").format(controller.coupons.where((element) => element.data()!["restaurants"].contains(widget.restaurantId)).elementAt(index).data()!["expiredTime"].toDate())},  ${controller.coupons.where((element) => element.data()!["restaurants"].contains(widget.restaurantId)).elementAt(index).data()!["expiredTime"].toDate().day.toString()}",
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
                                if (!controller.coupons
                                    .where((element) => element
                                        .data()!["restaurants"]
                                        .contains(widget.restaurantId))
                                    .elementAt(index)
                                    .data()!["allRestaurant"])
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: context.theme.canvasColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        "Bu restoranda keçərlidir",
                                        style: GoogleFonts.quicksand(),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: double.infinity,
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      Get.dialog(
                                          CompletewithCouponConfirmDialog(
                                        couponId: controller.coupons
                                            .where((element) => element
                                                .data()!["restaurants"]
                                                .contains(widget.restaurantId))
                                            .elementAt(index)
                                            .id,
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "İstifadə et",
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox(
                child: Center(
                  child: Text(
                    "bu restoranda kecerli kuponunuz yoxdur",
                    style: GoogleFonts.quicksand(fontSize: 18),
                  ),
                ),
              );
            }
          } else {
            return SizedBox(
              child: Center(
                child: Text(
                  "Sizin kuponunuz yoxdur",
                  style: GoogleFonts.quicksand(fontSize: 18),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
