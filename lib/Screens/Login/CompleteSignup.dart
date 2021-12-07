// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/CompleteSignUpController.dart';
import 'package:foodmood/Screens/Login/CompleteFirst.dart';
import 'package:foodmood/Screens/Login/CompleteSecond.dart';
import 'package:foodmood/Screens/Login/SetProfilePhotoBottom.dart';
import 'package:foodmood/Screens/Main.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteSignUp extends StatefulWidget {
  final String username;
  final String? photoUrl;
  final String userId;
  final String name;
  const CompleteSignUp(
      {Key? key,
      required this.username,
      required this.photoUrl,
      required this.userId,
      required this.name})
      : super(key: key);

  @override
  _CompleteSignUpState createState() => _CompleteSignUpState();
}

class _CompleteSignUpState extends State<CompleteSignUp> {
  CompleteSignUpController completeSignUpController =
      Get.put(CompleteSignUpController());
  @override
  initState() {
    authController.setUserName(widget.username);
    super.initState();
  }

  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: GetBuilder<CompleteSignUpController>(builder: (controller) {
          return AppBar(
            leading: controller.currentPage == 1
                ? InkWell(
                    onTap: () {
                      completeSignUpController.pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: context.iconColor,
                    ),
                  )
                : SizedBox(),
            elevation: 0,
            backgroundColor: context.isDarkMode ? Colors.black45 : Colors.white,
            title: Text(
              "Məlumatları tamamla",
              style: GoogleFonts.quicksand(
                color: context.iconColor,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.close,
                              color: context.iconColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: completeSignUpController.pageController,
        onPageChanged: (page) {
          completeSignUpController.setCurrentPage(page);
        },
        children: [
          CompleteFirst(
            username: widget.username,
            userId: widget.userId,
            photoUrl: widget.photoUrl,
            name: widget.name,
          ),
          CompleteSecond(
            name: widget.name,
            userName: widget.username,
          ),
        ],
      ),
    );
  }
}
