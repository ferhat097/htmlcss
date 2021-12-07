// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/AuthController.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/HomeController.dart';
import 'package:foodmood/Controllers/MainController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/FirebaseRemoteConfigController.dart';
import 'package:get/get.dart';

class Main extends StatefulWidget {
  final bool isAnonym;
  const Main({Key? key, required this.isAnonym}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AuthController authController = Get.find();
  MainController mainController = Get.put(MainController(), permanent: true);
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      ProfilePageController profilePageController = Get.put(
        ProfilePageController(),
        permanent: true,
      );
    }
    SearchController searchController =
        Get.put(SearchController(), permanent: true);
    FirebaseRemoteConfigController firebaseRemoteConfigController =
        Get.put(FirebaseRemoteConfigController(), permanent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainController>(
        id: "pages",
        builder: (controller) {
          return IndexedStack(
            children: mainController.setPages(widget.isAnonym),
            index: mainController.page,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: GetBuilder<MainController>(
          id: "pages",
          builder: (controller) {
            return SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomPaint(
                size: const Size(double.infinity, 100),
                painter: BottomNavBarShape(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      // left: 15,
                      //right: 15,
                      ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Material(
                                  color: mainController.page == 0
                                      ? Colors.amber[200]
                                      : Colors.amber[50],
                                  child: InkWell(
                                    onTap: () {
                                      mainController.changePage(0);
                                    },
                                    child: Opacity(
                                      opacity:
                                          mainController.page == 0 ? 1 : 0.7,
                                      child: Image.asset(
                                        "assets/home.png",
                                        scale: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                if (mainController.page == 0)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Material(
                                  color: mainController.page != 1
                                      ? Colors.green[50]
                                      : Colors.green[200],
                                  child: InkWell(
                                    onTap: () {
                                      mainController.changePage(1);
                                    },
                                    child: Opacity(
                                      opacity:
                                          mainController.page == 1 ? 1 : 0.7,
                                      child: Image.asset(
                                        "assets/search.png",
                                        scale: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                if (mainController.page == 1)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Material(
                                  color: mainController.page == 2
                                      ? Colors.blue[200]
                                      : Colors.blue[50],
                                  child: InkWell(
                                    onTap: () {
                                      mainController.changePage(2);
                                    },
                                    child: Opacity(
                                      opacity:
                                          mainController.page == 2 ? 1 : 0.7,
                                      child: Image.asset(
                                        "assets/foodmoodsocial.png",
                                        scale: 6,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                if (mainController.page == 2)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                            ),
                            width: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // String link =
                                  //     "https://foodmood.me/menu?restaurantId?tableNumber";
                                  // var link1 = link.split("?");
                                  // print(link1[2]);
                                  mainController.changePage(3);
                                },
                                child: mainController.page == 3
                                    ? Image.asset(
                                        "assets/clientselected.png",
                                        scale: 6,
                                      )
                                    : Opacity(
                                        opacity:
                                            mainController.page == 3 ? 1 : 0.7,
                                        child: Image.asset(
                                          "assets/client.png",
                                          scale: 6,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.pink[50]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: GetBuilder<MainController>(
        id: "orderbutton",
        builder: (controller) {
          return FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () async {
              // if (mainController.orderExist) {
              //   if (mainController.activeOrder != null) {
              //     Get.to(
              //         () => OrderPage(
              //               orderId:
              //                   mainController.activeOrder!.data()!["orderId"],
              //               createOrder: false,
              //               restaurantId: mainController.activeOrder!
              //                   .data()!["restaurantId"],
              //               tableNumber: mainController.activeOrder!
              //                   .data()!["tableNumber"],
              //               needJoin: false,
              //             ),
              //         preventDuplicates: false);
              //   }
              // } else {
              //   Get.to(() => ScanQr());
              // }
              // FirebaseAuth.instance.signOut();
              //FocusScope.of(context).unfocus();
            },
            child: mainController.orderExist
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/tablewhite.png"),
                  )
                : Image.asset(
                    "assets/qrscanblack.png",
                    color: Colors.white,
                  ),
            backgroundColor: Colors.black,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class BottomNavBarShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.80, 0);
    path_0.cubicTo(size.width * 0.84, 0, size.width * 0.83, size.height * 0.5,
        size.width * 0.9, size.height * 0.5);
    path_0.cubicTo(size.width * 0.97, size.height * 0.45, size.width * 0.95, 0,
        size.width, 0);
    path_0.quadraticBezierTo(size.width, 0, size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, 0);

    canvas.drawPath(path_0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
