// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../DarkModeController.dart';

class MessageGift extends StatefulWidget {
  final Map<String, dynamic> message;
  final Timestamp timeStamp;
  final String from;
  const MessageGift(
      {Key? key,
      required this.message,
      required this.timeStamp,
      required this.from})
      : super(key: key);

  @override
  _MessageGiftState createState() => _MessageGiftState();
}

class _MessageGiftState extends State<MessageGift> {
  MessageDetailController messageDetailController = Get.find();
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timeStamp.toDate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onDoubleTap: () async {
            print(widget.from);
            print(widget.message);
            if (widget.from != FirebaseAuth.instance.currentUser!.uid &&
                widget.message["accepted"] == false) {
              ///doo
              await messageDetailController.acceptGift(
                widget.message["conversationId"],
                widget.message["messageId"] ?? "",
                widget.message["earnedMoodx"],
              );
            }
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              widget.message["image"],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.double_arrow,
                size: 16,
                color: context.iconColor!.withOpacity(0.5),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${dateTime.hour.toString()} : ${dateTime.minute.toString()}",
                style: GoogleFonts.encodeSans(color: defineWhiteBlack()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
