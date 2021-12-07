// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/FoodDetailController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteCommentFood extends StatefulWidget {
  final String foodId;
  const WriteCommentFood({Key? key, required this.foodId}) : super(key: key);

  @override
  _WriteCommentFoodState createState() => _WriteCommentFoodState();
}

class _WriteCommentFoodState extends State<WriteCommentFood> {
  FoodDetailController foodDetailController = Get.find();
  ProfilePageController profilePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GetBuilder<FoodDetailController>(
        builder: (controller) {
          return IgnorePointer(
            ignoring: controller.commentWritingProgress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius:const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Şərh yaz:",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                   const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              profilePageController.meSocial!
                                  .data()!["userPhoto"],
                            ),
                          ),
                         const SizedBox(
                            width: 5,
                          ),
                          Text(
                            profilePageController.meSocial!.data()!["name"],
                            style: GoogleFonts.quicksand(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller:
                              controller.writeRestaurantCommentController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Rəy",
                            hintStyle: GoogleFonts.quicksand(),
                            contentPadding:const EdgeInsets.only(
                              left: 10,
                              top: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (controller.writeRestaurantCommentController.text
                                  .isNotEmpty &&
                              !controller.commentWritingProgress) {
                            await controller
                                .writeRestaurantComment(widget.foodId);
                            controller.writeRestaurantCommentController.clear();
                            Get.back();
                          } else {
                            Get.snackbar("Rəy boş ola bilməz", "");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: controller.commentWritingProgress
                              ? Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Gözləyin, rəyiniz göndərilir",
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "Göndər",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
