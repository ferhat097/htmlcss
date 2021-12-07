// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../DarkModeController.dart';

class HastagDetail extends StatefulWidget {
  final Map<String, dynamic> hastag;
  const HastagDetail({Key? key, required this.hastag}) : super(key: key);

  @override
  _HastagDetailState createState() => _HastagDetailState();
}

class _HastagDetailState extends State<HastagDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: defineMainBackgroundColor(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: HexColor(widget.hastag["hastagColor"]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.hashtag,
                    color: HexColor(widget.hastag["textColor"]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.hastag["hastagName"],
                    style: GoogleFonts.comfortaa(
                        color: HexColor(
                          widget.hastag["textColor"],
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          widget.hastag["slogan"] != null
              ? Container(
                  child: Center(
                    child: Text(
                      widget.hastag["slogan"],
                      style: GoogleFonts.quicksand(
                          color: defineWhiteBlack(),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              child: Center(
                child: Text(
                  widget.hastag["infoText"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      color: defineWhiteBlack(),
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
