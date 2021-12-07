import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/OrderDetail.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/OrderMessage.dart';
import 'package:foodmood/Screens/Common/Order/JoinedUsers.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonOrder extends StatefulWidget {
  final String orderId;
  final int tableNumber;
  final String restaurantId;
  const CommonOrder(
      {Key? key,
      required this.orderId,
      required this.tableNumber,
      required this.restaurantId})
      : super(key: key);

  @override
  _CommonOrderState createState() => _CommonOrderState();
}

class _CommonOrderState extends State<CommonOrder> {
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.canvasColor,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
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
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/home.png",
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
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
                      Get.bottomSheet(
                        JoinedUsers(),
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.users,
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
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
                      orderController.orderPageController.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        "assets/foodmoodsocial.png",
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
        title: GetBuilder<OrderController>(
          builder: (controller) {
            if (controller.order != null) {
              return Text(
                controller.order!.data()!["restaurantName"] ?? "Sifariş",
                style: GoogleFonts.quicksand(
                  color: defineWhiteBlack(),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
      body: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.order != null) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    child: TabBar(
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Sifariş",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Mesaj",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        OrderDetail(
                          orderId: widget.orderId,
                          tableNumber: widget.tableNumber,
                          restaurantId: widget.restaurantId,
                        ),
                        OrderMessage(
                          orderId: widget.orderId,
                          tableNumber: widget.tableNumber,
                          restaurantId: widget.restaurantId,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
