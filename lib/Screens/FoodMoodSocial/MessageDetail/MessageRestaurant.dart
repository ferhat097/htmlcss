// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../DarkModeController.dart';

class MessageRestaurant extends StatefulWidget {
  final String url;
  final String name;
  final String restaurantId;
  final Timestamp timeStamp;
  const MessageRestaurant(
      {Key? key,
      required this.url,
      required this.name,
      required this.restaurantId,
      required this.timeStamp})
      : super(key: key);

  @override
  _MessageRestaurantState createState() => _MessageRestaurantState();
}

class _MessageRestaurantState extends State<MessageRestaurant> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.timeStamp.toDate();
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(
                () => RestaurantPage(
                  restaurantId: widget.restaurantId,
                ),
                preventDuplicates: false,
                transition: Transition.size,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: CachedNetworkImageProvider(widget.url),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.name,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Baxmaq üçün toxun",
                      style: GoogleFonts.encodeSans(),
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
                            style: GoogleFonts.encodeSans(
                                color: defineWhiteBlack()),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: Colors.blue,
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Center(
                //       child: Text(
                //         "Restorana bax",
                //         style: GoogleFonts.encodeSans(
                //           fontSize: 16,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}
