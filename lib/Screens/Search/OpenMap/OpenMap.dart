// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodmood/Controllers/OpenMapController.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RatingRestaurant.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OpenMap extends StatefulWidget {
  final LatLng? latLng;
  final bool isRestaurant;
  final Map<String, dynamic>? restaurant;
  const OpenMap(
      {Key? key, this.latLng, required this.isRestaurant, this.restaurant})
      : super(key: key);

  @override
  _OpenMapState createState() => _OpenMapState();
}

class _OpenMapState extends State<OpenMap> {
  SearchController searchController = Get.find();
  OpenMapController openMapController = Get.put(OpenMapController());
  late LatLng target;
  late double zoom;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      openMapController.getMarkers(widget.isRestaurant, widget.latLng);
    });
    if (widget.latLng == null) {
      target = const LatLng(40.409264, 49.867092);
      zoom = 10;
    } else {
      target = widget.latLng!;
      zoom = 20;
      Map<String, dynamic> coordinate = {
        "restaurantName": widget.restaurant!["restaurantName"],
        "restaurantId": widget.restaurant!["restaurantId"],
        "restaurantPhoto": widget.restaurant!["restaurantPhotos"] ?? [],
        "coordinate": widget.restaurant!["location"]
      };
      openMapController.setInfo(coordinate);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        openMapController.panelController.open();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OpenMapController>(builder: (controller) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SlidingUpPanel(
              isDraggable: controller.selectedCoordinate != null,
              color: context.theme.canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              controller: controller.panelController,
              parallaxEnabled: true,
              parallaxOffset: .5,
              panel: Builder(
                builder: (context) {
                  if (controller.selectedCoordinate != null) {
                    List photos =
                        controller.selectedCoordinate!["restaurantPhotos"] ??
                            [];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: context.iconColor,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   height: 5,
                        //   width: 40,
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Column(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  child: SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: photos.isNotEmpty
                                        ? CarouselSlider.builder(
                                            itemCount: photos.length,
                                            itemBuilder:
                                                (context, index, index2) {
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .theme.primaryColor,
                                                ),
                                                child: Image.network(
                                                  photos[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                            options: CarouselOptions(
                                              height: 200,
                                              aspectRatio: 1,
                                              viewportFraction: 1,
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                              "Şəkil yoxdur",
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                    //  Image.asset(
                                    //   "assets/loginbackground.png",
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context.iconColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 5,
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: controller.defineType(1),
                                    ),
                                  ),
                                  Text(
                                    controller
                                        .selectedCoordinate!["restaurantName"],
                                    style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.yellow[800],
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                        ),
                                        child: Material(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                            onTap: () {
                                              Get.bottomSheet(
                                                RatingRestaurant(
                                                  restaurantId: controller
                                                          .selectedCoordinate![
                                                      "restaurantId"],
                                                ),
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    context.theme.canvasColor,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Image.asset(
                                                    //   "assets/levelplate.png",
                                                    //   scale: 22,
                                                    //   color: Colors.white,
                                                    // ),
                                                    Icon(
                                                      Icons.add_box,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "səs ver",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: RatingBarIndicator(
                                                  rating: 2,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[800],
                                                    );
                                                  },
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
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Material(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                            onTap: () async {
                                              // GeoPoint geoPoint = controller
                                              //         .selectedCoordinate![
                                              //     "coordinate"];
                                              // await searchController.iamhere(
                                              //   LatLng(geoPoint.latitude,
                                              //       geoPoint.longitude),
                                              //   controller.selectedCoordinate![
                                              //       "restaurantId"],
                                              // );
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Image.asset(
                                                    //   "assets/levelplate.png",
                                                    //   scale: 22,
                                                    //   color: Colors.white,
                                                    // ),
                                                    Image.asset(
                                                      "assets/wave.png",
                                                      scale: 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "burdayam",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: Image.asset(
                                                      "assets/girl-face.png",
                                                      color: context.iconColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "34",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: Image.asset(
                                                  "assets/boy-face.png",
                                                  color: context.iconColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          width: double.infinity,
                          child: Material(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              onTap: () {
                                Get.to(
                                  () => RestaurantPage(
                                    restaurantId: controller
                                        .selectedCoordinate!["restaurantId"],
                                  ),
                                );
                              },
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "Restorana bax",
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
                        )
                      ],
                    );
                  } else {
                    return SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Hər hansı pinə toxun",
                            style: GoogleFonts.quicksand(
                              color: context.iconColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Icon(
                            Icons.place,
                            color: Colors.red,
                            size: 40,
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              body: GoogleMap(
                myLocationEnabled: true,
                markers: controller.markers,
                onMapCreated: (GoogleMapController googleMapController) {
                  controller.onMapCreated(googleMapController);
                  if (widget.latLng != null) {}
                },
                initialCameraPosition: CameraPosition(
                  target: target,
                  zoom: zoom,
                ),
                onTap: (LatLng latLng) {
                  controller.panelController.close();
                  controller.clearInfo();
                },
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: context.iconColor,
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
