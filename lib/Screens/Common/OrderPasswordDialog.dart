import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmood/Controllers/MenuPageController.dart';
import 'package:foodmood/Screens/Common/Order/OrderPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPasswordDialog extends StatefulWidget {
  final int tableNumber;
  final String restaurantId;
  const OrderPasswordDialog(
      {Key? key, required this.tableNumber, required this.restaurantId})
      : super(key: key);

  @override
  _OrderPasswordDialogState createState() => _OrderPasswordDialogState();
}

class _OrderPasswordDialogState extends State<OrderPasswordDialog> {
  MenuPageController menuPageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              color: context.theme.canvasColor,
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 200),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sifariş şifrəsini daxil edin",
                          style: GoogleFonts.quicksand(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Sifariş şifrəsi",
                                hintStyle: GoogleFonts.quicksand(),
                                contentPadding: EdgeInsets.only(left: 10),
                              ),
                              controller: menuPageController.orderPassword,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  Map<String, dynamic> status =
                                      await menuPageController
                                          .checkOrderCodePassword(
                                    menuPageController.orderPassword.text,
                                    widget.tableNumber,
                                    widget.restaurantId,
                                  );
                                  if (status["status"]) {
                                    Get.back();
                                    Get.off(
                                      () => OrderPage(
                                        createOrder: false,
                                        restaurantId: widget.restaurantId,
                                        tableNumber: widget.tableNumber,
                                        needJoin: true,
                                        orderId: status["orderId"],
                                      ),
                                    );
                                  } else {
                                    return Get.snackbar(
                                        "Şifrə düzgün deyil", "");
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Təsdiqlə",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
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
                            height: 50,
                            width: double.infinity,
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
                                child: Center(
                                  child: Text(
                                    "Geriyə",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
