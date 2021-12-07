// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Screens/Login/LoginSplash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginNeeded extends StatefulWidget {
  const LoginNeeded({Key? key}) : super(key: key);

  @override
  _LoginNeededState createState() => _LoginNeededState();
}

class _LoginNeededState extends State<LoginNeeded> {
  GeneralController generalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              "assets/graffiti-heart-shape.png",
              color: Colors.pink,
            ),
          ),
          Text(
            generalController.foodSocial["loginText"],
            style: GoogleFonts.quicksand(),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink),
            ),
            onPressed: () {
              Get.to(() => const LoginSplash());
            },
            child: Text(
              "Qeydiyyatdan keç vəya daxil ol",
              style: GoogleFonts.encodeSans(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
