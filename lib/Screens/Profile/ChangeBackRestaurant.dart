// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/BackgroundOptionController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeBackRestaurant extends StatefulWidget {
  const ChangeBackRestaurant({Key? key}) : super(key: key);

  @override
  _ChangeBackRestaurantState createState() => _ChangeBackRestaurantState();
}

class _ChangeBackRestaurantState extends State<ChangeBackRestaurant> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BackgroundOptionController>(
      builder: (controller) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.iconColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 5,
                width: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (String value) {
                      controller.searchDelayFunction(
                        controller.searchController.text,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Restoran axtar",
                      hintStyle: GoogleFonts.encodeSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
              ),
              if (controller.searchResults != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 5,
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.searchResults!.hits.length,
                      //physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: context.theme.backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                Get.back<Map<String, dynamic>>(
                                  result: controller
                                      .searchResults!.hits[index].data,
                                );
                                controller.select();
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                          child:
                                              controller.defineRestaurantImage(
                                            controller
                                                .searchResults!
                                                .hits[index]
                                                .data["restaurantImage"],
                                            context,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: controller.defineType(
                                              controller
                                                  .searchResults!
                                                  .hits[index]
                                                  .data["facilityType"],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                // Get.bottomSheet(
                                                //   DirectionBottom(
                                                //     latLng: controller.searchResults!
                                                //         .hits[index].data["location"],
                                                //     restaurant: controller
                                                //         .searchResults!
                                                //         .hits[index]
                                                //         .data,
                                                //   ),
                                                //   isScrollControlled: true,
                                                //   backgroundColor:
                                                //       context.theme.canvasColor,
                                                //   shape: const RoundedRectangleBorder(
                                                //     borderRadius: BorderRadius.only(
                                                //       topLeft: Radius.circular(20),
                                                //       topRight: Radius.circular(20),
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .theme.primaryColor
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                                  child: Icon(
                                                    Icons.near_me,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: controller
                                                        .defineOpenedStatus(
                                                  controller
                                                      .searchResults!
                                                      .hits[index]
                                                      .data["openTime"],
                                                  controller
                                                      .searchResults!
                                                      .hits[index]
                                                      .data["closeTime"],
                                                  controller
                                                          .searchResults!
                                                          .hits[index]
                                                          .data["is247"] ??
                                                      false,
                                                )
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                              height: 10,
                                              width: 10,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                controller
                                                    .searchResults!
                                                    .hits[index]
                                                    .data["restaurantName"],
                                                overflow: TextOverflow.visible,
                                                maxLines: 2,
                                                style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
