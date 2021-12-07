// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/RestaurantPageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteCommentBottom extends StatefulWidget {
  final String restaurantId;
  const WriteCommentBottom({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _WriteCommentBottomState createState() => _WriteCommentBottomState();
}

class _WriteCommentBottomState extends State<WriteCommentBottom> {
  dispose() {
    restaurantPageController.writeRestaurantCommentController.clear();
    super.dispose();
  }

  ProfilePageController profilePageController = Get.find();
  RestaurantPageController restaurantPageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GetBuilder<RestaurantPageController>(
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
                        borderRadius: BorderRadius.only(
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
                    SizedBox(
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
                          SizedBox(
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
                            contentPadding: EdgeInsets.only(
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
                  decoration: BoxDecoration(
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
                                .writeRestaurantComment(widget.restaurantId);
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
