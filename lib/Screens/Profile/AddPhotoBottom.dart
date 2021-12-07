// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AddPhotoController.dart';
import 'package:foodmood/Screens/Profile/SearchRestaurant.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPhotoBottom extends StatefulWidget {
  const AddPhotoBottom({Key? key}) : super(key: key);

  @override
  _AddPhotoBottomState createState() => _AddPhotoBottomState();
}

class _AddPhotoBottomState extends State<AddPhotoBottom> {
  AddPhotoController addPhotoController = Get.put(AddPhotoController());
  @override
  void dispose() {
    Get.delete<AddPhotoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPhotoController>(builder: (controller) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.iconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 5,
              width: 40,
            ),
            const SizedBox(
              height: 20,
            ),
            controller.image == null
                ? Column(
                    children: [
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
                      ),
                      const SizedBox(height: 5),
                    ],
                  )
                : const SizedBox(),
            Expanded(
              child: controller.image != null
                  ? Column(
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                controller.image!,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Material(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        controller.deleteImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.change_circle,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Dəyiş",
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: controller.descriptionEditingController,
                            decoration: InputDecoration(
                              hintText: "Açıqlama",
                              hintStyle: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(
                            top: 0,
                            left: 5,
                            right: 5,
                            bottom: 5,
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                Map<String, dynamic>? result =
                                    await Get.bottomSheet<Map<String, dynamic>>(
                                  const SearchRestaurant(),
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  backgroundColor: context.theme.canvasColor,
                                );
                                if (result != null) {
                                  controller.setHere(result);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: controller.restaurant == null
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            color: context.iconColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Burdayam",
                                            style: GoogleFonts.encodeSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_pin,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  controller.restaurant![
                                                      "restaurantName"],
                                                  style: GoogleFonts.encodeSans(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                controller.deleteRestaurant();
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: context.iconColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: controller.loading,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Material(
                              color: Colors.green,
                              child: InkWell(
                                onTap: () async {
                                  await controller.share();
                                  Get.back<bool>(
                                    result: true,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: controller.loading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            "Paylaş",
                                            style: GoogleFonts.encodeSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        "Şəkil seçin",
                        style: GoogleFonts.encodeSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
