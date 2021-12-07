import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/CouponsController.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletewithCouponConfirmDialog extends StatefulWidget {
  final String couponId;
  const CompletewithCouponConfirmDialog({Key? key, required this.couponId})
      : super(key: key);

  @override
  _CompletewithCouponConfirmDialogState createState() =>
      _CompletewithCouponConfirmDialogState();
}

class _CompletewithCouponConfirmDialogState
    extends State<CompletewithCouponConfirmDialog> {
  CouponsController couponsController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.order != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.theme.canvasColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  constraints: BoxConstraints(
                    maxHeight: 200,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ödəyəcəyiniz məbləğ:",
                                      style:
                                          GoogleFonts.quicksand(fontSize: 16),
                                    ),
                                    Text(
                                      "${controller.order!.data()!["totalAmount"].toString()} AZN",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Endirim Kuponunun dəyəri:",
                                      style:
                                          GoogleFonts.quicksand(fontSize: 16),
                                    ),
                                    Text(
                                      "${couponsController.coupons.where((element) => element.id == widget.couponId).first.data()!["couponLimit"].toString()} AZN",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (couponsController.coupons
                                        .where((element) =>
                                            element.id == widget.couponId)
                                        .first
                                        .data()!["couponLimit"] <
                                    controller.order!.data()!["totalAmount"])
                                  Container(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "Hesabınız endirim kuponunun limitindən çoxdur. Kuponu istifadə etdikdən sonra əlavə",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color),
                                        ),
                                        TextSpan(
                                          text:
                                              " ${((controller.order!.data()!["totalAmount"] - couponsController.coupons.where((element) => element.id == widget.couponId).first.data()!["couponLimit"]).toString())} AZN ",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "hesabı digər ödəmə üsülları ilə ödəməlisiniz",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color),
                                        ),
                                      ]),
                                    ),
                                  )
                                else
                                  Container(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "Ödəyəcəyiniz hesab endirim kuponunun limitindən azdır. Hesabı kuponla ödədikdən sonra əlavə qalan ",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color),
                                        ),
                                        TextSpan(
                                          text:
                                              " ${((couponsController.coupons.where((element) => element.id == widget.couponId).first.data()!["couponLimit"] - controller.order!.data()!["totalAmount"]).toString())} AZN ",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: "pul silinəcək",
                                          style: GoogleFonts.quicksand(
                                              color: context.theme.textTheme
                                                  .bodyText1!.color),
                                        ),
                                      ]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  Get.back();
                                  Get.back();
                                  orderController.activeProgress(true);
                                  String result = await orderController
                                      .payWithCoupon(widget.couponId);
                                      
                                  if (result == "OrderCompleted") {
                                    Get.back(closeOverlays: true);
                                  } else if (result == "CouponUsed") {
                                    Get.snackbar(
                                        "Endirim kuponu istifadə edildi",
                                        "Hasbın qalan hissəsini digər ödəmə üsulları ilə ödəyə bilərsiniz");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Kuponu istifadə et (${couponsController.coupons.where((element) => element.id == widget.couponId).first.data()!["couponLimit"]} AZN)",
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
