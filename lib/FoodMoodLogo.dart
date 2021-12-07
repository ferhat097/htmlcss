import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget foodMoodLogo() {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 17,
            width: 17,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Icon(Icons.food_bank, color: Colors.white, size: 30),
          Icon(Icons.food_bank, color: Colors.black, size: 28),
        ],
      ),
      Stack(
        children: [
          Text(
            "FoodMood",
            style: GoogleFonts.comfortaa(
              fontSize: 13,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.white,
            ),
          ),
          Text(
            "FoodMood",
            style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 13),
          ),
        ],
      )
    ],
  );
}
