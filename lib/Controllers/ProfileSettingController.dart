// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingController extends GetxController {
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxBool manualIsDark = false.obs;
  @override
  void onInit() {
    manualIsDark.value = Get.isDarkMode;
    super.onInit();
  }

  ////// CHANGE PROFILE PICTURE
  ImagePicker imagePicker = ImagePicker();
  File? image;
  bool downloading = false;

  Future getPhotoFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    image = File(pickedFile!.path);
    update(["changephoto"]);
  }

  Future getPhotoFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    image = File(pickedFile!.path);
    update(["changephoto"]);
  }

  Future saveProfilePicture() async {
    if (image != null) {
      downloading = true;
      update(["changephoto"]);
      TaskSnapshot uploadTask = await firebaseStorage
          .ref("Users/${firebaseAuth.currentUser!.uid}")
          .putFile(image!);
      String photoUrl = await uploadTask.ref.getDownloadURL();
      HttpsCallable httpsCallable =
          firebaseFunctions.httpsCallable("changeUserProfilePicture");
      await httpsCallable.call(<String, dynamic>{
        "userId": firebaseAuth.currentUser!.uid,
        "photoUrl": photoUrl
      });
      downloading = false;
    }
    update(["changephoto"]);
  }

  /////CHANGE PROFILE INFORMATION

  TextEditingController nameAndSurnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  DateTime? birthday;
  bool anyChangingProfile = false;

  void setChanges() {
    anyChangingProfile = true;
    update(["profileInfo"]);
  }

  setBirthday(DateTime selected) {
    birthday = selected;
    update(["profileInfo"]);
  }

  bool phoneAvailable = true;
  bool userNameAvailable = true;
  bool loadingPr = false;

  setPhoneNumber() {
    phoneAvailable = true;
    update(["profileInfo"]);
  }

  setUserName() {
    userNameAvailable = true;
    update(["profileInfo"]);
  }

  Future<bool> checkUserName(String userName) async {
    QuerySnapshot<Map<String, dynamic>> users = await firebaseFirestore
        .collection("Users")
        .where("username", isEqualTo: userName)
        .get();
    if (users.docs.isNotEmpty) {
      if (users.docs.first.exists) {
        userNameAvailable = false;
        update(["profileInfo"]);
        return false;
      } else {
        userNameAvailable = true;
        update(["profileInfo"]);
        return true;
      }
    } else {
      userNameAvailable = true;
      update(["profileInfo"]);
      return true;
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    QuerySnapshot<Map<String, dynamic>> users = await firebaseFirestore
        .collection("Users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();
    if (users.docs.isNotEmpty) {
      if (users.docs.first.exists) {
        phoneAvailable = false;
        update(["profileInfo"]);
        return false;
      } else {
        phoneAvailable = true;
        update(["profileInfo"]);
        return true;
      }
    } else {
      phoneAvailable = true;
      update(["profileInfo"]);
      return true;
    }
  }

  Future<String> saveProfileInformation(
      Timestamp? currentBirthday,
      String currentname,
      String currentPhoneNumber,
      String currentUserName,
      String userId) async {
    loadingPr = true;
    update(["profileInfo"]);
    String name = "";
    String phoneNumber = "";
    String userName = "";
    DateTime? dateTime;
    if (birthday != null) {
      dateTime = birthday;
    } else {
      if (currentBirthday != null) {
        dateTime = currentBirthday.toDate();
      } else {
        dateTime = DateTime.now();
      }
    }
    if (nameAndSurnameController.text.isEmpty) {
      name = currentname;
    } else {
      name = nameAndSurnameController.text;
    }
    if (phoneNumberController.text.isEmpty) {
      phoneNumber = currentPhoneNumber;
    } else {
      print(currentPhoneNumber);
      print(phoneNumberController.text);
      phoneNumber = "+994${phoneNumberController.text}";
      if (currentPhoneNumber != "+994${phoneNumberController.text}") {
        bool phone = await checkPhoneNumber(phoneNumber);
        print(phone);
      }
    }
    if (userNameController.text.isEmpty) {
      userName = currentUserName;
    } else {
      userName = userNameController.text;
      if (currentUserName != userName) {
        bool username = await checkUserName(userName);
        print(username);
      }
    }
    // print(dateTime);
    // print(name);
    // print(phoneNumber);
    // print(userName);
    // print(userId);
    if (!phoneAvailable && !userNameAvailable) {
      return "phone+username";
    } else if (!phoneAvailable) {
      return "phone";
    } else if (!userNameAvailable) {
      return "username";
    } else {
      HttpsCallable httpsCallable =
          firebaseFunctions.httpsCallable("changeProfileInfo");
      await httpsCallable.call(<String, dynamic>{
        "nameandsurname": name,
        "phoneNumber": phoneNumber,
        "userName": userName,
        "userId": userId,
        "birthday": dateTime!.millisecondsSinceEpoch
      }).whenComplete(() {
        return "ok";
      });
      loadingPr = false;
      update(["profileInfo"]);
      return "ok";
    }
  }

  ///// FOODMOOD SOCIAL SETTINGS
  bool? foodMoodSocial;
  bool? sendaway;
  bool? messaging;
  bool? showOnline;
  bool? showLastSeen;

  bool loadingFoodMoodSocialSetting = false;
  bool anyChanging = false;

  loadFoodMoodSocialSettings(
      bool fmc, bool sa, bool mes, bool online, bool lastseen) {
    foodMoodSocial = fmc;
    sendaway = sa;
    messaging = mes;
    showOnline = online;
    showLastSeen = lastseen;
    update(["foodmoodsetting"]);
  }

  changeFoodMoodSocial(bool fmc) {
    foodMoodSocial = fmc;
    anyChanging = true;
    update(["foodmoodsetting"]);
  }

  changesendaway(bool sa) {
    sendaway = sa;
    anyChanging = true;
    update(["foodmoodsetting"]);
  }

  changeMessaging(bool mes) {
    messaging = mes;
    anyChanging = true;
    update(["foodmoodsetting"]);
  }

  changeShowOnline(bool online) {
    showOnline = online;
    anyChanging = true;
    update(["foodmoodsetting"]);
  }

  changeShowLastSeen(bool lastseen) {
    showLastSeen = lastseen;
    anyChanging = true;
    update(["foodmoodsetting"]);
  }

  Future<String> saveFoodMoodSocialInfo() async {
    loadingFoodMoodSocialSetting = true;
    update(["foodmoodsetting"]);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("changeFoodMoodSocial");
    await httpsCallable.call(<String, dynamic>{
      "userId": firebaseAuth.currentUser!.uid,
      "foodMoodSocial": foodMoodSocial,
      "sendaway": sendaway,
      "messaging": messaging,
      "showLastSeen": showLastSeen,
      "showOnline": showOnline,
    });
    anyChanging = false;
    loadingFoodMoodSocialSetting = false;
    update(["foodmoodsetting"]);
    return "ok";
  }

  //////FOODMOOD HELP CENTER

  TextEditingController helpMessage = TextEditingController();

  Future<String> sendHelpCenter() async {
    print(firebaseAuth.currentUser!.uid);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("sendHelpCenter");
    await httpsCallable.call(<String, dynamic>{
      "userId": firebaseAuth.currentUser!.uid,
      "helpMessage": helpMessage.text,
    });
    return "ok";
  }
}
