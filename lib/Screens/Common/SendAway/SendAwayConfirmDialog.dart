import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/SendAwayController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SendAwayConfirmDialog extends StatefulWidget {
  final String orderId;
  final int tableNumber;
  final String toUserId;
  const SendAwayConfirmDialog(
      {Key? key,
      required this.orderId,
      required this.tableNumber,
      required this.toUserId})
      : super(key: key);

  @override
  _SendAwayConfirmDialogState createState() => _SendAwayConfirmDialogState();
}

class _SendAwayConfirmDialogState extends State<SendAwayConfirmDialog> {
  SendAwayController sendAwayController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          child: Container(
            constraints:
                BoxConstraints(minHeight: 200, minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Diqqət: ",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: context.theme.textTheme.bodyText1!.color),
                        ),
                        TextSpan(
                          text:
                              "Qarşı tərəf təklifinizi qəbul etdikdə ismarladığının yeməklər qarşı tərəfin masasına göndəriləcək. Hesab isə sizin hesabınıza yazılacaq. İsmarlamağa davam etsəniz bu şərtlə razılaşmış olursunuz",
                          style: GoogleFonts.quicksand(
                              color: context.theme.textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<SendAwayController>(
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hesabınıza yazılacaq əlavə məbləğ:",
                                style: GoogleFonts.quicksand(
                                    color: context
                                        .theme.textTheme.bodyText1!.color),
                              ),
                              Text(
                                "${controller.definePrice()} AZN",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    color: context
                                        .theme.textTheme.bodyText1!.color),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      "Qarşı tərəf təklifi rədd edərsə əlavə məbləğ yazılmayacaq.",
                      style: GoogleFonts.quicksand(
                          color: context.theme.textTheme.bodyText1!.color),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await sendAwayController.sendAwayfromTable(
                                  widget.orderId,
                                  widget.tableNumber,
                                  orderController.order!.data()!["tableNumber"],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "İsmarla",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
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
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Ləğv et",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
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
        ),
      ],
    );
  }
}
