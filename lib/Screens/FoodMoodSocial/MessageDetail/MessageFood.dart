// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Screens/Common/FoodDetail.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageFood extends StatefulWidget {
  final Map<String, dynamic> message;
  const MessageFood({Key? key, required this.message}) : super(key: key);

  @override
  _MessageFoodState createState() => _MessageFoodState();
}

class _MessageFoodState extends State<MessageFood> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        color: context.theme.primaryColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                Get.bottomSheet(
                  FoodDetail(
                    foodId: widget.message["foodId"],
                  ),
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          widget.message["foodImage"] ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.message["name"] ?? "",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.message["isDiscount"] ?? false)
                            Row(
                              children: [
                                Text(
                                  "${widget.message["price"] ?? 0} AZN",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                    color: context.isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${widget.message["discountPrice"] ?? 0} AZN",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: context.iconColor),
                                )
                              ],
                            )
                          else
                            Text(
                              "${widget.message["price"] ?? 0} AZN",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment
              //         .topCenter,
              //     end: Alignment
              //         .bottomCenter,
              //     colors: [
              //       context.isDarkMode
              //           ? Colors
              //               .white70
              //           : Colors
              //               .black87,
              //       context.theme
              //           .primaryColor,
              //     ]),
              color: context.isDarkMode ? Colors.black26 : Colors.white30,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            width: double.infinity,
            height: 80,
            child: Material(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                onTap: () {
                  Get.to(
                    () => RestaurantPage(
                      restaurantId: widget.message["restaurantId"],
                    ),
                    transition: Transition.size,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(
                                  widget.message["restaurantImage"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.message["restaurantName"],
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: context.iconColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Icon(
                        Icons.touch_app,
                        color: context.iconColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
