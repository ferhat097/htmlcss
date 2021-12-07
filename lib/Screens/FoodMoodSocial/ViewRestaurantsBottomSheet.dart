// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ViewCouponRestaurant.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewRestaurantBottomSheet extends StatefulWidget {
  final String couponId;
  const ViewRestaurantBottomSheet({Key? key, required this.couponId})
      : super(key: key);

  @override
  _ViewRestaurantBottomSheetState createState() =>
      _ViewRestaurantBottomSheetState();
}

class _ViewRestaurantBottomSheetState extends State<ViewRestaurantBottomSheet> {
  ViewCouponRestaurant viewCouponRestaurant = Get.put(ViewCouponRestaurant());
  @override
  void dispose() {
    Get.delete<ViewCouponRestaurant>();
    super.dispose();
  }

  @override
  void initState() {
    viewCouponRestaurant.getRestaurant(widget.couponId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Keçərli Restoranlar",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ViewCouponRestaurant>(
              builder: (controller) {
                if (controller.couponsRestaurant.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                      itemCount: controller.couponsRestaurant.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
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
                                Get.to(
                                  () => RestaurantPage(
                                    restaurantId: controller
                                        .couponsRestaurant[index]
                                        .data()!["restaurantId"],
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: Image.network(
                                        controller.couponsRestaurant[index]
                                            .data()!["restaurantPhoto"],
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 150,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        controller.couponsRestaurant[index]
                                            .data()!["restaurantName"],
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
