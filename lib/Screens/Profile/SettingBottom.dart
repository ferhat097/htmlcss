// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/MainController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:foodmood/Screens/Profile/BlockedUsers.dart';
import 'package:foodmood/Screens/Profile/ChangeProfileInfoBottomSheet.dart';
import 'package:foodmood/Screens/Profile/FoodMoodHelpCenter.dart';
import 'package:foodmood/Screens/Profile/FoodMoodSocialSettingsBottomSheet.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    Get.delete<ProfileSettingController>();
    super.dispose();
  }

  ProfilePageController profilePageController = Get.find();
  ProfileSettingController profileSettingController =
      Get.put(ProfileSettingController());
  MainController mainController = Get.find();
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    print(context.isDarkMode);
    return GetBuilder<ProfilePageController>(
      builder: (controller) {
        return Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: profileSettingController.manualIsDark.value
                  ? Colors.grey[900]
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          mainController.changeTheme();
                          profileSettingController.manualIsDark.value =
                              !profileSettingController.manualIsDark.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                profileSettingController.manualIsDark.value
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              Text(
                                profileSettingController.manualIsDark.value
                                    ? "Gecə Modu"
                                    : "Gündüz Modu",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (authController.activeInternet) {
                            Get.back();
                            Get.bottomSheet(
                              const ChangeProfileInfoBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar(
                              "Internet bağlantısı yoxdur!",
                              "Cihazınızın internetə bağlı olduğuna əmin olun.",
                              backgroundColor: Colors.red.withOpacity(0.8),
                              borderRadius: 5,
                              dismissDirection:
                                  SnackDismissDirection.HORIZONTAL,
                              snackStyle: SnackStyle.FLOATING,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userEdit,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Profil məlumatlarını dəyiş",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (authController.activeInternet) {
                            Get.back();
                            Get.bottomSheet(
                              const FoodMoodSocialSettingBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar(
                              "Internet bağlantısı yoxdur!",
                              "Cihazınızın internetə bağlı olduğuna əmin olun.",
                              backgroundColor: Colors.red.withOpacity(0.8),
                              borderRadius: 5,
                              dismissDirection:
                                  SnackDismissDirection.HORIZONTAL,
                              snackStyle: SnackStyle.FLOATING,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.icons,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "\"FoodMood\" Social ayarları",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.questionCircle,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "\"FoodMood\" - dan necə istifadə edim?",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (authController.activeInternet) {
                            Get.back();
                            Get.bottomSheet(
                              const FoodMoodHelpCenter(),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar(
                              "Internet bağlantısı yoxdur!",
                              "Cihazınızın internetə bağlı olduğuna əmin olun.",
                              backgroundColor: Colors.red.withOpacity(0.8),
                              borderRadius: 5,
                              dismissDirection:
                                  SnackDismissDirection.HORIZONTAL,
                              snackStyle: SnackStyle.FLOATING,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.handsHelping,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "\"FoodMood\" Yardım Mərkəzi",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: profileSettingController.manualIsDark.value
                          ? Colors.black87
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          if (authController.activeInternet) {
                            Get.back();
                            Get.bottomSheet(
                              BlockedUsers(
                                userList: controller.meSocial!
                                        .data()!["blockedUsers"] ??
                                    [],
                              ),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            );
                          } else {
                            Get.snackbar(
                              "Internet bağlantısı yoxdur!",
                              "Cihazınızın internetə bağlı olduğuna əmin olun.",
                              backgroundColor: Colors.red.withOpacity(0.8),
                              borderRadius: 5,
                              dismissDirection:
                                  SnackDismissDirection.HORIZONTAL,
                              snackStyle: SnackStyle.FLOATING,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userAltSlash,
                                color:
                                    profileSettingController.manualIsDark.value
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Blok olunmuş istifadəçilər",
                                style: GoogleFonts.quicksand(
                                  color: profileSettingController
                                          .manualIsDark.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GetBuilder<AuthController>(
                    id: "logoutButton",
                    builder: (controller) {
                      return IgnorePointer(
                        ignoring: controller.loadingLogout,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: profileSettingController.manualIsDark.value
                                ? Colors.black87
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await authController.logout();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (controller.loadingLogout)
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    else
                                      FaIcon(
                                        FontAwesomeIcons.signOutAlt,
                                        color: profileSettingController
                                                .manualIsDark.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Çıxış",
                                      style: GoogleFonts.quicksand(
                                        color: profileSettingController
                                                .manualIsDark.value
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
