import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodmood/Controllers/RestaurantPageController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RatingRestaurant extends StatefulWidget {
  final String restaurantId;
  const RatingRestaurant({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RatingRestaurantState createState() => _RatingRestaurantState();
}

class _RatingRestaurantState extends State<RatingRestaurant> {
  RestaurantPageController restaurantPageController = Get.find();
  @override
  void dispose() {
    restaurantPageController.setRating(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GetBuilder<RestaurantPageController>(
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.checkRatingAvailable(
                  restaurantPageController.restaurant!.data()!["ratingUsers"]))
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
                          "Səs ver:",
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
                    GetBuilder<RestaurantPageController>(
                      id: "rating",
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBar.builder(
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.yellow[800],
                                  );
                                },
                                onRatingUpdate: (rating) {
                                  controller.setRating(rating);
                                },
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  minWidth: 50,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[800],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      controller.rating.toString(),
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                    SizedBox(
                      height: 10,
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
                          controller: controller.ratingWithCommentController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Rəy (istəyə bağlı)",
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
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Siz artıq səs vermisiniz!",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
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
                        if (controller.checkRatingAvailable(
                            restaurantPageController.restaurant!
                                .data()!["ratingUsers"])) {
                          await controller.ratingRestaurant(
                            controller.rating,
                            widget.restaurantId,
                          );
                          restaurantPageController.ratingWithCommentController
                              .clear();
                          Get.back();
                        } else {
                          Get.snackbar("Siz artıq səs vermisiniz", "");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Center(
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
          );
        },
      ),
    );
  }
}
