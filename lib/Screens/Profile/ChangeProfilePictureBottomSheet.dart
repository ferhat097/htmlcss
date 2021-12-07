// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ChangeProfilePictureBottomSheet extends StatefulWidget {
  const ChangeProfilePictureBottomSheet({Key? key}) : super(key: key);

  @override
  _ChangeProfilePictureBottomSheetState createState() =>
      _ChangeProfilePictureBottomSheetState();
}

class _ChangeProfilePictureBottomSheetState
    extends State<ChangeProfilePictureBottomSheet> {
  @override
  dispose() {
    Get.delete<ProfileSettingController>();
    super.dispose();
  }

  ProfilePageController profilePageController = Get.find();
  ProfileSettingController profileSettingController =
      Get.put(ProfileSettingController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: GetBuilder<ProfileSettingController>(
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
                      const SizedBox(
                        height: 10,
                      ),
                      if (controller.image != null)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(controller.image!),
                        )
                      else
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profilePageController
                              .meSocial!
                              .data()!["userPhoto"]),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
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
                                    vertical: 10, horizontal: 8),
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
                                    vertical: 10, horizontal: 8),
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
              IgnorePointer(
                ignoring: controller.downloading,
                child: SafeArea(
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.green),
                    child: SafeArea(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (controller.image == null) {
                              Get.snackbar(
                                "Şəkil seçilməyib",
                                "Zəhmət olmasa şəkilin seçildiyinə əmin olun. Problem yaranarsa \"FoodMood TM\" Yardım Mərkəzinə bildirin.",
                                duration: const Duration(seconds: 4),
                              );
                            } else {
                              await profileSettingController
                                  .saveProfilePicture();
                              Get.back();
                              Get.snackbar("Profil şəkli dəyişdirildi", "");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: controller.downloading
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
