// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';

class LikedYouController extends GetxController {
  @override
  onInit() {
    setLikedYou();
    super.onInit();
  }

  List<Map<String, dynamic>> usersList = [];
  List users = [];
  Future setLikedYou() async {
    ProfilePageController profilePageController = Get.find();
    List likedUsers =
        profilePageController.meSocial!.data()!["likedUsers"] ?? [];
    List likerUsers =
        profilePageController.meSocial!.data()!["likerUsers"] ?? [];
    users = likerUsers.toSet().difference(likedUsers.toSet()).toList();
    if (users.isNotEmpty) {
      await getUsers();
    }
    update();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future getUsers() async {
    QuerySnapshot<Map<String, dynamic>> userQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("userId", whereIn: users)
        .get();
    usersList.clear();
    for (var user in userQuery.docs) {
      usersList.add(user.data());
    }
  }
}
