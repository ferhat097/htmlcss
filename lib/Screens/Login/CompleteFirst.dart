// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/CompleteSignUpController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Main.dart';
import 'SetProfilePhotoBottom.dart';

class CompleteFirst extends StatefulWidget {
  final String username;
  final String? photoUrl;
  final String userId;
  final String name;
  const CompleteFirst({
    Key? key,
    required this.username,
    this.photoUrl,
    required this.userId,
    required this.name,
  }) : super(key: key);

  @override
  _CompleteFirstState createState() => _CompleteFirstState();
}

class _CompleteFirstState extends State<CompleteFirst> {
  AuthController authController = Get.find();
  CompleteSignUpController completeSignUpController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSignUpController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Stack(
                    //     children: [
                    //       controller.profilePhoto != null
                    //           ? CircleAvatar(
                    //               radius: 60,
                    //               backgroundImage:
                    //                   FileImage(controller.profilePhoto!),
                    //             )
                    //           : widget.photoUrl != null
                    //               ? CircleAvatar(
                    //                   radius: 60,
                    //                   backgroundImage:
                    //                       NetworkImage(widget.photoUrl!),
                    //                 )
                    //               : CircleAvatar(
                    //                   radius: 60,
                    //                   backgroundColor: Colors.grey[200],
                    //                 ),
                    //       Positioned(
                    //         bottom: 0,
                    //         right: 0,
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.blue,
                    //             borderRadius: BorderRadius.circular(50),
                    //             border: Border.all(
                    //               color: context.theme.canvasColor,
                    //               width: 2,
                    //             ),
                    //           ),
                    //           child: Material(
                    //             borderRadius: BorderRadius.circular(50),
                    //             color: Colors.transparent,
                    //             child: InkWell(
                    //               borderRadius: BorderRadius.circular(50),
                    //               onTap: () {
                    //                 Get.bottomSheet(
                    //                   const SetProfilePhoto(),
                    //                   isScrollControlled: true,
                    //                   backgroundColor:
                    //                       context.theme.canvasColor,
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.only(
                    //                       topLeft: Radius.circular(20),
                    //                       topRight: Radius.circular(20),
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //               child: const Icon(
                    //                 Icons.add,
                    //                 color: Colors.white,
                    //                 size: 30,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Adınız:",
                              style: GoogleFonts.encodeSans(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget.name,
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "İstifadəçi adı:",
                              style: GoogleFonts.encodeSans(),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      controller.setFalse();
                                    },
                                    style: GoogleFonts.quicksand(
                                      color: controller.availableUserName
                                          ? context.iconColor
                                          : Colors.red,
                                    ),
                                    controller: controller.userNameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: controller
                                              .userNameController.text.isEmpty
                                          ? widget.username
                                          : controller.userName,
                                      contentPadding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        context.theme.primaryColor.withRed(220),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Material(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                      onTap: () async {
                                        await authController.checkUserName(
                                          controller.userNameController.text,
                                        );
                                      },
                                      child: controller.progress
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator
                                                  .adaptive(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  context.iconColor,
                                                ),
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.refresh,
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Doğum tarixi:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: controller.birthday != null
                                  ? Colors.green
                                  : context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  await DatePicker.showDatePicker(
                                    context,
                                    onConfirm: (dateTime) {
                                      controller.setBirthday(dateTime);
                                    },
                                  );
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child:
                                            Image.asset("assets/balloons.png"),
                                      ),
                                      Text(
                                        controller.birthday != null
                                            ? "${controller.birthday!.year} - ${controller.birthday!.month} - ${controller.birthday!.day}"
                                            : "Doğum tarixi",
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: controller.birthday != null
                                              ? Colors.white
                                              : context.iconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Cinsiyyət:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.sex == 1
                                          ? Colors.blue
                                          : Colors.blue[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setSex(1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/boy-face.png",
                                                scale: 7,
                                                color: controller.sex == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Kişi",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.sex == 1
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.sex == 2
                                          ? Colors.pink
                                          : Colors.pink[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setSex(2);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/girl-face.png",
                                                scale: 14,
                                                color: controller.sex == 2
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Qadın",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.sex == 2
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Restoran dəvətlərinə gedə bilərəm:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.openInvite == true
                                          ? Colors.green
                                          : Colors.green[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setOpenInvite(true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: controller.openInvite ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Bəli",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller.openInvite ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.openInvite == false
                                          ? Colors.red
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setOpenInvite(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color: controller.openInvite ==
                                                        false
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Xeyr",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller.openInvite ==
                                                              false
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Dəvətlərə şəxsi maşınım ilə gedəcəm:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isPrivateCar == true
                                          ? Colors.green
                                          : Colors.green[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setPrivateCar(true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color:
                                                    controller.isPrivateCar ==
                                                            true
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Bəli",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller.isPrivateCar ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isPrivateCar == false
                                          ? Colors.red
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setPrivateCar(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color:
                                                    controller.isPrivateCar ==
                                                            false
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Xeyr",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      controller.isPrivateCar ==
                                                              false
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Spirtli içki:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isAlcohol == true
                                          ? Colors.green
                                          : Colors.green[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setAlcohol(true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color:
                                                    controller.isAlcohol == true
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Bəzən",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.isAlcohol ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isAlcohol == false
                                          ? Colors.red
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setAlcohol(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color: controller.isAlcohol ==
                                                        false
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "İçmirəm",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.isAlcohol ==
                                                          false
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              "Tütün məhsulları:",
                              style: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isTabacoo == true
                                          ? Colors.green
                                          : Colors.green[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setTabacoo(true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color:
                                                    controller.isTabacoo == true
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Bəzən",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.isTabacoo ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: controller.isTabacoo == false
                                          ? Colors.red
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5),
                                        onTap: () {
                                          controller.setTabacoo(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color: controller.isTabacoo ==
                                                        false
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Xeyr",
                                                style: GoogleFonts.encodeSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: controller.isTabacoo ==
                                                          false
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            GetBuilder<CompleteSignUpController>(
              id: 'complete',
              builder: (controller) {
                return IgnorePointer(
                  ignoring: controller.completeLoading,
                  child: Container(
                    width: double.infinity,
                    color: Colors.green,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          bool available = controller.cCheckErrors();
                          if (available) {
                            await controller.checkUserName(
                              controller.userNameController.text,
                            );

                            if (controller.availableUserName) {
                              completeSignUpController.pageController
                                  .animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            } else {
                              Get.snackbar("İstifadəçi adı mövcuddur", "");
                            }
                          } else {
                            Get.snackbar("Bütün lazımı xanaları doldurun", "");
                          }
                        },
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: controller.completeLoading
                                ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Davam et",
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
