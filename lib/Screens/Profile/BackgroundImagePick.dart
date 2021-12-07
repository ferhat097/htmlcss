// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/BackgroundOptionController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class BackgroundImagePick extends StatefulWidget {
  final bool firstSet;
  final bool ispremium;
  const BackgroundImagePick(
      {Key? key, required this.firstSet, required this.ispremium})
      : super(key: key);

  @override
  _BackgroundImagePickState createState() => _BackgroundImagePickState();
}

class _BackgroundImagePickState extends State<BackgroundImagePick> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: GetBuilder<BackgroundOptionController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: Column(
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
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: controller.specialBackgroundFile != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                controller.specialBackgroundFile!,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    "assets/premium.png",
                                  ),
                                ),
                              )
                            ],
                          )
                        : Ink(
                            color: context.theme.primaryColor,
                            child: Center(
                              child: Text(
                                "Şəkil seçin",
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                  style: GoogleFonts.quicksand(fontSize: 16),
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
                                  style: GoogleFonts.quicksand(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: controller.loadingSpec,
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
                          if (controller.specialBackgroundFile != null) {
                            await controller.specialBackground(
                              widget.firstSet,
                              widget.ispremium,
                            );
                          } else {
                            Get.snackbar(
                              "Zəhmət olmasa şəkil seçin!",
                              "Şəkil seçilməyib!",
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: controller.loadingSpec
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Özəlləşdir -1000 MoodX",
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
      }),
    );
  }
}
