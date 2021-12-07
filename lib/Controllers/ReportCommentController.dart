// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ReportCommentController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future reportMessage(
    String reportString,
    String reportedUserId,
    int what,
    String id1,
    String id2,
  ) async {
    if (what == 1) {
      await firebaseFirestore.collection("Reports").add({
        "restaurantId": id1,
        "commentId": id2,
        "reportedUserId": reportedUserId,
        "reporterUserId": firebaseAuth.currentUser!.uid,
        "reportedDate": DateTime.now(),
        "reportMessage": reportString,
        "what": what,
      });
    } else {
      await firebaseFirestore.collection("Reports").add({
        "foodId": id1,
        "commentId": id2,
        "reportedUserId": reportedUserId,
        "reporterUserId": firebaseAuth.currentUser!.uid,
        "reportedDate": DateTime.now(),
        "reportMessage": reportString,
        "what": what,
      });
    }
  }
}
