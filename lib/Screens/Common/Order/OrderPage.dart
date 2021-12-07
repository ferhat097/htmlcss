import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Screens/Common/Order/CommonOrder/CommonOrder.dart';
import 'package:foodmood/Screens/Common/Order/OrderSocial/OrderSocial.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  final String? orderId;
  final bool createOrder;
  final bool needJoin;
  final String restaurantId;
  final int tableNumber;
  const OrderPage(
      {Key? key,
      this.orderId,
      required this.createOrder,
      required this.restaurantId,
      required this.tableNumber,
      required this.needJoin})
      : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderController orderController = Get.put(OrderController(), permanent: true);

  @override
  void initState() {
    if (widget.createOrder) {
      orderController.createOrder(widget.restaurantId, widget.tableNumber);
    } else {
      if (widget.needJoin) {
        orderController.joinOrder(
            widget.restaurantId, widget.tableNumber, widget.orderId!);
      } else {
        orderController.listenOrder(
            widget.restaurantId, widget.tableNumber, widget.orderId!);
        orderController.listenJoinedUser(widget.orderId!);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<OrderController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(
      //   child: Center(
      //     child: IconButton(
      //       onPressed: () {
      //         print(orderController.order!.id);
      //         orderController.completeOrder(widget.restaurantId,
      //             widget.tableNumber, orderController.order!.id);
      //       },
      //       icon: Icon(
      //         Icons.delete,
      //       ),
      //     ),
      //   ),
      // ),
      body: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.order != null) {
            return PageView(
              controller: controller.orderPageController,
              children: [
                CommonOrder(
                  orderId: controller.order!.id,
                  tableNumber: widget.tableNumber,
                  restaurantId: widget.restaurantId,
                ),
                OrderSocial(
                  restaurantId: widget.restaurantId,
                  orderId: controller.order!.id,
                  tableNumber: widget.tableNumber,
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
