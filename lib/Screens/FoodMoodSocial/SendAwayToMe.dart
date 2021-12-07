import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MySendAwayController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SendAwayToMe extends StatefulWidget {
  const SendAwayToMe({Key? key}) : super(key: key);

  @override
  _SendAwayToMeState createState() => _SendAwayToMeState();
}

class _SendAwayToMeState extends State<SendAwayToMe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<MySendAwayController>(
        builder: (controller) {
          if (controller.sendAwayMe.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.sendAwayMe.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                Get.to(
                                  () => RestaurantPage(
                                    restaurantId: controller.sendAwayMe[index]
                                        .data()!["restaurantId"],
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(0),
                                        ),
                                        child: Image.network(
                                          controller.sendAwayMe[index]
                                              .data()!["restaurantPhoto"],
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 120,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.sendAwayMe[index]
                                              .data()!["restaurantName"],
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  Get.to(
                                    () => UserProfile(
                                        userId: controller.sendAwayMe[index]
                                            .data()!["sendAwayFromId"]),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        controller.sendAwayMe[index]
                                            .data()!["fromName"],
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "İsmarlanan məbləğ:",
                                style: GoogleFonts.quicksand(),
                              ),
                              Text(
                                "${controller.sendAwayMe[index].data()!["sendAwayAmount"]} AZN",
                                style: GoogleFonts.quicksand(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "İsmarlanma tarixi:",
                                style: GoogleFonts.quicksand(),
                              ),
                              Text(
                                "${controller.sendAwayMe[index].data()!["sendedDate"].toDate()} ",
                                style: GoogleFonts.quicksand(),
                              ),
                            ],
                          ),
                        ),
                        if (!controller.sendAwayMe[index].data()!["accepted"])
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 4),
                                      child: Center(
                                        child: Text(
                                          "Qəbul et",
                                          style: GoogleFonts.quicksand(),
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
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 4),
                                      child: Center(
                                        child: Text(
                                          "Rədd et",
                                          style: GoogleFonts.quicksand(),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return SizedBox(
              child: Center(
                child: Text(
                  "Sizə göndərilən ismarlama yoxdur",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
