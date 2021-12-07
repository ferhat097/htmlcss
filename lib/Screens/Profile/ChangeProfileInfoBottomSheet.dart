// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChangeProfileInfoBottomSheet extends StatefulWidget {
  const ChangeProfileInfoBottomSheet({Key? key}) : super(key: key);

  @override
  _ChangeProfileInfoBottomSheetState createState() =>
      _ChangeProfileInfoBottomSheetState();
}

class _ChangeProfileInfoBottomSheetState
    extends State<ChangeProfileInfoBottomSheet> {
  ProfileSettingController profileSettingController =
      Get.put(ProfileSettingController());
  ProfilePageController profilePageController = Get.find();
  @override
  void dispose() {
    Get.delete<ProfileSettingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<ProfileSettingController>(
        id: "profileInfo",
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Profil məlumatlarını dəyiş",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            controller.setChanges();
                          },
                          style: GoogleFonts.quicksand(),
                          controller: controller.nameAndSurnameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "Ad və soyad | ${profilePageController.meSocial?.data()?["name"]}",
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintStyle: GoogleFonts.quicksand(
                              color: context.theme.textTheme.bodyText1!.color!
                                  .withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        decoration:
                            BoxDecoration(color: context.theme.primaryColor),
                        child: TextField(
                          onChanged: (phoneNumber) {
                            controller.setPhoneNumber();
                            controller.setChanges();
                          },
                          controller: controller.phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(
                              RegExp("^[0,1,2,3,4,6,8][1-9]*"),
                            ),
                            LengthLimitingTextInputFormatter(9)
                          ],
                          style: GoogleFonts.quicksand(
                              color: controller.phoneAvailable
                                  ? context.theme.textTheme.bodyText1!.color
                                  : Colors.red),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "Telefon nömrəsi | ${profilePageController.meSocial?.data()?["phoneNumber"]}",
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintStyle: GoogleFonts.quicksand(
                                color: controller.phoneAvailable
                                    ? context.theme.textTheme.bodyText1!.color!
                                        .withOpacity(0.6)
                                    : Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        decoration:
                            BoxDecoration(color: context.theme.primaryColor),
                        child: TextField(
                          controller: controller.userNameController,
                          onChanged: (userName) {
                            controller.setUserName();
                            controller.setChanges();
                          },
                          style: GoogleFonts.quicksand(
                              color: controller.userNameAvailable
                                  ? context.theme.textTheme.bodyText1!.color
                                  : Colors.red),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "İstifadəçi adı | ${profilePageController.meSocial?.data()?["userName"]}",
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintStyle: GoogleFonts.quicksand(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration:
                            BoxDecoration(color: context.theme.primaryColor),
                        width: double.infinity,
                        height: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  theme: DatePickerTheme(
                                    backgroundColor: context.theme.canvasColor,
                                    itemStyle: GoogleFonts.quicksand(
                                        color: context
                                            .theme.textTheme.bodyText1!.color),
                                    cancelStyle: GoogleFonts.quicksand(
                                        color: context
                                            .theme.textTheme.bodyText1!.color),
                                    doneStyle: GoogleFonts.quicksand(
                                        color: Colors.blue),
                                  ),
                                  showTitleActions: true,
                                  minTime: DateTime(1920, 1, 1),
                                  maxTime: DateTime.now(),
                                  onChanged: (date) {}, onConfirm: (date) {
                                profileSettingController.setBirthday(date);
                                controller.setChanges();
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.az);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 8),
                              child: Text(
                                // "",
                                controller.birthday != null
                                    ? "${controller.birthday!.year.toString()}  ${DateFormat('MMM', "az_AZ").format(controller.birthday!)}  ${controller.birthday!.day.toString()}"
                                    : "Doğum tarixi ",
                                style: GoogleFonts.quicksand(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: controller.loadingPr,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: controller.anyChangingProfile
                        ? Colors.green
                        : context.theme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        spreadRadius: 10,
                        color: context.theme.primaryColor,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          String result = await profileSettingController
                              .saveProfileInformation(
                                  profilePageController.meSocial
                                          ?.data()?["birthday"] ??
                                      Timestamp(0, 0),
                                  profilePageController.meSocial!
                                      .data()!["name"],
                                  profilePageController.meSocial!
                                          .data()!["phoneNumber"] ??
                                      "",
                                  profilePageController.meSocial!
                                      .data()!["userName"],
                                  profilePageController.meSocial!.id);
                          if (result == "phone") {
                            Get.snackbar("Bu nömrə artıq istifadə olunub", "");
                          } else if (result == "username") {
                            Get.snackbar(
                                "Bu istifadəçi adı istifadə olunub", "");
                          } else if (result == "phone+username") {
                            Get.snackbar("Nömrə və istifadəçi uyğun deyil", "");
                          } else {
                            Get.back();
                            Get.snackbar("Dəyişikliklər yadda saxlanıldı", "");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: controller.loadingPr
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Yadda Saxla",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
