// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/MoodXBottomController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Profile/MoodXPayBottom.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MoodXBottom extends StatefulWidget {
  const MoodXBottom({Key? key}) : super(key: key);

  @override
  _MoodXBottomState createState() => _MoodXBottomState();
}

class _MoodXBottomState extends State<MoodXBottom> {
  ProfilePageController profilePageController = Get.find();

  @override
  void dispose() {
    if (mounted) {
      Get.delete<MoodXBottomController>();
    }

    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      MoodXBottomController moodXBottomController =
          Get.put(MoodXBottomController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePageController>(
      builder: (controller) {
        return GetBuilder<MoodXBottomController>(
          builder: (controller2) {
            return GetBuilder<GeneralController>(builder: (generalController) {
              return SizedBox(
                height: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "MoodX hesabım:",
                              style: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${controller.meSocial!.data()!["moodx"]}",
                              style: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: controller2.adsLoading,
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
                                await controller2.getADS(generalController
                                    .financial["dailyAdsLimit"]);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller2.adsLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Image.asset(
                                            "assets/advertisements.png",
                                            color: Colors.white,
                                            scale: 14,
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "+${generalController.financial["adsAward"]} MoodX",
                                      style: GoogleFonts.encodeSans(
                                        fontWeight: FontWeight.normal,
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
                    GestureDetector(
                      onTap: () {
                        //   GetStorage().write("moodxTime", 0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Günlük limit: ",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: context.iconColor,
                              ),
                            ),
                            Text(
                              "${controller2.moodxTime}/${generalController.financial["dailyAdsLimit"]}",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: context.iconColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: controller2.loadingPremium,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Material(
                            color: const Color(0xFFe1ad21),
                            borderRadius: BorderRadius.circular(5),
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                int moodx =
                                    controller.meSocial!.data()!["moodx"];
                                bool premium =
                                    controller.meSocial!.data()!["premium"] ??
                                        false;
                                if (premium) {
                                  Timestamp premiumDate = controller.meSocial!
                                      .data()!["premiumDate"];
                                  DateTime premiumDateTime =
                                      premiumDate.toDate();
                                  int day = DateTime.now()
                                      .difference(premiumDateTime)
                                      .inDays;
                                  return Get.snackbar(
                                    "Siz artıq premium hesabındasınız",
                                    "Bitməsinə ${(generalController.financial["premiumAccountDuration"] - day) * 1} gün qalıb",
                                  );
                                } else {
                                  if (moodx >= 1000) {
                                    await controller2.getPremium(
                                      controller.meSocial!.id,
                                      generalController
                                          .financial["premiumCost"],
                                    );
                                    Get.snackbar(
                                      "Siz Premium hesabına keçdiniz",
                                      "Premium hesab ${generalController.financial["premiumAccountDuration"]} gün davam edəcək",
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Hesabınızda kifayət qədər MoodX yoxdur",
                                      "Premium olmaq üçün hesabınızda ən az ${generalController.financial["premiumCost"]} moodx olmalıdır",
                                    );
                                  }
                                }
                              },
                              child: Center(
                                child: controller.meSocial!
                                            .data()!["premium"] ??
                                        false
                                    ? Text(
                                        "Siz premium hesabdasınız",
                                        style: GoogleFonts.encodeSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    : controller2.loadingPremium
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Premium ol",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                " - ${generalController.financial["premiumCost"]} MX",
                                                style: GoogleFonts.encodeSans(
                                                  fontWeight: FontWeight.normal,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Premium hesabın müddəti: ",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: context.iconColor,
                            ),
                          ),
                          Text(
                            "${generalController.financial["premiumAccountDuration"]} gün",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.iconColor,
                            ),
                          )
                        ],
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                if ((controller.meSocial!.data()!["moodx"] *
                                        generalController.financial["cash"] /
                                        generalController.financial["moodx"]) >=
                                    (generalController
                                        .financial["minMoodxPay"])) {
                                  Get.bottomSheet(
                                    MoodXPay(),
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
                                      "Hesabınızda lazımı qədər Moodx yoxdur!",
                                      "Hesabınızıdakı Moodx - ləri nağdlaşdırmaq üçün minumum nağdlaşdırma məbləğindən çox olmalıdır",
                                      backgroundColor: Colors.red);
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Hesabdan çıxarış",
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Dəyişmə dəyəri: ",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      color: context.iconColor,
                                    )),
                                TextSpan(
                                  text:
                                      "${generalController.financial["moodx"]} MoodX = ${generalController.financial["cash"]} AZN",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Minumum çıxarış məbləği: ",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${generalController.financial["minMoodxPay"] ?? 10} AZN",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " = ${(generalController.financial["minMoodxPay"] / generalController.financial["cash"] * generalController.financial["moodx"]).toStringAsFixed(0)} Moodx",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "MoodX - AZN məzənnəsi dəyişkəndir. ",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "Anlıq və müvəqqəti dəyişə bilər. ",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "İrəliləyən zamanlarda istifadəçi sayında artım və istifadə imkanlarının genişlənməsi ilə əlaqədar MoodX-in dəyər qazanması gözlənilir. ",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Moodx - in dəyişmə aralığının ətraflı qrafiki tezliklə təqdim olunacaq.",
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: context.iconColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }
}
