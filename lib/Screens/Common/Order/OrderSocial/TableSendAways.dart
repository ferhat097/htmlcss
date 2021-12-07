import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/SendAwayController.dart';
import 'package:foodmood/Controllers/TableSendAwaysController.dart';
import 'package:foodmood/Screens/Common/Order/OrderSocial/SendAwayMenuBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TableSendAways extends StatefulWidget {
  const TableSendAways({Key? key}) : super(key: key);

  @override
  _TableSendAwaysState createState() => _TableSendAwaysState();
}

class _TableSendAwaysState extends State<TableSendAways> {
  TableSendAwaysController tableSendAwaysController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: context.textTheme.bodyText1!.color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<TableSendAwaysController>(
              builder: (controller) {
                if (controller.sendAways.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      itemCount: controller.sendAways.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: context.theme.canvasColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        controller.sendAways[index]
                                            .data()!["fromPhoto"],
                                      ),
                                      radius: 35,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Masa ${controller.sendAways[index].data()!["fromTableNumber"]}",
                                                style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.bold,
                                                    color: context
                                                        .theme
                                                        .textTheme
                                                        .bodyText1!
                                                        .color),
                                              ),
                                              TextSpan(
                                                text: " - dən sizə ismarlama",
                                                style: GoogleFonts.quicksand(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: context
                                                        .theme
                                                        .textTheme
                                                        .bodyText1!
                                                        .color),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: "İsmarlayan: ",
                                              style: GoogleFonts.quicksand(
                                                  color: context.theme.textTheme
                                                      .bodyText1!.color)),
                                          TextSpan(
                                            text: controller.sendAways[index]
                                                .data()!["fromName"],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                color: context.theme.textTheme
                                                    .bodyText1!.color),
                                          )
                                        ]))
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    width: double.infinity,
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
                                          Get.bottomSheet(
                                            SendAwayMenuBottomSheet(
                                              sendAwayId: controller
                                                  .sendAways[index].id,
                                            ),
                                            isScrollControlled: true,
                                            backgroundColor:
                                                context.theme.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              "Ismarlanan menyuya bax",
                                              style: GoogleFonts.quicksand(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (!controller.sendAways[index]
                                    .data()!["accepted"])
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.pink),
                                          width: double.infinity,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                await tableSendAwaysController
                                                    .acceptSendAway(
                                                  orderController.order!.id,
                                                  controller
                                                      .sendAways[index].id,
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    "Qəbul et",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: context
                                                  .theme.backgroundColor),
                                          width: double.infinity,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    "Rədd et",
                                                    style:
                                                        GoogleFonts.quicksand(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  Container(
                                    decoration:
                                        BoxDecoration(color: Colors.pink[700]),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "İsmarlama qəbul olunub",
                                          style: GoogleFonts.quicksand(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Sizə ismarlama yoxdur",
                      style: GoogleFonts.quicksand(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
