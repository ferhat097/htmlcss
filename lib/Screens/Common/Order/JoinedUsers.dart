import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinedUsers extends StatefulWidget {
  const JoinedUsers({Key? key}) : super(key: key);

  @override
  _JoinedUsersState createState() => _JoinedUsersState();
}

class _JoinedUsersState extends State<JoinedUsers> {
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: orderController.defineUserImage(
                            orderController.order!.data()!["openedPhoto"],
                          ),
                          radius: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                orderController.order!.data()!["openedName"],
                                style: GoogleFonts.quicksand(
                                    fontSize: 16, color: context.iconColor),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${orderController.order!.data()!["tableType"]} ",
                                      style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          color: context.iconColor),
                                    ),
                                    TextSpan(
                                      text: orderController.order!
                                          .data()!["tableNumber"]
                                          .toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: context.iconColor),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sifariş şifrəsi",
                          style:
                              GoogleFonts.quicksand(color: context.iconColor),
                        ),
                        Text(
                          orderController.order!
                              .data()!["orderPassword"]
                              .toString(),
                          style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.iconColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: GetBuilder<OrderController>(
                builder: (controller) {
                  if (controller.joinedUsers != null) {
                    return Container(
                      child: ListView.separated(
                        itemCount: controller.joinedUsers!.docs.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            orderController.defineUserImage(
                                          controller.joinedUsers!.docs[index]
                                              .data()["userPhoto"],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.joinedUsers!.docs[index]
                                                .data()["name"],
                                            style: GoogleFonts.quicksand(
                                              fontSize: 18,
                                              color: context.iconColor,
                                            ),
                                          ),
                                          Text(
                                            controller.joinedUsers!.docs[index]
                                                .data()["username"],
                                            style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              color: context.iconColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(child: Container()),
                                      Flexible(child: Container())
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
