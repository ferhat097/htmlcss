// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../DarkModeController.dart';

class MessageVoice extends StatefulWidget {
  final String url;
  final int seconds;
  final int index;
  final Timestamp timestamp;
  const MessageVoice(
      {Key? key,
      required this.url,
      required this.seconds,
      required this.index,
      required this.timestamp})
      : super(key: key);

  @override
  _MessageVoiceState createState() => _MessageVoiceState();
}

class _MessageVoiceState extends State<MessageVoice> {
  MessageDetailController messageDetailController = Get.find();
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timestamp.toDate();
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (messageDetailController.playedIndex == widget.index &&
                          messageDetailController.isPlaying) {
                        messageDetailController.stopMessage();
                      } else {
                        messageDetailController.playMessage(
                            widget.url, widget.index);
                      }
                    },
                    child:
                        messageDetailController.playedIndex == widget.index &&
                                messageDetailController.isPlaying
                            ? Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 32,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  messageDetailController.defineVoiceDuration(widget.seconds),
                  style: GoogleFonts.encodeSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}
