// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/JoinPromotionController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinPromotion extends StatefulWidget {
  final String promotionId;
  final List? joinedList;
  final Map<String, dynamic> promotion;
  const JoinPromotion(
      {Key? key,
      required this.promotionId,
      this.joinedList,
      required this.promotion})
      : super(key: key);

  @override
  _JoinPromotionState createState() => _JoinPromotionState();
}

class _JoinPromotionState extends State<JoinPromotion> {
  JoinPromotionController joinPromotionController =
      Get.put(JoinPromotionController());
  ProfilePageController profilePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JoinPromotionController>(builder: (controller) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  // controller: controller.searchController,
                  onChanged: (String value) {
                    controller.delayAction(value);
                  },
                  decoration: InputDecoration(
                    hintText: "İstifadəçi axtar",
                    hintStyle: GoogleFonts.encodeSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: !controller.isSearching
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          return Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.network(
                                                controller.defineUserPhoto(
                                                    controller.users[index]
                                                        ["fromConversation"],
                                                    controller.users[index]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                controller.defineUserName(
                                                    controller.users[index]
                                                        ["fromConversation"],
                                                    controller.users[index]),
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    IgnorePointer(
                                      ignoring: controller.sendLoading,
                                      child: Container(
                                        width: 80,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Material(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          elevation: 2,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () async {
                                              bool active =
                                                  widget.promotion[index]
                                                          ["active"] ??
                                                      false;
                                              int status =
                                                  widget.promotion[index]
                                                          ["startedStatus"] ??
                                                      false;
                                              if (active && status == 1) {
                                                if (!widget.joinedList!
                                                        .contains(controller
                                                                .users[index]
                                                            ["userId"]) &&
                                                    !widget.joinedList!.contains(
                                                        profilePageController
                                                            .meSocial!.id)) {
                                                  controller.sendRequest(
                                                    controller.users[index],
                                                    widget.promotion,
                                                    index,
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                    "Seçdiyiniz istifadəçi artıq bu yarışmaya qoşulub",
                                                    "",
                                                    backgroundColor: Colors.red,
                                                  );
                                                }
                                              } else {
                                                return Get.snackbar(
                                                  "Yarışma aktiv deyil!",
                                                  "",
                                                  backgroundColor: Colors.red,
                                                );
                                              }
                                            },
                                            child: Center(
                                              child: index ==
                                                          controller
                                                              .sendedIndex &&
                                                      controller.sendLoading
                                                  ? const SizedBox(
                                                      width: 32,
                                                      height: 32,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Göndər",
                                                      style: GoogleFonts
                                                          .encodeSans(
                                                        fontSize: 16,
                                                        color: Colors.white,
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
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
