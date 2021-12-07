// ignore_for_file: file_names
// // ignore_for_file: file_names

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodmood/Controllers/FoodMoodSocialController.dart';
// import 'package:foodmood/Controllers/OrderController.dart';
// import 'package:foodmood/Controllers/TableSendAwaysController.dart';
// import 'package:foodmood/Screens/Common/UserProfile.dart';
// import 'package:foodmood/Screens/FoodMoodSocial/Coupons.dart';
// import 'package:foodmood/Screens/FoodMoodSocial/Message.dart';
// import 'package:foodmood/Screens/FoodMoodSocial/MySendAway.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FoodMoodSocial extends StatefulWidget {
//   const FoodMoodSocial({Key? key}) : super(key: key);

//   @override
//   _FoodMoodSocialState createState() => _FoodMoodSocialState();
// }

// class _FoodMoodSocialState extends State<FoodMoodSocial> {
//   FoodMoodSocialController foodMoodSocialController =
//       Get.put(FoodMoodSocialController());
//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//         controller: foodMoodSocialController.pageController,
//         children: [
//           Coupons(),
//           Scaffold(
//             appBar: PreferredSize(
//               preferredSize: Size(double.infinity, 50),
//               child: GetBuilder<FoodMoodSocialController>(
//                 id: "appbar",
//                 builder: (controller) {
//                   return AppBar(
//                     elevation: 0,
//                     leading: Row(
//                       children: [
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: context.theme.canvasColor,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Material(
//                             borderRadius: BorderRadius.circular(50),
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(50),
//                               onTap: () {
//                                 foodMoodSocialController.pageController
//                                     .animateToPage(0,
//                                         duration: Duration(milliseconds: 300),
//                                         curve: Curves.easeInOut);
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Image.asset(
//                                   "assets/coupons.png",
//                                   scale: 17,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(right: 10),
//                             decoration: BoxDecoration(
//                               color: Colors.blue[50],
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: Material(
//                               borderRadius: BorderRadius.circular(50),
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(50),
//                                 onTap: () {
//                                   foodMoodSocialController.pageController
//                                       .animateToPage(
//                                     1,
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeIn,
//                                   );
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                     top: 8,
//                                     bottom: 8,
//                                     left: 10,
//                                     right: 6,
//                                   ),
//                                   child: Icon(
//                                     Icons.send_rounded,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                     backgroundColor: context.theme.appBarTheme.backgroundColor,
//                     title: Text(
//                       "FoodMood Social",
//                       style: GoogleFonts.comfortaa(
//                         color: context.textTheme.bodyText1!.color,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             body: Container(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Container(
//                         height: 100,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 5),
//                                 child: GetBuilder<FoodMoodSocialController>(
//                                   builder: (controller) {
//                                     if (controller.foodMoodSocialLevelMe !=
//                                         null) {
//                                       return Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               color: foodMoodSocialController
//                                                   .defineUserColor(controller
//                                                       .foodMoodSocialLevelMe!
//                                                       .data()!["point"]
//                                                       .toDouble()),
//                                             ),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(3.0),
//                                               child: CircleAvatar(
//                                                 radius: 38,
//                                                 backgroundImage: NetworkImage(
//                                                   controller
//                                                       .foodMoodSocialLevelMe!
//                                                       .data()!["userPhoto"],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             "Mən",
//                                             style: GoogleFonts.quicksand(
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       );
//                                     } else {
//                                       return SizedBox();
//                                     }
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               GetBuilder<FoodMoodSocialController>(
//                                 builder: (controller) {
//                                   if (controller
//                                       .foodMoodSocialLevel.isNotEmpty) {
//                                     return Container(
//                                       // height: 100,
//                                       child: ListView.separated(
//                                         padding: EdgeInsets.zero,
//                                         physics: NeverScrollableScrollPhysics(),
//                                         separatorBuilder: (context, index) {
//                                           return SizedBox(
//                                             width: 5,
//                                           );
//                                         },
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: controller
//                                             .foodMoodSocialLevel.length,
//                                         itemBuilder: (context, index) {
//                                           return Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.yellow,
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                 ),
//                                                 child: Material(
//                                                   color: Colors.transparent,
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   child: InkWell(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             50),
//                                                     onTap: () {
//                                                       Get.to(
//                                                         () => UserProfile(
//                                                           userId: controller
//                                                               .foodMoodSocialLevel[
//                                                                   index]
//                                                               .id,
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               3.0),
//                                                       child: CircleAvatar(
//                                                         backgroundImage:
//                                                             NetworkImage(
//                                                           controller
//                                                               .foodMoodSocialLevel[
//                                                                   index]
//                                                               .data()!["userPhoto"],
//                                                         ),
//                                                         radius: 38,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 controller
//                                                     .foodMoodSocialLevel[index]
//                                                     .data()!["userName"],
//                                                 style: GoogleFonts.quicksand(),
//                                               )
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   } else {
//                                     return SizedBox();
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Divider(),
//                     GetBuilder<FoodMoodSocialController>(
//                       builder: (controller) {
//                         if (controller.foodMoodSocialWeeklyTop.isNotEmpty) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   "Həfənin ən yaxşıları",
//                                   style: GoogleFonts.quicksand(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 5),
//                                 child: Container(
//                                   height: 120,
//                                   child: GridView.builder(
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 1,
//                                             mainAxisSpacing: 5,
//                                             childAspectRatio: 1.1 / 1),
//                                     itemCount: controller
//                                         .foodMoodSocialWeeklyTop.length,
//                                     scrollDirection: Axis.horizontal,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, index) {
//                                       return Material(
//                                         borderRadius: BorderRadius.circular(5),
//                                         child: InkWell(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           onTap: () {
//                                             if (controller
//                                                     .foodMoodSocialWeeklyTop[
//                                                         index]
//                                                     .id !=
//                                                 FirebaseAuth.instance
//                                                     .currentUser!.uid) {
//                                               Get.to(
//                                                 () => UserProfile(
//                                                   userId: controller
//                                                       .foodMoodSocialWeeklyTop[
//                                                           index]
//                                                       .id,
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                           child: Column(
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   width: double.infinity,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.amber,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5),
//                                                   ),
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5),
//                                                     child: Image.network(
//                                                       controller
//                                                           .foodMoodSocialWeeklyTop[
//                                                               index]
//                                                           .data()!["userPhoto"],
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 controller
//                                                             .foodMoodSocialWeeklyTop[
//                                                                 index]
//                                                             .id ==
//                                                         FirebaseAuth.instance
//                                                             .currentUser!.uid
//                                                     ? "Mən"
//                                                     : controller
//                                                         .foodMoodSocialWeeklyTop[
//                                                             index]
//                                                         .data()!["userName"],
//                                                 style: GoogleFonts.quicksand(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return SizedBox();
//                         }
//                       },
//                     ),
//                     GetBuilder<FoodMoodSocialController>(
//                       id: "sendaway",
//                       builder: (controller) {
//                         if (controller.foodMoodSocialSendAway.isNotEmpty) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   "İsmarla",
//                                   style: GoogleFonts.quicksand(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 child: GridView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 1,
//                                           mainAxisSpacing: 5,
//                                           childAspectRatio: 1.1 / 1),
//                                   itemCount:
//                                       controller.foodMoodSocialSendAway.length,
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     return Column(
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                               color: Colors.amber,
//                                               borderRadius:
//                                                   BorderRadius.circular(0),
//                                             ),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(0),
//                                               child: Image.network(
//                                                 controller
//                                                     .foodMoodSocialSendAway[
//                                                         index]
//                                                     .data()!["userPhoto"],
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           controller
//                                               .foodMoodSocialSendAway[index]
//                                               .data()!["userName"],
//                                           style: GoogleFonts.quicksand(
//                                               fontWeight: FontWeight.bold),
//                                         )
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return SizedBox();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Message(),
//           MySendAway()
//         ]);
//   }
// }

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/FoodMoodSocialController.dart';
import 'package:foodmood/Controllers/MessageController.dart';
import 'package:foodmood/Controllers/ResultController.dart';
import 'package:foodmood/Screens/FoodMoodSocial/Message.dart';
import 'package:foodmood/Screens/FoodMoodSocial/Result.dart';
import 'package:foodmood/Screens/FoodMoodSocial/moodSocial.dart';
import 'package:get/get.dart';

class FoodMoodSocial extends StatefulWidget {
  const FoodMoodSocial({Key? key}) : super(key: key);

  @override
  _FoodMoodSocialState createState() => _FoodMoodSocialState();
}

class _FoodMoodSocialState extends State<FoodMoodSocial> {
  FoodMoodSocialController foodMoodSocialController =
      Get.put(FoodMoodSocialController());
  ResultController resultController = Get.put(ResultController());
  MessageController messageController = Get.put(MessageController());
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !authController.activeInternet
          ? Colors.red
          : context.theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 65),
        child: GetBuilder<FoodMoodSocialController>(
            id: "foodmoodsocialpagechange",
            builder: (controller) {
              return AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            print(resultController.promotion.length);
                            foodMoodSocialController.pageController
                                .jumpToPage(0);
                            // foodMoodSocialController.pageController
                            //     .animateToPage(
                            //   0,
                            //   duration: Duration(milliseconds: 100),
                            //   curve: Curves.linear,
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: controller.currentPage == 0
                                ? Image.asset(
                                    "assets/foodfeed.png",
                                    scale: 10,
                                  )
                                : context.isDarkMode
                                    ? Image.asset(
                                        "assets/foodfeedlight.png",
                                        scale: 12,
                                      )
                                    : Image.asset(
                                        "assets/foodfeedblack.png",
                                        scale: 12,
                                      ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30, child: VerticalDivider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Material(
                          color: controller.currentPage == 1
                              ? Colors.pink
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              foodMoodSocialController.pageController
                                  .jumpToPage(1);
                              // foodMoodSocialController.pageController
                              //     .animateToPage(
                              //   1,
                              //   duration: Duration(milliseconds: 100),
                              //   curve: Curves.linear,
                              // );
                              //foodMoodSocialController.getDuo();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/socialcolered.png",
                                scale: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30, child: VerticalDivider()),
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            foodMoodSocialController.pageController
                                .jumpToPage(2);
                            // foodMoodSocialController.pageController
                            //     .animateToPage(
                            //   2,
                            //   duration: Duration(milliseconds: 100),
                            //   curve: Curves.linear,
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: controller.currentPage == 2
                                ? Image.asset(
                                    "assets/test2.png",
                                    scale: 10,
                                  )
                                : context.isDarkMode
                                    ? Image.asset(
                                        "assets/test3dark.png",
                                        scale: 12,
                                      )
                                    : Image.asset(
                                        "assets/test.png",
                                        scale: 12,
                                      ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      body: PageView(
        onPageChanged: (int page) {
          foodMoodSocialController.changePage(page);
        },
        controller: foodMoodSocialController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Result(),
          MoodSocial(),
          Message(),
        ],
      ),
    );
  }
}
