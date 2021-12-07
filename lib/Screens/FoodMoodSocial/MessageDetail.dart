// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:foodmood/Screens/FoodMoodSocial/ReportMessageBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../DarkModeController.dart';
import 'MessageDetail/MessageText.dart';
import 'SendGiftBottom.dart';

class MessageDetail extends StatefulWidget {
  final String? conversationId;
  final String? userId;
  final bool withConversation;
  final Map<String, dynamic>? user;
  const MessageDetail(
      {Key? key,
      this.conversationId,
      required this.withConversation,
      this.user,
      @required this.userId})
      : super(key: key);

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  @override
  void dispose() {
    Get.delete<MessageDetailController>(force: true);
    super.dispose();
  }

  @override
  initState() {
    if (widget.withConversation) {
      messageDetailController.setWithConversation(widget.conversationId!);
    } else {
      messageDetailController.listenUser(widget.userId!);
      messageDetailController.setWithoutConversation(
        widget.userId!,
        widget.user!,
      );
    }

    super.initState();
  }

  MessageDetailController messageDetailController = Get.put(
    MessageDetailController(),
  );
  ProfilePageController profilePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: defineWhiteBlack(),
        ),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        title: GetBuilder<MessageDetailController>(
          builder: (controller) {
            if (controller.user != null &&
                controller.conversation != null &&
                controller.presenceModel != null) {
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              Get.to(
                                () => UserProfile(
                                  userId: controller.user!.data()!["userId"],
                                ),
                                transition: Transition.size,
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  controller.user!.data()!["userPhoto"] ?? ""),
                              radius: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GetBuilder<ProfilePageController>(
                            id: "messageDetailPage",
                            builder: (controllerProfile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.user!.data()!["name"] ?? "",
                                    style: GoogleFonts.encodeSans(
                                        fontSize: 16,
                                        color: defineWhiteBlack(),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  !profilePageController.meSocial!
                                          .data()!["blockedUsers"]
                                          .contains(
                                              messageDetailController.user!.id)
                                      ? Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .presenceIndicatorColor(
                                                  controller.conversation!
                                                                  .data()![
                                                              "from"] ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? controller.conversation!
                                                          .data()!["onlineTo"]
                                                      : controller.conversation!
                                                              .data()![
                                                          "onlineFrom"],
                                                  controller
                                                      .presenceModel!.online,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            Text(
                                              controller.presence(
                                                controller.presenceModel!.date,
                                                controller
                                                    .presenceModel!.online,
                                                (controller.conversation!
                                                            .data()!["from"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)
                                                    ? controller.conversation!
                                                        .data()!["lastOnlineTo"]
                                                    : controller.conversation!
                                                            .data()![
                                                        "lastOnlineFrom"],
                                                (controller.conversation!
                                                            .data()!["from"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)
                                                    ? controller.conversation!
                                                        .data()!["onlineTo"]
                                                    : controller.conversation!
                                                        .data()!["onlineFrom"],
                                              ),
                                              style: GoogleFonts.encodeSans(
                                                fontSize: 14,
                                                color: defineWhiteBlack(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                  if (messageDetailController.user != null)
                    GetBuilder<ProfilePageController>(
                      builder: (controllerProfile) {
                        return FocusedMenuHolder(
                          openWithTap: true,
                          menuBoxDecoration: BoxDecoration(
                            color: context.theme.canvasColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          menuItems: [
                            if (!controller.conversation!.data()!["accepted"] &&
                                controller.conversation!.data()!["from"] !=
                                    FirebaseAuth.instance.currentUser!.uid)
                              FocusedMenuItem(
                                backgroundColor: context.theme.primaryColor,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Yazışmaya icazə ver",
                                      style: GoogleFonts.quicksand(
                                        color: context.iconColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailingIcon: const Icon(
                                  Icons.health_and_safety,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  controller.acceptConversation();
                                },
                              ),
                            if (!controller.user!
                                .data()!["blockedUsers"]
                                .contains(
                                    controller.firebaseAuth.currentUser!.uid))
                              FocusedMenuItem(
                                backgroundColor: context.theme.primaryColor,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      (controller.conversation!
                                                      .data()!["from"] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? controller.conversation!
                                                  .data()!["onlineFrom"]
                                              : controller.conversation!
                                                  .data()!["onlineTo"])
                                          ? "Xətdə olmanı gizlət"
                                          : "Xətdə olmanı göstər",
                                      style: GoogleFonts.quicksand(
                                        color: context.iconColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    // Container(
                                    //   margin: const EdgeInsets.only(left: 15),
                                    //   height: 20,
                                    //   width: 20,
                                    //   decoration: BoxDecoration(
                                    //     color: ((controller.conversation!
                                    //                     .data()!["from"] ==
                                    //                 FirebaseAuth.instance
                                    //                     .currentUser!.uid)
                                    //             ? controller.conversation!
                                    //                 .data()!["onlineFrom"]
                                    //             : controller.conversation!
                                    //                 .data()!["onlineTo"])
                                    //         ? Colors.green
                                    //         : Colors.yellow,
                                    //     borderRadius: BorderRadius.circular(100),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                trailingIcon: Icon(
                                  Icons.adjust_rounded,
                                  color: ((controller.conversation!
                                                  .data()!["from"] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? controller.conversation!
                                              .data()!["onlineFrom"]
                                          : controller.conversation!
                                              .data()!["onlineTo"])
                                      ? Colors.green
                                      : Colors.yellowAccent,
                                ),
                                onPressed: () async {
                                  controller.setOnline();
                                },
                              ),
                            if (!controller.user!
                                .data()!["blockedUsers"]
                                .contains(
                                    controller.firebaseAuth.currentUser!.uid))
                              FocusedMenuItem(
                                backgroundColor: context.theme.primaryColor,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      (controller.conversation!
                                                      .data()!["from"] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? controller.conversation!
                                                  .data()!["lastOnlineFrom"]
                                              : controller.conversation!
                                                  .data()!["lastOnlineTo"])
                                          ? "Son görülmə tarixini gizlət"
                                          : "Son görülmə tarixini göstər",
                                      style: GoogleFonts.quicksand(
                                        color: context.iconColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailingIcon: Icon(
                                  Icons.adjust_rounded,
                                  color: ((controller.conversation!
                                                  .data()!["from"] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? controller.conversation!
                                              .data()!["lastOnlineFrom"]
                                          : controller.conversation!
                                              .data()!["lastOnlineTo"])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                onPressed: () async {
                                  controller.setLastSeen();
                                },
                              ),
                            FocusedMenuItem(
                              backgroundColor: context.theme.primaryColor,
                              title: Text(
                                profilePageController.meSocial!
                                        .data()!["blockedUsers"]
                                        .contains(
                                            messageDetailController.user!.id)
                                    ? "Blokdan çıxart"
                                    : "Blok et",
                                style: GoogleFonts.quicksand(
                                    color: defineWhiteBlack()),
                              ),
                              onPressed: () {
                                if (profilePageController.meSocial!
                                    .data()!["blockedUsers"]
                                    .contains(
                                        messageDetailController.user!.id)) {
                                  messageDetailController.blockUser(
                                      messageDetailController.user!.id, false);
                                } else {
                                  messageDetailController.blockUser(
                                      messageDetailController.user!.id, true);
                                }
                              },
                            ),
                            if (!controller.user!
                                .data()!["blockedUsers"]
                                .contains(
                                    controller.firebaseAuth.currentUser!.uid))
                              FocusedMenuItem(
                                backgroundColor: context.theme.primaryColor,
                                title: Text(
                                  "Söhbəti sil",
                                  style: GoogleFonts.quicksand(
                                      color: defineWhiteBlack()),
                                ),
                                onPressed: () async {
                                  await controller
                                      .deleteChat(controller.conversationId!);
                                  Get.back();
                                },
                              ),
                            FocusedMenuItem(
                              backgroundColor: context.theme.errorColor,
                              title: Text(
                                "Şikayət et",
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                Get.bottomSheet(
                                    ReportMessageBottomSheet(
                                      conversationId:
                                          controller.conversationId!,
                                      reportedUserId:
                                          messageDetailController.user!.id,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: context.theme.canvasColor,
                                    isScrollControlled: true);
                              },
                            ),
                          ],
                          onPressed: () {},
                          child: const Icon(
                            Icons.more_horiz_rounded,
                          ),
                        );
                      },
                    ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      body: GetBuilder<MessageDetailController>(
        builder: (controller) {
          if (controller.user != null) {
            if (controller.user!
                .data()!["blockedUsers"]
                .contains(controller.firebaseAuth.currentUser!.uid)) {
              return const Center(
                child: Text("İstifadəçi sizi blok edib"),
              );
            } else {
              if (controller.start) {
                if (controller.conversation!.data()!["deleted"]) {
                  return const Center(
                    child: Text("Bu mesajlaşma silindi"),
                  );
                } else {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.loadMessages().asBroadcastStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty &&
                            !controller.defineAvailable(controller.user!.id)) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "${controller.user!.data()!["name"]} ilə mesajlaşmaq üçün ona hədiyyə göndər",
                                  style: GoogleFonts.encodeSans(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      SendGiftBottom(
                                        fromConversation: true,
                                        userOrConversationId:
                                            controller.conversation!.id,
                                        token:
                                            controller.user!.data()!["token"] ??
                                                "",
                                        toName:
                                            controller.user!.data()!["name"] ??
                                                "",
                                      ),
                                      isScrollControlled: true,
                                      backgroundColor:
                                          context.theme.canvasColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Hədiyyə göndər",
                                      style: GoogleFonts.encodeSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: ListView.builder(
                                    //key: controller.animatedListKey,
                                    reverse: true,
                                    controller: messageDetailController
                                        .scrollController,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    // separatorBuilder: (context, index) {
                                    //   return const SizedBox(
                                    //     height: 0,
                                    //   );
                                    // },
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Column(
                                          children: [
                                            LimitedBox(
                                              maxWidth: 150,
                                              child: Container(
                                                alignment: snapshot
                                                            .data!.docs[index]
                                                            .data()["from"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: FocusedMenuHolder(
                                                  menuBoxDecoration:
                                                      BoxDecoration(
                                                    color: context
                                                        .theme.canvasColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  menuWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5,
                                                  bottomOffsetHeight: 5,
                                                  menuOffset: 5,
                                                  onPressed: () {},
                                                  menuItems: [
                                                    if (snapshot
                                                            .data!.docs[index]
                                                            .data()["from"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)
                                                      FocusedMenuItem(
                                                        backgroundColor: context
                                                            .theme.primaryColor,
                                                        title: Text(
                                                          "Mesajı sil",
                                                          style: GoogleFonts
                                                              .encodeSans(),
                                                        ),
                                                        onPressed: () {
                                                          controller
                                                              .deleteMessage(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id);
                                                        },
                                                      )
                                                  ],
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: controller
                                                              .defineType3Color(
                                                        snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                "messageType"] ??
                                                            1,
                                                        snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                "accepted"] ??
                                                            false,
                                                      )
                                                          ? Colors.green[100]
                                                          : defineTextFieldColor(),
                                                    ),
                                                    child: LimitedBox(
                                                      maxWidth: 120,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: controller
                                                            .defineMessage(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data(),
                                                          index,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (snapshot.data!.docs[index]
                                                            .data()[
                                                        "messageType"] ==
                                                    3 &&
                                                snapshot.data!.docs[index]
                                                        .data()["from"] !=
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid &&
                                                !snapshot.data!.docs[index]
                                                    .data()["accepted"])
                                              Container(
                                                alignment: snapshot
                                                            .data!.docs[index]
                                                            .data()["from"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Qəbul etmək üçün iki dəfə toxun",
                                                    style:
                                                        GoogleFonts.encodeSans(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              GetBuilder<ProfilePageController>(
                                builder: (controller) {
                                  if (controller.meSocial!
                                      .data()!["blockedUsers"]
                                      .contains(
                                          messageDetailController.user!.id)) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: context.theme.primaryColor),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () {
                                              messageDetailController.blockUser(
                                                  messageDetailController
                                                      .user!.id,
                                                  false);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  "İstifadəçi blok olunub \n Blokdan çıxartmaq üçün toxunun",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      GoogleFonts.quicksand(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? Colors.black45
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                if (controller
                                                    .mRecorder!.isRecording)
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: Row(
                                                        children: [
                                                          GetBuilder<
                                                              MessageDetailController>(
                                                            id: "time",
                                                            builder:
                                                                (controller3) {
                                                              return SizedBox(
                                                                width: 100,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child: Center(
                                                                    child: Text(
                                                                      controller3
                                                                          .defineVoiceDuration(
                                                                              controller3.time),
                                                                      style: GoogleFonts
                                                                          .encodeSans(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  5,
                                                                ),
                                                              ),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  controller.deleteRecord(
                                                                      controller
                                                                          .mPath);
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Silmək üçün toxun",
                                                                      style: GoogleFonts
                                                                          .encodeSans(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Expanded(
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                        color:
                                                            defineTextFieldColor(),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            messageDetailController
                                                                .messageController,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Mesajınız",
                                                          hintStyle: GoogleFonts
                                                              .quicksand(
                                                            color:
                                                                defineWhiteBlack(),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                            top: 10,
                                                            bottom: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                // const SizedBox(
                                                //   width: 5,
                                                // ),
                                                // Container(
                                                //   height: 40,
                                                //   width: 40,
                                                //   decoration: BoxDecoration(
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             20),
                                                //     color: Colors.blue[600],
                                                //   ),
                                                //   child: GestureDetector(
                                                //     onTap: () {
                                                //       if (controller.recorded) {
                                                //         controller.stopRecord();
                                                //       } else {
                                                //         controller
                                                //             .startRecord();
                                                //       }
                                                //     },
                                                //     child: controller.recorded
                                                //         ? const Icon(
                                                //             Icons.stop,
                                                //             color: Colors.white,
                                                //           )
                                                //         : const Icon(
                                                //             Icons.mic,
                                                //             color: Colors.white,
                                                //           ),
                                                //   ),
                                                // ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                messageDetailController.wait
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.blue[600],
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(
                                                          left: 10,
                                                          right: 10,
                                                        ),
                                                        width: 50,
                                                        height: 50,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Colors.white,
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.blue[600],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                        ),
                                                        height: 50,
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            onTap: () {
                                                              if (controller
                                                                  .messageController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                if (!controller
                                                                    .wait) {
                                                                  messageDetailController
                                                                      .sendMessage();
                                                                }
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 10,
                                                              ),
                                                              child:
                                                                  Image.asset(
                                                                "assets/send.png",
                                                                scale: 12,
                                                                color: Colors
                                                                    .white,
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
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                }
              } else {
                return const SizedBox();
              }
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
