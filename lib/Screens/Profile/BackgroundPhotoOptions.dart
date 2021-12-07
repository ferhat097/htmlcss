// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/BackgroundOptionController.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Profile/BackgroundImagePick.dart';
import 'package:foodmood/Screens/Profile/ChangeBackRestaurant.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ConfirmRestaurant.dart';

class BackgroundPhotoOptions extends StatefulWidget {
  const BackgroundPhotoOptions({Key? key}) : super(key: key);

  @override
  _BackgroundPhotoOptionsState createState() => _BackgroundPhotoOptionsState();
}

class _BackgroundPhotoOptionsState extends State<BackgroundPhotoOptions> {
  GeneralController generalController = Get.find();
  BackgroundOptionController backgroundOptionController =
      Get.put(BackgroundOptionController());
  ProfilePageController profilePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GetBuilder<BackgroundOptionController>(
        builder: (controller) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.iconColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 5,
                  width: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (profilePageController.meSocial!
                      .data()!["specialBackground"] ??
                  false)
                const SizedBox()
              else
                IgnorePointer(
                  ignoring: false,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                        elevation: 5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () async {
                            String restaurantId = profilePageController
                                    .meSocial!
                                    .data()!["backgroundRestaurant"] ??
                                "";
                            if (restaurantId.isEmpty) {
                              Get.snackbar("Xəta baş verdi",
                                  "Xəta davam edərsə bizə yazın");
                            } else {
                              Get.to(
                                () =>
                                    RestaurantPage(restaurantId: restaurantId),
                                transition: Transition.size,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              "Restorana bax",
                              style: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: context.iconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              IgnorePointer(
                ignoring: false,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                      elevation: 5,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          Map<String, dynamic> restaurant =
                              await Get.bottomSheet(
                            const ChangeBackRestaurant(),
                            isScrollControlled: true,
                            backgroundColor: context.theme.canvasColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          );
                          Get.bottomSheet(
                            ConfirmRestaurant(
                              restaurant: restaurant,
                            ),
                            isScrollControlled: true,
                            backgroundColor: context.theme.canvasColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: profilePageController.meSocial!
                                      .data()!["specialBackground"] ??
                                  false
                              ? Text(
                                  "Restoran olaraq dəyiş",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Restoranı dəyiş",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: false,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                      elevation: 5,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          bool firstSet;
                          bool premium = profilePageController.meSocial!
                                  .data()!["premium"] ??
                              false;
                          if (profilePageController.meSocial!
                                  .data()!["specialBackground"] ??
                              false) {
                            firstSet = false;
                          } else {
                            firstSet = true;
                          }
                          if (firstSet) {
                            if (profilePageController.meSocial!
                                    .data()!["moodx"] >=
                                generalController
                                    .financial["specialBackgroundMoodx"]) {
                              Get.bottomSheet(
                                BackgroundImagePick(
                                  firstSet: true,
                                  ispremium: premium,
                                ),
                                isScrollControlled: true,
                                backgroundColor: context.theme.canvasColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              );
                            } else {
                              Get.snackbar(
                                'Hesabınızda lazımı qədər MoodX yoxdur!',
                                "MoodX qazanmaq üçün reklam izləyə vəya yarışmalara qatıla bilərsiniz!",
                              );
                            }
                          } else {
                            Get.bottomSheet(
                              BackgroundImagePick(
                                firstSet: false,
                                ispremium: premium,
                              ),
                              isScrollControlled: true,
                              backgroundColor: context.theme.canvasColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset("assets/premium.png"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                profilePageController.meSocial!
                                            .data()!["specialBackground"] ??
                                        false
                                    ? "Özəl şəkili dəyiş"
                                    : "Özəl şəkil əlavə et",
                                style: GoogleFonts.encodeSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (profilePageController.meSocial!
                      .data()!["specialBackground"] ??
                  false)
                const SizedBox()
              else
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Özəlləşdirmə dəyəri - ",
                        style: GoogleFonts.quicksand(
                          color: context.iconColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${generalController.financial["specialBackgroundMoodx"]} MoodX",
                        style: GoogleFonts.quicksand(
                          color: context.iconColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                "Premium hesabda arxa fon şəklini dəyişdirmək pulsuzdur!",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              )
            ],
          );
        },
      ),
    );
  }
}
