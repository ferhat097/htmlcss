// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/HastagDetailController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';

class HastagDetail extends StatefulWidget {
  final String hastagId;
  final String hastagName;
  final String infoText;
  final String hastagColor;
  final String textColor;
  const HastagDetail(
      {Key? key,
      required this.hastagId,
      required this.hastagName,
      required this.infoText,
      required this.hastagColor,
      required this.textColor})
      : super(key: key);

  @override
  _HastagDetailState createState() => _HastagDetailState();
}

class _HastagDetailState extends State<HastagDetail> {
  HastagController hastagController = Get.put(HastagController());
  @override
  void initState() {
    hastagController.getRestaurants(widget.hastagId);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<HastagController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: context.theme.primaryColor,
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: HexColor(widget.hastagColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "#${widget.hastagName}",
                style: GoogleFonts.comfortaa(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: HexColor(widget.textColor),
                ),
              ),
            ),
          ),
          GetBuilder<GeneralController>(
            id: "generaladControll",
            builder: (controller) {
              if (controller.adControll.isNotEmpty) {
                if (controller.adControll["isHastagDetailBanner"]) {
                  return FutureBuilder<AdWidget>(
                    future: hastagController.loadAds(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: snap.data!,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              widget.infoText,
              style: GoogleFonts.quicksand(),
              textAlign: TextAlign.center,
            ),
          ),
          GetBuilder<HastagController>(
            builder: (controller) {
              if (controller.restaurants.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.restaurants.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                          color: defineMainBackgroundColor(),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(0),
                            onTap: () {
                              Get.to(
                                () => RestaurantPage(
                                  restaurantId: controller.restaurants[index]
                                      .data()!["restaurantId"],
                                ),
                                preventDuplicates: false,
                                transition: Transition.size,
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                        child: Image.network(
                                          controller.restaurants[index]
                                              .data()!["restaurantImage"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.restaurants[index]
                                            .data()!["restaurantName"],
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
