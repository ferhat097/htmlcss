// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../DarkModeController.dart';

class MessageText extends StatefulWidget {
  final String message;
  final Timestamp timestamp;
  const MessageText({Key? key, required this.message, required this.timestamp})
      : super(key: key);

  @override
  _MessageTextState createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timestamp.toDate();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.message,
          style: GoogleFonts.quicksand(color: defineWhiteBlack(), fontSize: 16),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                // snapshot.data!.docs[index]
                //             .data()[
                //         "fromRestaurant"]
                //     ? snapshot
                //             .data!.docs[index]
                //             .data()["readed"]
                //         ? Icons.done_all
                //: Icons.done:
                Icons.double_arrow,
                size: 16,
                color: context.iconColor!.withOpacity(0.5),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${dateTime.hour.toString()} : ${dateTime.minute.toString()}",
                style: GoogleFonts.encodeSans(color: defineWhiteBlack()),
              ),
            ],
          ),
        )
      ],
    );
  }
}
