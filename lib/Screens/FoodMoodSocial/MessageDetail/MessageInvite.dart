// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PromotionInvite extends StatefulWidget {
  final Map<String, dynamic> promotion;
  final bool? accepted;
  const PromotionInvite(
      {Key? key, required this.promotion, required this.accepted})
      : super(key: key);

  @override
  _PromotionInviteState createState() => _PromotionInviteState();
}

class _PromotionInviteState extends State<PromotionInvite> {
  @override
  Widget build(BuildContext context) {
    print("ok invite");
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(color: context.theme.primaryColor),
      child: GestureDetector(
        onDoubleTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Material(
                elevation: 5,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor(
                      widget.promotion["color"],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.promotion["promotionName"] ?? "",
                              style: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 10),
                        child: Text(
                          "${widget.promotion["award"]} ${widget.promotion["currency"]}",
                          style: GoogleFonts.encodeSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<MessageDetailController>(
                  id: "timerForInvite",
                  builder: (controller) {
                    Timestamp messageSendedDate = widget.promotion["date"];
                    DateTime sendedDate = messageSendedDate.toDate();
                    Duration compare = DateTime.now().difference(sendedDate);
                    if (widget.accepted ?? false) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onDoubleTap: () {
                            print("double tapped");
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Artıq yarışmadasınız",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset(
                                        "assets/affection.png",
                                        color: context.iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (compare.inSeconds > 60) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onDoubleTap: () {
                            print("double tapped");
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.promotion["from"] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? "Qarşı tərəf qəbul etmədi"
                                    : "Artıq gecdir",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset(
                                        "assets/sad.png",
                                        color: context.iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onDoubleTap: () async {
                            if (widget.promotion["from"] !=
                                FirebaseAuth.instance.currentUser!.uid) {
                              await controller.acceptInvitation(
                                widget.promotion["messageId"],
                                controller.conversation!.id,
                                widget.promotion["promotionId"],
                                widget.promotion["from"],
                              );
                            } else {
                              print("it is you");
                            }
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.promotion["from"] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? "Qəbul olunmağı gözlənilir"
                                    : "Qəbul etmək üçün iki dəfə toxun",
                                style: GoogleFonts.quicksand(fontSize: 16),
                              ),
                              Text(
                                "${60 - compare.inSeconds}",
                                style: GoogleFonts.encodeSans(
                                  color: (60 - compare.inSeconds) < 10
                                      ? Colors.red
                                      : context.iconColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset(
                                        "assets/double-click.png",
                                        color: context.iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
              Container(
                decoration: BoxDecoration(
                  color: HexColor(
                    widget.promotion["color"],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      int sponsorType = widget.promotion["sponsorType"];
                      if (sponsorType == 1) {
                        String restaurantId = widget.promotion["sponsorId"];
                        Get.to(
                            () => RestaurantPage(restaurantId: restaurantId));
                      } else {
                        String userId = widget.promotion["sponsorId"];
                        Get.to(() => UserProfile(userId: userId));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      widget.promotion["sponsorImage"] ?? "",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.promotion["sponsorName"],
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ), //restoran veya sexs
                                Text(
                                  widget.promotion["sponsorSlogan"],
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
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
  }
}
