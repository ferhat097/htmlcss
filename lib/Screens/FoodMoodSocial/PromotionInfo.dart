// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionInfo extends StatefulWidget {
  final Map<String, dynamic> promotion;
  const PromotionInfo({Key? key, required this.promotion}) : super(key: key);

  @override
  _PromotionInfoState createState() => _PromotionInfoState();
}

class _PromotionInfoState extends State<PromotionInfo> {
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: context.iconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 5,
              width: 40,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.promotion["promotionInfo"],
              style: GoogleFonts.quicksand(
                color: context.iconColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Yarışmanın növü: ",
                      style: GoogleFonts.encodeSans(
                        color: context.iconColor,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: widget.promotion["awardIsCash"]
                          ? "Nağd"
                          : "Restoranda xərcləmə",
                      style: GoogleFonts.encodeSans(
                        color: context.iconColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (widget.promotion["awardIsMoodx"] ?? false)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 5,
              ),
              child: Text(
                "${widget.promotion["award"]} MoodX = ${(widget.promotion["award"] / generalController.financial["moodx"] * generalController.financial["cash"])} AZN",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
        ],
      ),
    );
  }
}
