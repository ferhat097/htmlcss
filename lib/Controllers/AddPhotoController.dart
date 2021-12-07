// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'ProfilePageController.dart';

class AddPhotoController extends GetxController {
  ImagePicker imagePicker = ImagePicker();
  File? image;
  bool downloading = false;

  Future getPhotoFromGallery() async {
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    update();
  }

  Future getPhotoFromCamera() async {
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    update();
  }

  void deleteImage() {
    image = null;
    update();
  }

  Map<String, dynamic>? restaurant;

  void setHere(selectedRestaurant) {
    restaurant = selectedRestaurant;
    update();
  }

  void deleteRestaurant() {
    restaurant = null;
    update();
  }

  TextEditingController descriptionEditingController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  ProfilePageController profilePageController = Get.find();

  Future share() async {
    loading = true;
    update();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference photoReference = firebaseStorage
        .ref("/$userId/photos/${DateTime.now().microsecondsSinceEpoch}.jpg");
    TaskSnapshot taskSnapshot = await photoReference.putFile(image!);
    String url = await taskSnapshot.ref.getDownloadURL();
    String description;
    if (descriptionEditingController.text.isNotEmpty) {
      description = descriptionEditingController.text;
    } else {
      description = "";
    }

    String restaurantName;
    String restaurantImage;
    String restaurantId;
    String facilityName;
    GeoPoint location;
    String locationName;
    bool isRestaurant = false;

    if (restaurant != null) {
      restaurantName = restaurant!["restaurantName"];
      restaurantImage = restaurant!["restaurantImage"];
      restaurantId = restaurant!["restaurantId"];
      facilityName = restaurant!["facilityName"];
      location = GeoPoint(restaurant!["location"]["_latitude"] ?? 0,
          restaurant!["location"]["_longitude"] ?? 0);
      locationName = restaurant!["locationName"];
      isRestaurant = true;
    } else {
      restaurantName = "";
      restaurantImage = "";
      restaurantId = "";
      facilityName = "";
      location = const GeoPoint(0, 0);
      locationName = "";
    }
    DocumentReference<Map<String, dynamic>> photoFirestoreReference =
        firebaseFirestore
            .collection("FoodMoodSocial")
            .doc(userId)
            .collection("photos")
            .doc();
    await photoFirestoreReference.set({
      "imageUrl": url,
      "sharedDate": DateTime.now(),
      "like": 0,
      "description": description,
      "inRestaurant": isRestaurant,
      "restaurantName": restaurantName,
      "restaurantImage": restaurantImage,
      "restaurantId": restaurantId,
      "facilityName": facilityName,
      "location": location,
      "locationName": locationName,
      "allowEverybody": true,
      "imageId": photoFirestoreReference.id,
    });
    loading = false;
    update();
    profilePageController.getUserImages();
  }
}
