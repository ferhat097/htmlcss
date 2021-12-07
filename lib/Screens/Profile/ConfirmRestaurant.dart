// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/BackgroundOptionController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmRestaurant extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const ConfirmRestaurant({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _ConfirmRestaurantState createState() => _ConfirmRestaurantState();
}

class _ConfirmRestaurantState extends State<ConfirmRestaurant> {
  BackgroundOptionController backgroundOptionController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GetBuilder<BackgroundOptionController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.iconColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 5,
                      width: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.restaurant["restaurantImage"],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.restaurant["restaurantName"],
                      style: GoogleFonts.encodeSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: context.iconColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            IgnorePointer(
              ignoring: controller.loadingBackRest,
              child: SafeArea(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.green),
                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          print("ok");
                          await controller.changeRestaurant(
                            widget.restaurant["restaurantImage"],
                            widget.restaurant["restaurantId"],
                          );
                          Get.back();
                          Get.snackbar("Restoran dəyişdirildi", "");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: controller.loadingBackRest
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Restoranı dəyiş",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
