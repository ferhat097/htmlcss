import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfileSettingController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodMoodHelpCenter extends StatefulWidget {
  const FoodMoodHelpCenter({Key? key}) : super(key: key);

  @override
  _FoodMoodHelpCenterState createState() => _FoodMoodHelpCenterState();
}

class _FoodMoodHelpCenterState extends State<FoodMoodHelpCenter> {
  ProfileSettingController profileSettingController =
      Get.put(ProfileSettingController());
  @override
  void dispose() {
    Get.delete<ProfileSettingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<ProfileSettingController>(
        id: "foodmoodhelp",
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "FoodMood Yardım Mərkəzi",
                style: GoogleFonts.quicksand(fontSize: 18),
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 5),
                      child: Text("Sizə necə kömək edə bilərik?",
                          style: GoogleFonts.quicksand()),
                    ),
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: controller.helpMessage,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.quicksand(),
                          hintText: "Mesajınız",
                          contentPadding: EdgeInsets.only(
                              left: 5, top: 5, bottom: 0, right: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () async {
                            if (controller.helpMessage.text.isNotEmpty) {
                              String result = await profileSettingController
                                  .sendHelpCenter();
                              profileSettingController.helpMessage.clear();
                              if (result == "ok") {
                                Get.snackbar("FoodMood Yardım Mərkəzi",
                                    "Mesajınız göndərildi. Bizə kömək elədiyinizə görə təşəkkür edirik!");
                              } else {
                                Get.snackbar("Xəta baş verdi", "");
                              }
                            } else {
                              Get.snackbar(
                                  "FoodMood Yardım Mərkəzi", "Mesaj boşdur");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Göndər",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "FoodMood Yardım Mərkəzinə göndərilən mesajlara 24 saat ərzində baxılır",
                      style: GoogleFonts.quicksand(),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
