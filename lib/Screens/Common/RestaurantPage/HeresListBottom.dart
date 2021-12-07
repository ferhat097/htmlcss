// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/HeresListController.dart';
import 'package:foodmood/Controllers/RestaurantPageController.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HeresListBottom extends StatefulWidget {
  const HeresListBottom({Key? key}) : super(key: key);

  @override
  _HeresListBottomState createState() => _HeresListBottomState();
}

class _HeresListBottomState extends State<HeresListBottom> {
  RestaurantPageController restaurantPageController = Get.find();
  HeresListController heresListController = Get.put(HeresListController());
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: GetBuilder<RestaurantPageController>(
        id: "heres",
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              if (controller.heres.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: restaurantPageController.heres.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          if (controller.heres[index].data()!["userId"]) {
                            Get.to(
                              () => UserProfile(
                                userId:
                                    controller.heres[index].data()!["userId"],
                              ),
                              transition: Transition.size,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image.network(
                                            controller.heres[index]
                                                .data()!["userPhoto"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            controller.heres[index]
                                                .data()!["name"],
                                            style: GoogleFonts.quicksand(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
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
                      ),
                    );
                  },
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Heç kim bu restoranda olduğunu bildirməyib",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: context.iconColor,
                        ),
                      ),
                      Text(
                        "İlk sən ol və ${generalController.financial["firstHeresAward"]} MoodX qazan",
                        style: GoogleFonts.encodeSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.iconColor,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
