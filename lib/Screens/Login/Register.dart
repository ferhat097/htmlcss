// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/defaults.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthController authController = Get.find();
  @override
  void dispose() {
    authController.registerNameController.clear();
    authController.registerEmailController.clear();
    authController.registerPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        //  toolbarHeight: 50,
        elevation: 2,
        backgroundColor: Colors.black,
        // brightness: Brightness.dark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // gradient: LinearGradient(
                //   colors: defineMainButtonGradientColors(),
                // ),
                color: Colors.grey[900],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  splashColor: Colors.grey[700],
                  onTap: () {
                    Get.back();

                    authController.sent.value = false;
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "FoodMood ",
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (authController.pleaseWait.value == true) {
              authController.sent.value = false;
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Obx(
                () {
                  if (authController.pleaseWait.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .canvasColor
                                  .withOpacity(0.8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Lottie.asset(
                                //     'assets/loadinganimation.json',
                                //     height: 200,
                                //     width: 200,
                                //     fit: BoxFit.fitHeight,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Lottie.asset(
                                    "assets/heartanimation.json",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white70,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Container(
                                  //   height: 90,
                                  //   width: 90,
                                  //   child: Image.asset("assets/waiter.png"),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                          color: Colors.green[900],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green[900],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Icon(
                                                Icons.email,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                await authController
                                                    .signInWithGoogle();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Image.asset(
                                                  "assets/googlesignin.png",
                                                  scale: 9,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                await authController
                                                    .signInWithApple();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Image.asset(
                                                  "assets/applesigninwhite.png",
                                                  scale: 9,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Obx(
                                    () => IgnorePointer(
                                      ignoring: authController.sent.value,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              // color: defineTextFieldColor(),
                                              color: authController
                                                      .nameProblem.value
                                                  ? Colors.red[100]
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextField(
                                              onChanged: (String name) {
                                                if (!name.isAlphabetOnly) {
                                                  authController
                                                      .nameProblem.value = true;
                                                } else {
                                                  authController.nameProblem
                                                      .value = false;
                                                }
                                              },
                                              autofocus: true,
                                              // focusNode:
                                              //     authController.signinNumberFocus,
                                              controller: authController
                                                  .registerNameController,
                                              keyboardType: TextInputType.name,
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .digitsOnly,
                                              //   FilteringTextInputFormatter.deny(
                                              //       RegExp("^[0,1,2,3,4,6,8][1-9]*")),
                                              //   LengthLimitingTextInputFormatter(9)
                                              // ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Adınız",
                                                hintStyle:
                                                    GoogleFonts.quicksand(
                                                  // color: defineWhiteBlack(),
                                                  color: Colors.black,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              // color: defineTextFieldColor(),
                                              color: authController
                                                      .emailProblem.value
                                                  ? Colors.red[100]
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextField(
                                              onChanged: (String email) {
                                                if (!email.isEmail) {
                                                  authController.emailProblem
                                                      .value = true;
                                                } else {
                                                  authController.emailProblem
                                                      .value = false;
                                                }
                                              },
                                              autofocus: true,
                                              // focusNode:
                                              //     authController.signinNumberFocus,
                                              controller: authController
                                                  .registerEmailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .digitsOnly,
                                              //   FilteringTextInputFormatter.deny(
                                              //       RegExp("^[0,1,2,3,4,6,8][1-9]*")),
                                              //   LengthLimitingTextInputFormatter(9)
                                              // ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "E-mail",
                                                hintStyle:
                                                    GoogleFonts.quicksand(
                                                  // color: defineWhiteBlack(),
                                                  color: Colors.black,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              // color: defineTextFieldColor(),
                                              color: authController
                                                      .passwordProblem.value
                                                  ? Colors.red[100]
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextField(
                                              onChanged: (String password) {
                                                if (password.length < 6) {
                                                  authController.passwordProblem
                                                      .value = true;
                                                } else {
                                                  authController.passwordProblem
                                                      .value = false;
                                                }
                                              },
                                              autofocus: true,
                                              // focusNode:
                                              //     authController.signinNumberFocus,
                                              controller: authController
                                                  .registerPasswordController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter
                                              //       .digitsOnly,
                                              //   FilteringTextInputFormatter.deny(
                                              //       RegExp("^[0,1,2,3,4,6,8][1-9]*")),
                                              //   LengthLimitingTextInputFormatter(9)
                                              // ],
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Şifrə",
                                                hintStyle:
                                                    GoogleFonts.quicksand(
                                                  // color: defineWhiteBlack(),
                                                  color: Colors.black,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GetBuilder<AuthController>(
                                      id: "licenses",
                                      builder: (controller) {
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white10,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Transform.scale(
                                                        scale: 1.2,
                                                        child: Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              Colors.black,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                          value: controller
                                                              .privacyPolicy,
                                                          onChanged: (value) {
                                                            controller.acceptPP(
                                                                value!);
                                                          },
                                                          visualDensity:
                                                              VisualDensity
                                                                  .comfortable,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                        maxLines: 2,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      launch(
                                                                        "https://foodmood.me/privacypolicy",
                                                                      );
                                                                    },
                                                              text: "\"Gİzlİlİk Sİyasətİ\" "
                                                                  .toUpperCase(),
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                color: Colors
                                                                    .lightBlue,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "ilə tanış oldum və razıyam",
                                                              style: GoogleFonts
                                                                  .encodeSans(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white10,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Transform.scale(
                                                        scale: 1.2,
                                                        child: Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              Colors.black,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                          value:
                                                              controller.eula,
                                                          onChanged: (value) {
                                                            controller
                                                                .acceptEula(
                                                                    value!);
                                                          },
                                                          visualDensity:
                                                              VisualDensity
                                                                  .comfortable,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      launch(
                                                                        "https://foodmood.me/eulalicense",
                                                                      );
                                                                    },
                                                              text: "\"EULA\" ",
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                color: Colors
                                                                    .lightBlue,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "şərtləri ilə tanış oldum və razıyam",
                                                              style: GoogleFonts
                                                                  .encodeSans(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GetBuilder<AuthController>(
                                    id: 'register',
                                    builder: (controller) {
                                      return IgnorePointer(
                                        ignoring: controller.registerLoading,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.green,
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.blueGrey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () async {
                                                if (authController
                                                        .registerEmailController
                                                        .text
                                                        .isNotEmpty &&
                                                    authController
                                                        .registerEmailController
                                                        .text
                                                        .isEmail) {
                                                  if (authController
                                                          .registerPasswordController
                                                          .text
                                                          .isNotEmpty &&
                                                      authController
                                                              .registerPasswordController
                                                              .text
                                                              .length >
                                                          5) {
                                                    if (authController
                                                            .registerNameController
                                                            .text
                                                            .isNotEmpty &&
                                                        authController
                                                            .registerNameController
                                                            .text
                                                            .isAlphabetOnly) {
                                                      if (controller
                                                              .privacyPolicy &&
                                                          controller.eula) {
                                                        authController
                                                            .pleaseWait
                                                            .value = true;
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        bool success = await authController
                                                            .signUpWithEmail(
                                                                authController
                                                                    .registerEmailController
                                                                    .text,
                                                                authController
                                                                    .registerPasswordController
                                                                    .text,
                                                                authController
                                                                    .registerNameController
                                                                    .text,
                                                                defaultProfilePhoto);
                                                        authController
                                                            .pleaseWait
                                                            .value = false;
                                                        if (!success) {
                                                          Get.snackbar(
                                                            "Xəta baş verdi!",
                                                            authController
                                                                .errorMessage!,
                                                            backgroundColor:
                                                                Colors.red,
                                                          );
                                                        }
                                                      } else {
                                                        Get.snackbar(
                                                          "Zəhmət olmasa 'GİZLİLİK SİYASƏTİ' və 'EULA' şərtlərini qəbul edin!",
                                                          "",
                                                          backgroundColor:
                                                              Colors.red,
                                                          borderRadius: 5,
                                                        );
                                                      }
                                                    } else {
                                                      Get.snackbar(
                                                        "Xəta baş verdi!",
                                                        "Adınız düzgün yazılmayıb!",
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                    }
                                                  } else {
                                                    Get.snackbar(
                                                      "Xəta baş verdi!",
                                                      "Şifrə düzgün yazılmayıb! Şifrə ən azı 6 rəqəm vəya hərfdən ibarət olmalıdır!",
                                                      backgroundColor:
                                                          Colors.red,
                                                    );
                                                  }
                                                } else {
                                                  // ignore: avoid_print
                                                  Get.snackbar(
                                                    "Xəta baş verdi!",
                                                    "E-mail adresi düzgün yazılmayıb!",
                                                    backgroundColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: controller
                                                        .registerLoading
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Text(
                                                          "Qeydiyyatdan keç",
                                                          style: GoogleFonts
                                                              .encodeSans(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
