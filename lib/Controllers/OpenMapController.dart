// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OpenMapController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    googleMapController!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
        ),
      ),
    );
  }

  GoogleMapController? googleMapController;
  onMapCreated(GoogleMapController currentgoogleMapController) {
    googleMapController = currentgoogleMapController;
    getCurrentPosition();
    update();
  }

  PanelController panelController = PanelController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cordinates = [];

  Set<Marker> markers = {};

  Future getMarkers(fromRes, LatLng? latLng) async {
    QuerySnapshot<Map<String, dynamic>> cordinatesQuery =
        await firebaseFirestore.collection("Pins").get();
    for (var cordinate in cordinatesQuery.docs) {
      cordinates.add(cordinate.data());
    }
    addMarkers();
    update();
    if (fromRes) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        googleMapController!.showMarkerInfoWindow(markers.first.markerId);
        googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng!,
              zoom: 20,
            ),
          ),
        );
      });
    }
  }

  addMarkers() {
    for (var cordinate in cordinates) {
      GeoPoint geoPoint = cordinate["coordinate"];
      int facilityType = cordinate["facilityType"];
      String facilityName;
      if (facilityType == 1) {
        facilityName = "Restoran";
      } else if (facilityType == 2) {
        facilityName = "FastFood";
      } else if (facilityType == 3) {
        facilityName = "Hotel";
      } else {
        facilityName = "Restoran";
      }
      markers.add(
        Marker(
          markerId: MarkerId(cordinate["restaurantId"]),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          infoWindow: InfoWindow(
            title: cordinate["restaurantName"],
            snippet: facilityName,
          ),
          onTap: () async {
            setInfo(cordinate);
            panelController.open();
          },
        ),
      );
    }
  }

  Map<String, dynamic>? selectedCoordinate;

  void setInfo(coordinate) {
    selectedCoordinate = coordinate;
    update();
  }

  void clearInfo() {
    selectedCoordinate = null;
    update();
  }

  void showMarker() {
    googleMapController!.showMarkerInfoWindow(
      const MarkerId("1EqZIhmjbSAUFT9LhQWu"),
    );
    update();
  }

  Widget defineType(int type) {
    if (type == 1) {
      return Image.asset("assets/restaurant.png");
    } else if (type == 2) {
      return Image.asset("assets/burger.png");
    } else if (type == 3) {
      return Image.asset("assets/hotel.png");
    } else {
      return Image.asset("assets/restaurant.png");
    }
  }
}
