// ignore_for_file: file_names, library_prefixes

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/Screens/Search/OpenMap/OpenMap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMap;

import 'package:map_launcher/map_launcher.dart';

class DirectionBottom extends StatefulWidget {
  final GeoPoint latLng;
  final Map<String, dynamic> restaurant;
  const DirectionBottom(
      {Key? key, required this.latLng, required this.restaurant})
      : super(key: key);

  @override
  _DirectionBottomState createState() => _DirectionBottomState();
}

class _DirectionBottomState extends State<DirectionBottom> {
  SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: Container(
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
                    bool status = await searchController.permissionLocation();
                    if (status) {
                      Get.off(
                        () => OpenMap(
                          latLng: GoogleMap.LatLng(
                            widget.latLng.latitude,
                            widget.latLng.longitude,
                          ),
                          isRestaurant: true,
                          restaurant: widget.restaurant,
                        ),
                      );
                    } else {
                      Get.snackbar("Location Permission", "");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child:
                                    Image.asset("assets/locationFoodMood.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "FoodMood Location",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.near_me),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Container(
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
                    bool? available =
                        await MapLauncher.isMapAvailable(MapType.waze);
                    if (available!) {
                      await MapLauncher.showDirections(
                        mapType: MapType.waze,
                        destination: Coords(
                          widget.latLng.latitude,
                          widget.latLng.longitude,
                        ),
                      );
                    } else {
                      Get.snackbar("Waze Maps yüklənməyib", "",
                          backgroundColor: Colors.white);
                    }

                    print(available);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset("assets/waze.png"),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Waze ilə aç",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder<bool?>(
                          future: MapLauncher.isMapAvailable(MapType.waze),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: snapshot.data!
                                    ? Icon(Icons.near_me)
                                    : Icon(Icons.near_me_outlined),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: Container(
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
                    bool? available =
                        await MapLauncher.isMapAvailable(MapType.google);
                    if (available!) {
                      await MapLauncher.showDirections(
                        mapType: MapType.google,
                        destination: Coords(
                          widget.latLng.latitude,
                          widget.latLng.longitude,
                        ),
                      );
                    } else {
                      Get.snackbar("Google Maps yüklənməyib", "",
                          backgroundColor: Colors.white);
                    }

                    print(available);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Image.asset("assets/google-maps.png"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Google Maps ilə aç",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder<bool?>(
                          future: MapLauncher.isMapAvailable(MapType.google),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: snapshot.data!
                                    ? Icon(Icons.near_me)
                                    : Icon(Icons.near_me_outlined),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Container(
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
                      bool? available =
                          await MapLauncher.isMapAvailable(MapType.apple);
                      if (available!) {
                        await MapLauncher.showDirections(
                          mapType: MapType.apple,
                          destination: Coords(
                              widget.latLng.latitude, widget.latLng.longitude),
                        );
                      } else {
                        Get.snackbar("Apple Maps yüklənməyib", "");
                      }

                      print(available);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset("assets/applemap1.png"),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Apple Maps ilə aç",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder<bool?>(
                            future: MapLauncher.isMapAvailable(MapType.apple),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: snapshot.data!
                                      ? Icon(Icons.near_me)
                                      : Icon(Icons.near_me_outlined),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
