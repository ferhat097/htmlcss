// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../DarkModeController.dart';

class FeatureDetail extends StatefulWidget {
  final Map<String, dynamic> feature;
  final bool exist;
  const FeatureDetail({Key? key, required this.feature, required this.exist})
      : super(key: key);

  @override
  _FeatureDetailState createState() => _FeatureDetailState();
}

class _FeatureDetailState extends State<FeatureDetail> {
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
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: widget.exist ? Colors.green : Colors.grey[200],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: widget.exist ? Colors.white : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              widget.feature["featuresImage"],
                              scale: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.feature["featuresName"],
                        style: GoogleFonts.quicksand(
                            color: widget.exist ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  widget.exist
                      ? const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: FaIcon(
                            FontAwesomeIcons.times,
                            color: Colors.black,
                          ),
                        )
                ],
              ),
            ),
          ),
          widget.exist
              ? Text(
                  widget.feature["existInfo"],
                  style: GoogleFonts.quicksand(
                      color: defineWhiteBlack(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              : Text(
                  widget.feature["noexistInfo"],
                  style: GoogleFonts.quicksand(
                      color: defineWhiteBlack(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
        ],
      ),
    );
  }
}
