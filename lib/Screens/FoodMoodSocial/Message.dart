// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/FoodMoodSocialController.dart';
import 'package:foodmood/Controllers/MessageController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:foodmood/Screens/FoodMoodSocial/GameRequest.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LikedYou.dart';

class Message extends StatefulWidget {
  const Message({
    Key? key,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    FoodMoodSocialController foodMoodSocialController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTabController(
        length: 3,
        child: GetBuilder<MessageController>(
          id: "messages",
          builder: (controller) {
            return Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle: GoogleFonts.encodeSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.encodeSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: Colors.lightBlue,
                  tabs: const [
                    Tab(
                      text: "Mesajlar",
                    ),
                    Tab(
                      text: "Oyun təklifləri",
                    ),
                    Tab(
                      text: "Sizi bəyənənlər",
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await controller.getMatched();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height -
                            //     AppBar().preferredSize.height,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: controller.matched.isNotEmpty
                                      ? ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.matched.length,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 5,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () => MessageDetail(
                                                          withConversation:
                                                              false,
                                                          userId: controller
                                                                  .matched[
                                                              index]["userId"],
                                                          user: controller
                                                              .matched[index],
                                                        ),
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          controller.matched[
                                                                  index]
                                                              ["userPhoto"],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  controller.matched[index]
                                                      ["name"],
                                                  style: GoogleFonts.encodeSans(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.pink,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Material(
                                            color: Colors.pink,
                                            elevation: 2,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                foodMoodSocialController
                                                    .pageController
                                                    .animateToPage(1,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.linear);
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Axtarmağa davam et",
                                                  style: GoogleFonts.encodeSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const Divider(),
                                controller.conversations.isNotEmpty
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            controller.conversations.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: defineTextFieldColor(),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                onTap: () {
                                                  Get.to(
                                                    () => MessageDetail(
                                                      conversationId: controller
                                                          .conversations[index]
                                                          .id,
                                                      userId: controller
                                                                      .conversations[
                                                                          index]
                                                                      .data()![
                                                                  "from"] ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                          ? controller
                                                              .conversations[
                                                                  index]
                                                              .data()!["to"]
                                                          : controller
                                                              .conversations[
                                                                  index]
                                                              .data()!["from"],
                                                      withConversation: true,
                                                    ),
                                                    preventDuplicates: false,
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            onTap: () {
                                                              Get.to(
                                                                () =>
                                                                    UserProfile(
                                                                  userId: controller.conversations[index].data()![
                                                                              "from"] ==
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid
                                                                      ? controller
                                                                              .conversations[
                                                                                  index]
                                                                              .data()![
                                                                          "to"]
                                                                      : controller
                                                                          .conversations[
                                                                              index]
                                                                          .data()!["from"],
                                                                ),
                                                                transition:
                                                                    Transition
                                                                        .size,
                                                                preventDuplicates:
                                                                    false,
                                                              );
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                controller.conversations[index].data()![
                                                                            "from"] ==
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid
                                                                    ? controller
                                                                            .conversations[
                                                                                index]
                                                                            .data()![
                                                                        "toPhoto"]
                                                                    : controller
                                                                        .conversations[
                                                                            index]
                                                                        .data()!["fromPhoto"],
                                                              ),
                                                              radius: 30,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  controller.conversations[index].data()!["from"] ==
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid
                                                                      ? controller.conversations[index]
                                                                              .data()![
                                                                          "toName"]
                                                                      : controller
                                                                          .conversations[
                                                                              index]
                                                                          .data()!["fromName"],
                                                                  style: GoogleFonts
                                                                      .encodeSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    controller.conversations[index].data()!["lastMessageFrom"] ==
                                                                            FirebaseAuth.instance.currentUser!.uid
                                                                        ? Icon(
                                                                            Icons.reply,
                                                                            color:
                                                                                context.iconColor!.withOpacity(
                                                                              0.7,
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            margin:
                                                                                const EdgeInsets.only(right: 5),
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.blue,
                                                                            ),
                                                                          ),
                                                                    Text(
                                                                      controller
                                                                          .conversations[
                                                                              index]
                                                                          .data()!["lastMessage"],
                                                                      style: GoogleFonts
                                                                          .quicksand(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 5,
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text(
                                          "Mesajınız yoxdur",
                                          style: GoogleFonts.encodeSans(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const InvitePromotion(),
                      const GameRequest(),
                      const LikedYou(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
