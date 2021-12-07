import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteOrderWithFoodMoodAccount extends StatefulWidget {
  const CompleteOrderWithFoodMoodAccount({Key? key}) : super(key: key);

  @override
  _CompleteOrderWithFoodMoodAccountState createState() =>
      _CompleteOrderWithFoodMoodAccountState();
}

class _CompleteOrderWithFoodMoodAccountState
    extends State<CompleteOrderWithFoodMoodAccount> {
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<ProfilePageController>(
        builder: (profileController) {
          if (profileController.meSocial != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: GetBuilder<OrderController>(
                builder: (orderConroller) {
                  if (orderConroller.order!.data()!["active"]) {
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ödəniləcək məbləğ:",
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                  ),
                                  Text(
                                    "${orderConroller.order!.data()!["totalAmount"].toString()} AZN",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "FoodMood Hesabım:",
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                  ),
                                  Text(
                                    "${profileController.meSocial!.data()!["cash"].toString()} AZN",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (profileController.meSocial!.data()!["cash"] <
                                  orderConroller.order!.data()!["totalAmount"])
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "FoodMoodu hesabı ilə ödəmə etdikdən sonra əlavə",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${(orderConroller.order!.data()!["totalAmount"] - profileController.meSocial!.data()!["cash"]).toString()} AZN ",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            "məbləği digər ödəmə üsulları ilə ödəməlisiniz",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "FoodMoodu hesabı ilə ödəməni bitirdikdən sonra balansınız",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${(profileController.meSocial!.data()!["cash"] - orderConroller.order!.data()!["totalAmount"]).toString()} AZN ",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "təşkil edəcək",
                                        style: GoogleFonts.quicksand(
                                            color: context.theme.textTheme
                                                .bodyText1!.color),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () async {
                                  Get.back();
                                  orderController.activeProgress(true);
                                  String result = await orderController
                                      .payWithFoodMoodAccount();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      profileController.meSocial!
                                                  .data()!["cash"] <
                                              orderConroller.order!
                                                  .data()!["totalAmount"]
                                          ? "FoodMood hesabımdan çıx"
                                          : "Sifarişi tamamla",
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
