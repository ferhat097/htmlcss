// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SetProfilePhoto extends StatefulWidget {
  const SetProfilePhoto({Key? key}) : super(key: key);

  @override
  _SetProfilePhotoState createState() => _SetProfilePhotoState();
}

class _SetProfilePhotoState extends State<SetProfilePhoto> {
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
      child: GetBuilder<AuthController>(
        id: "changephoto",
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
                        "Profil şəklini dəyiş",
                        style: GoogleFonts.quicksand(fontSize: 18),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // if (controller.image != null)
                      //   CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: FileImage(controller.image!),
                      //   )
                      // else
                      //   CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: NetworkImage(
                      //         profilePageController.me!.data()!["userPhoto"]),
                      //   ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await controller.getPhotoFromGallery();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.photo_album),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Telefondan seç",
                                      style:
                                          GoogleFonts.quicksand(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await controller.getPhotoFromCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.camera),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Kameranı aç",
                                      style:
                                          GoogleFonts.quicksand(fontSize: 16),
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
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.green),
                child: SafeArea(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        if (controller.profilePhoto == null) {
                          Get.snackbar(
                            "Şəkil seçilməyib",
                            "Zəhmət olmasa şəkilin seçildiyinə əmin olun. Çətinlik yaranarsa \"FoodMood TM\" Yardım Mərkəzinə bildirin.",
                            duration: const Duration(seconds: 4),
                          );
                        } else {
                          Get.back();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Yadda Saxla",
                            style: GoogleFonts.quicksand(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
