// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/CompleteSignUpController.dart';
import 'package:foodmood/defaults.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteSecond extends StatefulWidget {
  final String name;
  final String userName;
  const CompleteSecond({Key? key, required this.name, required this.userName})
      : super(key: key);

  @override
  _CompleteSecondState createState() => _CompleteSecondState();
}

class _CompleteSecondState extends State<CompleteSecond> {
  CompleteSignUpController completeSignUpController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSignUpController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Sevdiyiniz yeməklər (${controller.selectedFoods.length}/3) :",
                        style: GoogleFonts.encodeSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: foods.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedFoods
                                      .contains(foods[index]["id"])
                                  ? Colors.green[100]
                                  : context.theme.primaryColor,
                            ),
                            height: double.infinity,
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  controller.selecetFood(foods[index]["id"]);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              foods[index]["photo"],
                                              fit: BoxFit.cover,
                                              scale: 3,
                                            ),
                                            controller.selectedFoods.contains(
                                                    foods[index]["id"])
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: context.isDarkMode
                                                          ? Colors.black87
                                                          : Colors.white70,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        color:
                                                            context.iconColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      foods[index]["name"],
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Sevdiyiniz içkilər (${controller.selectedDrinks.length}/3) :",
                        style: GoogleFonts.encodeSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: drinks.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedDrinks
                                      .contains(drinks[index]["id"])
                                  ? Colors.green[100]
                                  : context.theme.primaryColor,
                            ),
                            height: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  controller.selecetDrink(
                                    drinks[index]["id"],
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              drinks[index]["photo"],
                                              fit: BoxFit.cover,
                                              scale: 3,
                                            ),
                                            controller.selectedDrinks.contains(
                                              drinks[index]["id"],
                                            )
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: context.isDarkMode
                                                          ? Colors.black87
                                                          : Colors.white70,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        color:
                                                            context.iconColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      drinks[index]["name"],
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Sevdiyiniz məkanlar (${controller.selectedRestaurants.length}/3) :",
                        style: GoogleFonts.encodeSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: restaurant.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedRestaurants.contains(
                                restaurant[index]["id"],
                              )
                                  ? Colors.green[100]
                                  : context.theme.primaryColor,
                            ),
                            height: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  controller.selecetRestaurant(
                                    restaurant[index]["id"],
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              restaurant[index]["photo"],
                                              fit: BoxFit.cover,
                                              scale: 3,
                                            ),
                                            controller.selectedRestaurants
                                                    .contains(
                                              restaurant[index]["id"],
                                            )
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: context.isDarkMode
                                                          ? Colors.black87
                                                          : Colors.white70,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        color:
                                                            context.iconColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      restaurant[index]["name"],
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<CompleteSignUpController>(
              id: 'complete',
              builder: (controller2) {
                return IgnorePointer(
                  ignoring: controller2.completeLoading,
                  child: Container(
                    width: double.infinity,
                    color: controller.definePercentage() == 100
                        ? Colors.green
                        : Colors.green[300],
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          bool available =
                              completeSignUpController.checkError();
                          if (available) {
                            await controller.setFoodMoodSocial(
                              widget.name,
                              widget.userName,
                            );
                            Get.back();
                            Get.snackbar("FoodMood Social aktiv edildi", "");
                          } else {
                            Get.snackbar(
                              "Hər üç kateqoriyaya uyğun 3 seçim edin",
                              "",
                            );
                          }
                        },
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: controller2.completeLoading
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      controller.definePercentage() == 100
                                          ? " 100% Bitir"
                                          : "${controller.definePercentage()}% Tamamlandı",
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
