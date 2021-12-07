// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BackgroundOptionController extends GetxController {
  ProfilePageController profilePageController = Get.find();
  GeneralController generalController = Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? specialBackgroundFile;
  bool loadingSpec = false;

  Future<String> saveImage() async {
    Reference reference = firebaseStorage.ref(
        "Users/${firebaseAuth.currentUser!.uid}/specialBackground${DateTime.now().millisecondsSinceEpoch}");
    TaskSnapshot uploadTask = await reference.putFile(specialBackgroundFile!);
    String url = await reference.getDownloadURL();
    return url;
  }

  Future specialBackground(bool firstSet, bool ispremium) async {
    loadingSpec = true;
    update();
    if (firstSet && !ispremium) {
      int moodx = profilePageController.meSocial!.data()!["moodx"] ?? 0;
      int specialBackgroundMoodx =
          generalController.financial["specialBackgroundMoodx"];
      if (moodx >= specialBackgroundMoodx) {
        String imageUrl = await saveImage();
        DocumentReference foodMoodSocialReference = firebaseFirestore
            .collection("FoodMoodSocial")
            .doc(firebaseAuth.currentUser!.uid);
        DocumentReference moodReference =
            foodMoodSocialReference.collection("moodx").doc();
        DocumentReference generalReference =
            foodMoodSocialReference.collection("General").doc("backMoodx");
        await firebaseFirestore.runTransaction((transaction) async {
          transaction.update(foodMoodSocialReference, {
            "specialBackground": true,
            "backgroundImage": imageUrl,
            "moodx": FieldValue.increment(-specialBackgroundMoodx),
          });
          transaction.set(moodReference, {
            "date": DateTime.now(),
            "moodx": -specialBackgroundMoodx,
            "isIncome": false,
            "userId": firebaseAuth.currentUser!.uid,
          });
          transaction.update(generalReference, {
            "total": FieldValue.increment(specialBackgroundMoodx),
            "specialBackground": FieldValue.increment(1),
          });
        });
      } else {
        Get.snackbar(
          'Hesabınızda lazımı qədər MoodX yoxdur!',
          "MoodX qazanmaq üçün reklam izləyə vəya yarışmalara qatıla bilərsiniz!",
        );
      }
    } else {
      String imageUrl = await saveImage();
      DocumentReference foodMoodSocialReference = firebaseFirestore
          .collection("FoodMoodSocial")
          .doc(firebaseAuth.currentUser!.uid);
      await firebaseFirestore.runTransaction((transaction) async {
        transaction.update(foodMoodSocialReference, {
          "specialBackground": true,
          "backgroundImage": imageUrl,
        });
      });
    }
    loadingSpec = false;
    update();
  }

  ImagePicker imagePicker = ImagePicker();

  Future getPhotoFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    specialBackgroundFile = File(pickedFile!.path);
    update();
  }

  Future getPhotoFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    specialBackgroundFile = File(pickedFile!.path);
    update();
  }

  /// search restaurant
  AlgoliaQuerySnapshot? searchResults;
  bool searching = false;
  Future searchAlgolia(String querytext) async {
    print("searched");
    Algolia algolia = const Algolia.init(
        applicationId: "X47Q4IOWZ3",
        apiKey: "8e66460b474ae360303b13ef6f4a5caf");
    AlgoliaQuery query = algolia.instance.index("Restaurants").query(querytext);
    searchResults = await query.getObjects();
    searching = false;
    update();
  }

  Widget defineRestaurantImage(String? image, BuildContext context) {
    if (image == null || image.isEmpty) {
      return Container(color: Theme.of(context).primaryColor);
    } else {
      return Image.network(
        image,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    }
  }

  Widget defineType(int type) {
    if (type == 1) {
      return Image.asset("assets/restaurant.png");
    } else if (type == 3) {
      return Image.asset("assets/hotel.png");
    } else if (type == 2) {
      return Image.asset("assets/burger.png");
    } else if (type == 4) {
      return Image.asset("assets/homemade.png");
    } else {
      return Image.asset("assets/restaurant.png");
    }
  }

  bool defineOpenedStatus(int openedTime, int closedTime, bool? is247) {
    DateTime dateTime = DateTime.now();
    if (is247 != null && is247) {
      return true;
    }
    if (dateTime.hour > openedTime && dateTime.hour < closedTime) {
      return true;
    } else {
      return false;
    }
  }

  void select() {}
  TextEditingController searchController = TextEditingController();
  Timer? searchDelay;
  searchDelayFunction(String queryText) {
    searchDelay = Timer(
      const Duration(seconds: 2),
      () => searchAlgolia(queryText),
    );
  }

  @override
  void onClose() {
    searchDelay?.cancel();
    super.onClose();
  }

  bool loadingBackRest = false;
  Future changeRestaurant(String restaurantImage, String restaurantId) async {
    loadingBackRest = true;
    update();
    DocumentReference foodMoodSocialReference = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(firebaseAuth.currentUser!.uid);
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.update(foodMoodSocialReference, {
        "backgroundImage": restaurantImage,
        "backgroundRestaurant": restaurantId,
        "specialBackground": false,
      });
    });
    loadingBackRest = false;
    update();
  }
}
