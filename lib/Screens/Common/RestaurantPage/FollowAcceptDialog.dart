import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/RestaurantPageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowAcceptDialog extends StatefulWidget {
  final String restaurantId;
  const FollowAcceptDialog({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _FollowAcceptDialogState createState() => _FollowAcceptDialogState();
}

class _FollowAcceptDialogState extends State<FollowAcceptDialog> {
  RestaurantPageController restaurantPageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              color: context.theme.canvasColor,
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 150),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Restoranı izlədikdə restoran endirim və təkliflərindən xəbərdar olacaqsınız",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GetBuilder<RestaurantPageController>(
                      builder: (controller) {
                        return Row(
                          children: [
                            Flexible(
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () async {
                                      await restaurantPageController
                                          .follow(widget.restaurantId);
                                      Get.back();
                                    },
                                    child: Center(
                                      child: controller.followProgress
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "İzlə",
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Geriyə",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
