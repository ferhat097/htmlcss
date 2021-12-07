// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:foodmood/Screens/Login/CompleteSignup.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodMoodSocialSettingBottomSheet extends StatefulWidget {
  const FoodMoodSocialSettingBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _FoodMoodSocialSettingBottomSheetState createState() =>
      _FoodMoodSocialSettingBottomSheetState();
}

class _FoodMoodSocialSettingBottomSheetState
    extends State<FoodMoodSocialSettingBottomSheet> {
  ProfileSettingController profileSettingController =
      Get.put(ProfileSettingController());
  ProfilePageController profilePageController = Get.find();

  @override
  void dispose() {
    Get.delete<ProfileSettingController>();
    super.dispose();
  }

  @override
  void initState() {
    profileSettingController.loadFoodMoodSocialSettings(
      profilePageController.meSocial!.data()?["foodMoodSocial"],
      profilePageController.meSocial!.data()?["issendaway"],
      profilePageController.meSocial!.data()?["isMessaging"],
      profilePageController.meSocial!.data()?["showOnline"] ?? false,
      profilePageController.meSocial!.data()?["showLastSeen"] ?? false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<ProfilePageController>(
        builder: (controller2) {
          profileSettingController.loadFoodMoodSocialSettings(
            profilePageController.meSocial!.data()?["foodMoodSocial"],
            profilePageController.meSocial!.data()?["issendaway"],
            profilePageController.meSocial!.data()?["isMessaging"],
            profilePageController.meSocial!.data()?["showOnline"] ?? false,
            profilePageController.meSocial!.data()?["showLastSeen"] ?? false,
          );
          print("resetted");
          return GetBuilder<ProfileSettingController>(
            id: "foodmoodsetting",
            builder: (controller) {
              if (controller.messaging != null &&
                  controller.foodMoodSocial != null &&
                  controller.sendaway != null) {
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
                              "FoodMood Social ayarları",
                              style: GoogleFonts.quicksand(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "FoodMood Social deaktiv olunduğu zaman siz FoodMood Social səhifəsində istifadəçilər tərəfindən görülməyəcəksiniz.",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "FoodMood Social",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch.adaptive(
                                        value: controller.foodMoodSocial!,
                                        onChanged: (value) {
                                          if (value) {
                                            controller
                                                .changeFoodMoodSocial(value);
                                          } else {
                                            controller
                                                .changeFoodMoodSocial(value);
                                            controller.changesendaway(value);
                                            controller.changeMessaging(value);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!controller2.meSocial!.data()!["allFilled"] &&
                                controller.foodMoodSocial!)
                              Material(
                                elevation: 5,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.red[200],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.off(
                                          () => CompleteSignUp(
                                            username: controller2.meSocial!
                                                .data()!["userName"],
                                            photoUrl: controller2.meSocial!
                                                .data()!["userPhoto"],
                                            userId: controller2.meSocial!
                                                .data()!["userId"],
                                            name: controller2.meSocial!
                                                .data()!["name"],
                                          ),
                                          preventDuplicates: false,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "FoodMood Social məlumatlarını tamamla",
                                          style: GoogleFonts.encodeSans(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "Dəvət deaktiv olunduğu zaman sizə heçkim yarışmaya dəvət göndərə bilməyəcək.",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dəvət",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch.adaptive(
                                        value: controller.sendaway!,
                                        onChanged: (value) {
                                          if (value) {
                                            if (controller.foodMoodSocial!) {
                                              controller.changesendaway(value);
                                            } else {
                                              Get.snackbar(
                                                  "FoodMood Social aktiv olmalıdır",
                                                  "");
                                            }
                                          } else {
                                            controller.changesendaway(value);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "Aktiv olduğu zaman profil səhifənizdə 'Mesaj yaz' düyməsi görüləcək",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Mesajlaşma",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch.adaptive(
                                        value: controller.messaging!,
                                        onChanged: (value) {
                                          if (value) {
                                            if (controller.foodMoodSocial!) {
                                              controller.changeMessaging(value);
                                            } else {
                                              Get.snackbar(
                                                  "FoodMood Social aktiv olmalıdır",
                                                  "");
                                            }
                                          } else {
                                            controller.changeMessaging(value);
                                          }
                                          //controller.changeMessaging(value);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "Xətdə görülmə aktiv olduğu zaman siz tətbiqin daxilində olduqda profil şəklinizin ətrafında yaşıl dairə yaranacaq. Əlavə olaraq bu dəyişiklikdən yeni mesaj yazarkən vəya sizə mesaj yazılan zaman standart olaraq tətbiq olunacaq. Unutmayın ki, istədiyiniz zaman mesajlaşmalarda xəttə olma göstəricisini hər mesajlaşmaya özəl olaraq dəyişdirə bilərsiniz.",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "'Xətdə' görülməsi",
                                        style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Switch.adaptive(
                                        value: controller.showOnline!,
                                        onChanged: (value) {
                                          if (value) {
                                            if (controller.foodMoodSocial!) {
                                              controller
                                                  .changeShowOnline(value);
                                            } else {
                                              Get.snackbar(
                                                "FoodMood Social aktiv olmalıdır",
                                                "",
                                              );
                                            }
                                          } else {
                                            controller.changeShowOnline(value);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Text(
                                    "Sizə mesaj yazılarsa və ya siz mesaj yazdıqda son görülmə aşağıdakı kimi olacaq. Əlavə olaraq istənilən zaman hər mesajlaşmada bu ayarları mesajlaşmaya özəl olaraq dəyişdirə bilərsiniz.",
                                    style: GoogleFonts.quicksand(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Mesajlarda 'Son görülmə'",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch.adaptive(
                                        value: controller.showLastSeen!,
                                        onChanged: (value) {
                                          if (value) {
                                            if (controller.foodMoodSocial!) {
                                              controller
                                                  .changeShowLastSeen(value);
                                            } else {
                                              Get.snackbar(
                                                  "FoodMood Social aktiv olmalıdır",
                                                  "");
                                            }
                                          } else {
                                            controller
                                                .changeShowLastSeen(value);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: controller.loadingFoodMoodSocialSetting,
                      child: SafeArea(
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: controller.anyChanging
                                ? Colors.green
                                : context.theme.primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16,
                                spreadRadius: 10,
                                color: context.theme.primaryColor,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                String result = await profileSettingController
                                    .saveFoodMoodSocialInfo();
                                if (result == "ok") {
                                  Get.snackbar(
                                    "FoodMood Social təmzimləmələri dəyişdirildi.",
                                    controller.foodMoodSocial!
                                        ? 'FoodMood Social aktivdir. Digər istifadəçilər tərəfindən görüləcəksiniz.'
                                        : "FoodMood Social deaktivdir.",
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: controller.loadingFoodMoodSocialSetting
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
              } else {
                return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }
}
