import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/TableMessageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../DarkModeController.dart';

class OrderMessage extends StatefulWidget {
  final String orderId;
  final String restaurantId;
  final int tableNumber;
  const OrderMessage(
      {Key? key,
      required this.orderId,
      required this.restaurantId,
      required this.tableNumber})
      : super(key: key);

  @override
  _OrderMessageState createState() => _OrderMessageState();
}

class _OrderMessageState extends State<OrderMessage> {
  TableMessageController tableMessageController =
      Get.put(TableMessageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableMessageController>(
      builder: (controller) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller
              .loadMessages(
                  widget.tableNumber, widget.orderId, widget.restaurantId)
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      controller: controller.scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.docs[index]
                            .data()["date"]
                            .toDate()
                            .toString());
                        return LimitedBox(
                          maxWidth: 150,
                          child: Container(
                            alignment: !snapshot.data!.docs[index]
                                    .data()["fromRestaurant"]
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: defineTextFieldColor()),
                                child: LimitedBox(
                                  maxWidth: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]
                                              .data()["message"],
                                          style: GoogleFonts.quicksand(
                                              color: defineWhiteBlack(),
                                              fontSize: 16),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 4),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                snapshot.data!.docs[index]
                                                            .data()[
                                                        "fromRestaurant"]
                                                    ? snapshot.data!.docs[index]
                                                            .data()["readed"]
                                                        ? Icons.done_all
                                                        : Icons.done
                                                    : Icons.message,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${dateTime.hour.toString()} : ${dateTime.minute.toString()}",
                                                style: GoogleFonts.quicksand(
                                                    color: defineWhiteBlack()),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black45 : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: defineTextFieldColor(),
                              //       borderRadius: BorderRadius.circular(5)),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         Icon(Icons.add),
                              //         Text("Rezerv əlavə et"),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: defineTextFieldColor(),
                                        ),
                                        child: TextField(
                                          controller:
                                              controller.messageController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Mesajınız",
                                              hintStyle: GoogleFonts.quicksand(
                                                  color: defineWhiteBlack()),
                                              contentPadding:
                                                  EdgeInsets.only(left: 10)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[600],
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      height: double.infinity,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          onTap: () async {
                                            print(widget.tableNumber);
                                            print(widget.orderId);
                                            print(widget.restaurantId);
                                            await tableMessageController
                                                .sendMessage(
                                                    widget.restaurantId,
                                                    widget.tableNumber,
                                                    widget.orderId);
                                            tableMessageController
                                                .messageController
                                                .clear();
                                            // messageDetailController.sendMessage(
                                            //     widget.conversationId,
                                            //     messageDetailController
                                            //         .messageController.text);
                                            // messageDetailController
                                            //     .messageController
                                            //     .clear();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                            ),
                                            child: Image.asset(
                                                "assets/send.png",
                                                scale: 22,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          },
        );
      },
    );
  }
}
