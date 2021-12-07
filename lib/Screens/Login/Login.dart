// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthController authController = Get.find();
  onDispose() {
    authController.sent.value = false;
    authController.loginEmailController.clear();
    authController.loginPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[900],
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
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "FoodMood",
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
                                // Text(
                                //   "Gözləyin...",
                                //   style: GoogleFonts.encodeSans(
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 30,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 30,
                                // )
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   child: Image.asset(
                                //     "assets/foodmoodLogo.png",
                                //     scale: 12,
                                //   ),
                                // ),

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Colors.green[900],
                                        borderRadius: BorderRadius.circular(10),
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
                                              FocusScope.of(context).unfocus();
                                              await authController
                                                  .signInWithGoogle();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
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
                                      if (Platform.isIOS)
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
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Container(
                                //       child: Icon(
                                //         Icons.arrow_drop_down,
                                //         size: 30,
                                //       ),
                                //     )
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 10,
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
                                                    .loginEmailProblem.value
                                                ? Colors.red[100]
                                                : Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextField(
                                            onChanged: (String email) {
                                              if (email.isEmpty ||
                                                  !email.isEmail) {
                                                authController.loginEmailProblem
                                                    .value = true;
                                              } else {
                                                authController.loginEmailProblem
                                                    .value = false;
                                              }
                                            },
                                            autofocus: true,
                                            controller: authController
                                                .loginEmailController,
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
                                              hintStyle: GoogleFonts.quicksand(
                                                  // color: defineWhiteBlack(),
                                                  color: Colors.black),
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
                                                    .loginPasswordProblem.value
                                                ? Colors.red[100]
                                                : Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextField(
                                            onChanged: (String password) {
                                              if (password.isEmpty ||
                                                  password.length < 6) {
                                                authController
                                                    .loginPasswordProblem
                                                    .value = true;
                                              } else {
                                                authController
                                                    .loginPasswordProblem
                                                    .value = false;
                                              }
                                            },
                                            autofocus: true,
                                            controller: authController
                                                .loginPasswordController,
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
                                              hintStyle: GoogleFonts.quicksand(
                                                  // color: defineWhiteBlack(),
                                                  color: Colors.black),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<AuthController>(
                                  id: 'login',
                                  builder: (controller) {
                                    return IgnorePointer(
                                      ignoring: controller.loginLoading,
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
                                                      .loginEmailController
                                                      .text
                                                      .isEmail &&
                                                  authController
                                                      .loginEmailController
                                                      .text
                                                      .isNotEmpty) {
                                                if (authController
                                                        .loginPasswordController
                                                        .text
                                                        .isNotEmpty &&
                                                    authController
                                                            .loginPasswordController
                                                            .text
                                                            .length >
                                                        5) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  bool success = await authController
                                                      .signInWithEmail(
                                                          authController
                                                              .loginEmailController
                                                              .text,
                                                          authController
                                                              .loginPasswordController
                                                              .text);
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
                                                      'Şifrə düzgün deyil',
                                                      'Zəhmət olmasa yazdığınız şifrənin düzgünlüyünü yoxlayın');
                                                }
                                              } else {
                                                Get.snackbar(
                                                    "Email düzgün deyil",
                                                    'Zəhmət olmasa yazdığınız email-in düzgünlüyünü yoxlayın');
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: controller.loginLoading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        "Giriş et",
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Şifrəni unutdun? ",
                                        style: GoogleFonts.encodeSans(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("lossted");
                                            authController.lostPassword(
                                              authController
                                                  .loginEmailController.text,
                                            );
                                          },
                                        text: "E-mail adresinə göndər",
                                        style: GoogleFonts.encodeSans(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
