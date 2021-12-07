// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GamesController/WhatILikeController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../defaults.dart';

class WhatILikeGame extends StatefulWidget {
  const WhatILikeGame({Key? key}) : super(key: key);

  @override
  _WhatILikeGameState createState() => _WhatILikeGameState();
}

class _WhatILikeGameState extends State<WhatILikeGame> {
  WhatILikeController whatILikeController = Get.put(WhatILikeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<WhatILikeController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                                    controller.selectFood(foods[index]["id"]);
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
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.black87
                                                            : Colors.white70,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
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
                                    controller.selectDrink(
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
                                              controller.selectedDrinks
                                                      .contains(
                                                drinks[index]["id"],
                                              )
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.black87
                                                            : Colors.white70,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
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
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                ),
                child: Row(
                  children: [
                    Container(
                      //height: 100,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            controller.timeRemaining.toString(),
                            style: GoogleFonts.encodeSans(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // controller.sendInvitation();
                            },
                            child: Text(
                              "Göndər",
                              style: GoogleFonts.encodeSans(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
