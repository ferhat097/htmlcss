// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/LikedYouController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Screens/Common/UserProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LikedYou extends StatefulWidget {
  const LikedYou({Key? key}) : super(key: key);

  @override
  _LikedYouState createState() => _LikedYouState();
}

class _LikedYouState extends State<LikedYou> {
  LikedYouController likedYouController = Get.put(LikedYouController());
  ProfilePageController profilePageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await likedYouController.setLikedYou();
      },
      child: GetBuilder<ProfilePageController>(builder: (profileController) {
        bool premium =
            profilePageController.meSocial!.data()!["premium"] ?? false;
        return Column(
          children: [
            if (!premium)
              Text(
                "Sizi bəyənənləri görmək üçün profil səhifəsindən 'Premium' hesaba keçməlisiniz!",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: context.iconColor,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: GetBuilder<LikedYouController>(
                builder: (controller) {
                  if (controller.usersList.isNotEmpty) {
                    return GridView.builder(
                      itemCount: controller.usersList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        bool premium = profilePageController.meSocial!
                                .data()!["premium"] ??
                            false;
                        if (premium) {
                          return Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(
                                  () => UserProfile(
                                    userId: controller.usersList[index]
                                        ["userId"],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        controller.usersList[index]
                                            ["userPhoto"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            controller.usersList[index]["name"],
                                            style: GoogleFonts.encodeSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 15,
                                sigmaY: 15,
                                tileMode: TileMode.clamp,
                              ),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          controller.usersList[index]
                                              ["userPhoto"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 5,
                                        child: Text(
                                          controller.usersList[index]["name"],
                                          style: GoogleFonts.encodeSans(
                                            color: context.iconColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sizi bəyənən istifadəçi yoxdur",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.pink,
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.pink,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  await controller.setLikedYou();
                                },
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
