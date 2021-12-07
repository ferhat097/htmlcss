// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/FoodMoodSocialController.dart';
import 'package:foodmood/Controllers/MySendAwayController.dart';
import 'package:foodmood/Screens/FoodMoodSocial/SendAwayFromMe.dart';
import 'package:foodmood/Screens/FoodMoodSocial/SendAwayToMe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MySendAway extends StatefulWidget {
  const MySendAway({Key? key}) : super(key: key);

  @override
  _MySendAwayState createState() => _MySendAwayState();
}

class _MySendAwayState extends State<MySendAway> {
  MySendAwayController mySendAwayController = Get.put(MySendAwayController());
  FoodMoodSocialController foodMoodSocialController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              foodMoodSocialController.pageController.animateToPage(2,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          )
        ],
        title: Text(
          "İsmarla",
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: Container(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: "Mənə",
                  ),
                  Tab(
                    text: "Məndən",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [SendAwayToMe(), SendAwayFromMe()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
