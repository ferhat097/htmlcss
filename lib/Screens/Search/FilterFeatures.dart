// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterFeatures extends StatefulWidget {
  const FilterFeatures({Key? key}) : super(key: key);

  @override
  _FilterFeaturesState createState() => _FilterFeaturesState();
}

class _FilterFeaturesState extends State<FilterFeatures> {
  SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SearchController>(
        id: "features",
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.6,
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
                Expanded(
                  child: GetBuilder<FirebaseRemoteConfigController>(
                    builder: (controller2) {
                      if (controller.features.isEmpty) {
                        if (controller2.features.isNotEmpty) {
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) {
                              controller.getFeatures();
                            },
                          );
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: controller.features.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: controller.selectedFeatures.contains(
                                  controller.features[index]["id"],
                                )
                                    ? Colors.green
                                    : context.theme.backgroundColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    searchController.setFeature(
                                      controller.features[index]["id"],
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.network(
                                      searchController.features[index]
                                          ["featuresImage"],
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : controller.selectedFeatures
                                                  .contains(
                                              controller.features[index]["id"],
                                            )
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Flexible(
                        child: IgnorePointer(
                          ignoring: controller.loadingFeatures,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  if (controller.selectedFeatures.isNotEmpty) {
                                    await searchController
                                        .setRestaurantFeatures(true);
                                    Get.back();
                                  } else {
                                    Get.snackbar(
                                      "Filtrəni tətbiq etmək üçün ən azı biri seçilməlidir!",
                                      "Seçmək üçün özəlliyin üzərinə toxun!",
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: controller.loadingFeatures
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            "Filtrəni tətbiq et",
                                            style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: IgnorePointer(
                          ignoring: controller.loadingDeleteFeature,
                          child: Container(
                            decoration: BoxDecoration(
                              color: defineTextFieldColor(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  await searchController.deleteFeature();
                                  Get.back();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: controller.loadingDeleteFeature
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            "Filtrəni təmizlə",
                                            style: GoogleFonts.quicksand(
                                              color: defineWhiteBlack(),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
