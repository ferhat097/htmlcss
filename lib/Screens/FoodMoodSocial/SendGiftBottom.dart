// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/SendGiftController.dart';
import 'package:foodmood/defaults.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SendGiftBottom extends StatefulWidget {
  final bool fromConversation;
  final String userOrConversationId;
  final Map<String, dynamic>? user;
  final String? token;
  final String? toName;
  const SendGiftBottom(
      {Key? key,
      required this.fromConversation,
      required this.userOrConversationId,
      this.user,
      this.token,
      this.toName})
      : super(key: key);

  @override
  State<SendGiftBottom> createState() => _SendGiftBottomState();
}

class _SendGiftBottomState extends State<SendGiftBottom> {
  SendGiftController sendGiftController = Get.put(SendGiftController());
  GeneralController generalController = Get.find();
  @override
  void dispose() {
    Get.delete<SendGiftController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.iconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 5,
              width: 40,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Göndərdiyiniz şəxs hədiyyənin dəyərinin ~${100 - generalController.financial["sendGiftPercent"]}% qədər 'MoodX' qazanacaq!",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const TabBar(tabs: [
              Tab(
                text: "Ümumi",
              ),
              Tab(
                text: "Güllər",
              ),
              Tab(
                text: "İçkilər",
              ),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  FirstType(
                    fromConversation: widget.fromConversation,
                    userOrConversationId: widget.userOrConversationId,
                    user: widget.user,
                    token: widget.token,
                    toName: widget.toName,
                  ),
                  SecondType(
                    fromConversation: widget.fromConversation,
                    userOrConversationId: widget.userOrConversationId,
                    user: widget.user,
                    token: widget.token,
                    toName: widget.toName,
                  ),
                  ThirdType(
                    fromConversation: widget.fromConversation,
                    userOrConversationId: widget.userOrConversationId,
                    user: widget.user,
                    token: widget.token,
                    toName: widget.toName,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FirstType extends StatefulWidget {
  final bool fromConversation;
  final String userOrConversationId;
  final Map<String, dynamic>? user;
  final String? token;
  final String? toName;
  const FirstType(
      {Key? key,
      required this.fromConversation,
      required this.userOrConversationId,
      this.user,
      this.token,
      this.toName})
      : super(key: key);

  @override
  _FirstTypeState createState() => _FirstTypeState();
}

class _FirstTypeState extends State<FirstType> {
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendGiftController>(
      builder: (controller) {
        return GridView.builder(
          itemCount: gifts.where((element) => element["level"] == 1).length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Column(
              children: [
                // SizedBox(
                //   height: 5,
                // ),
                Expanded(
                  child: Image.asset(gifts
                      .where((element) => element["level"] == 1)
                      .toList()[index]["image"]),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Material(
                    elevation: 2,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () async {
                        await controller.sendGift(
                          gifts
                              .where((element) => element["level"] == 1)
                              .toList()[index]["moodx"],
                          widget.fromConversation,
                          widget.userOrConversationId,
                          gifts
                              .where((element) => element["level"] == 1)
                              .toList()[index],
                          widget.user ?? {},
                          widget.token,
                          widget.toName,
                          generalController.financial["sendGiftPercent"],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(
                            "${gifts.where((element) => element["level"] == 1).toList()[index]["moodx"]}",
                            style: GoogleFonts.encodeSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
        );
      },
    );
  }
}

class SecondType extends StatefulWidget {
  final bool fromConversation;
  final String userOrConversationId;
  final Map<String, dynamic>? user;
  final String? token;
  final String? toName;
  const SecondType(
      {Key? key,
      required this.fromConversation,
      required this.userOrConversationId,
      this.user,
      this.token,
      this.toName})
      : super(key: key);

  @override
  _SecondTypeState createState() => _SecondTypeState();
}

class _SecondTypeState extends State<SecondType> {
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendGiftController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GridView.builder(
            itemCount: gifts.where((element) => element["level"] == 2).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Expanded(
                    child: Image.asset(gifts
                        .where((element) => element["level"] == 2)
                        .toList()[index]["image"]),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      elevation: 2,
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () async {
                          await controller.sendGift(
                            gifts
                                .where((element) => element["level"] == 2)
                                .toList()[index]["moodx"],
                            widget.fromConversation,
                            widget.userOrConversationId,
                            gifts
                                .where((element) => element["level"] == 2)
                                .toList()[index],
                            widget.user ?? {},
                            widget.token,
                            widget.toName,
                            generalController.financial["sendGiftPercent"],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              "${gifts.where((element) => element["level"] == 2).toList()[index]["moodx"] > 1000 ? "${(gifts.where((element) => element["level"] == 2).toList()[index]["moodx"] / 1000).toStringAsFixed(0)}K" : gifts.where((element) => element["level"] == 2).toList()[index]["moodx"]}",
                              style: GoogleFonts.encodeSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
      },
    );
  }
}

class ThirdType extends StatefulWidget {
  final bool fromConversation;
  final String userOrConversationId;
  final Map<String, dynamic>? user;
  final String? token;
  final String? toName;
  const ThirdType(
      {Key? key,
      required this.fromConversation,
      required this.userOrConversationId,
      this.user,
      this.token,
      this.toName})
      : super(key: key);

  @override
  _ThirdTypeState createState() => _ThirdTypeState();
}

class _ThirdTypeState extends State<ThirdType> {
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendGiftController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GridView.builder(
            itemCount: gifts.where((element) => element["level"] == 3).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Expanded(
                    child: Image.asset(gifts
                        .where((element) => element["level"] == 3)
                        .toList()[index]["image"]),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.brown[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      elevation: 2,
                      color: Colors.brown[800],
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () async {
                          await controller.sendGift(
                            gifts
                                .where((element) => element["level"] == 3)
                                .toList()[index]["moodx"],
                            widget.fromConversation,
                            widget.userOrConversationId,
                            gifts
                                .where((element) => element["level"] == 3)
                                .toList()[index],
                            widget.user ?? {},
                            widget.token,
                            widget.toName,
                            generalController.financial["sendGiftPercent"],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              "${gifts.where((element) => element["level"] == 3).toList()[index]["moodx"] > 1000 ? "${(gifts.where((element) => element["level"] == 3).toList()[index]["moodx"] / 1000).toStringAsFixed(0)}K" : gifts.where((element) => element["level"] == 3).toList()[index]["moodx"]}",
                              style: GoogleFonts.encodeSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
      },
    );
  }
}
