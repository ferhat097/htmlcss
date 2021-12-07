// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BlockedUsersController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>> userList = [];

  Future getUsers(List cuserList) async {
    print("ok");
    QuerySnapshot<Map<String, dynamic>> userQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("userId", whereIn: cuserList)
        .get();
    userList.clear();
    for (var user in userQuery.docs) {
      userList.add(user.data());
    }
    update();
  }

  Future unblock(String userId) async {
    await firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(firebaseAuth.currentUser!.uid)
        .update(
      <String, dynamic>{
        "blockedUsers": FieldValue.arrayRemove([userId]),
      },
    );
  }
}
