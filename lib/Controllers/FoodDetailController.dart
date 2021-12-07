// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ProfilePageController.dart';

class FoodDetailController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StreamSubscription? listenComments;
  StreamSubscription? listenFood;
  List<Map<String, dynamic>> comments = [];
  Map<String, dynamic>? food;
  listenFoodComment(String foodId) {
    listenComments = firebaseFirestore
        .collection("Foods")
        .doc(foodId)
        .collection("comments")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((commentsQuery) {
      comments.clear();
      for (var comment in commentsQuery.docs) {
        comments.add(comment.data());
      }
      update();
    });
  }

  listenFoodQuery(String foodId) {
    listenFood =
        firebaseFirestore.collection("Foods").doc(foodId).snapshots().listen(
      (foodQuery) {
        food = foodQuery.data();
        update();
      },
    );
  }

  @override
  void onClose() {
    listenComments?.cancel();
    listenFood?.cancel();
  }

  //coment write
  bool commentWritingProgress = false;
  TextEditingController writeRestaurantCommentController =
      TextEditingController();

  Future writeRestaurantComment(String foodId) async {
    ProfilePageController profilePageController = Get.find();
    commentWritingProgress = true;
    update();
    DocumentReference commentReference = firebaseFirestore
        .collection("Foods")
        .doc(foodId)
        .collection("comments")
        .doc();
    await commentReference.set({
      "comment": writeRestaurantCommentController.text,
      "fromId": profilePageController.meSocial!.data()!["userId"],
      "fromPhoto": profilePageController.meSocial!.data()!["userPhoto"],
      "fromName": profilePageController.meSocial!.data()!["name"],
      "date": DateTime.now(),
      "foodId": foodId,
      "commentId": commentReference.id,
      "like": 0,
      "likedUsers": [],
    });
    commentWritingProgress = false;
    update();
  }

  Future removeComment(String commentId, String foodId) async {
    await firebaseFirestore
        .collection("Foods")
        .doc(foodId)
        .collection("comments")
        .doc(commentId)
        .delete();
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future likeComment(String commentId, String foodId, bool like) async {
    if (like) {
      await firebaseFirestore
          .collection("Foods")
          .doc(foodId)
          .collection("comments")
          .doc(commentId)
          .update({
        "likedUsers": FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(1),
      });
    } else {
      await firebaseFirestore
          .collection("Foods")
          .doc(foodId)
          .collection("comments")
          .doc(commentId)
          .update({
        "likedUsers": FieldValue.arrayRemove([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(-1),
      });
    }
  }

  Future likeFood(String foodId, bool like) async {
    if (like) {
      await firebaseFirestore.collection("Foods").doc(foodId).update({
        "likedUsers": FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(1),
      });
    } else {
      await firebaseFirestore.collection("Foods").doc(foodId).update({
        "likedUsers": FieldValue.arrayRemove([firebaseAuth.currentUser!.uid]),
        "like": FieldValue.increment(-1),
      });
    }
  }
}
