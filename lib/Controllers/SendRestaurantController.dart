// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodmood/Controllers/MessageController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SendRestaurantController extends GetxController {
  bool isSearched = false;
  bool isSearching = false;
  Timer? timer;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>> users = [];

  void delayAction(String searchKey) {
    if (searchKey.isEmpty || searchKey == null) {
      setMessages();
    } else {
      isSearching = true;
      isSearched = true;
      update();
      timer = Timer(Duration(seconds: 2), () => searchUser(searchKey));
    }
  }

  Future searchUser(String searchKey) async {
    users.clear();
    QuerySnapshot<Map<String, dynamic>> searchQuery = await firebaseFirestore
        .collection("FoodMoodSocial")
        .where("userName", isEqualTo: searchKey)
        .get();
    if (searchQuery.docs.isNotEmpty) {
      Map<String, dynamic> userMap = searchQuery.docs.first.data();
      userMap.putIfAbsent("fromConversation", () => false);
      users.add(userMap);
    }
    isSearching = false;
    update();
  }

  setMessages() {
    isSearched = false;
    isSearching = false;
    MessageController messageController = Get.find();
    if (messageController.conversations.isNotEmpty) {
      for (var conversation in messageController.conversations) {
        Map<String, dynamic> conversationMap = conversation.data()!;
        conversationMap.putIfAbsent("fromConversation", () => true);
        users.add(conversationMap);
      }
    }
    update();
  }

  String defineUserPhoto(bool fromConversation, Map<String, dynamic> user) {
    if (fromConversation) {
      if (user["from"] == FirebaseAuth.instance.currentUser!.uid) {
        return user["toPhoto"];
      } else {
        return user["fromPhoto"];
      }
    } else {
      return user["userPhoto"];
    }
  }

  String defineUserName(bool fromConversation, Map<String, dynamic> user) {
    if (fromConversation) {
      if (user["from"] == FirebaseAuth.instance.currentUser!.uid) {
        return user["toName"];
      } else {
        return user["fromName"];
      }
    } else {
      return user["name"];
    }
  }

  bool sendLoading = false;
  int sendedIndex = 0;

  Future sendRestaurant(Map<String, dynamic> user,
      Map<String, dynamic> restaurant, int index) async {
    sendedIndex = index;
    sendLoading = true;
    update();
    if (user["fromConversation"]) {
      String token;
      if (user["from"] == FirebaseAuth.instance.currentUser!.uid) {
        token = user["toToken"];
      } else {
        token = user["fromToken"];
      }
      await sendToConversation(user["conversationId"], user, restaurant, token);
      sendedIndex = index;
      sendLoading = false;
      update();
      Get.back();
      Get.snackbar(
        "Restoran göndərildi",
        "",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      bool status = await sendWithoutConversation(
          user["userId"], restaurant, user["token"] ?? "");
      if (status) {
        sendLoading = false;
        update();
        Get.back();
        Get.snackbar(
          "Restoran göndərildi",
          "",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        sendLoading = false;
        update();
        Get.snackbar(
          "Sizin bu istifadəçi ilə daha öncə mesajlaşmanız yoxdur",
          "",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future sendToConversation(String conversationId, Map<String, dynamic> user,
      Map<String, dynamic> restaurant, String token) async {
    ProfilePageController profilePageController = Get.find();
    DocumentReference messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc();
    DocumentReference conversationReference =
        firebaseFirestore.collection("Conversation").doc(conversationId);
    await firebaseFirestore.runTransaction<void>((transaction) async {
      await transaction.set(messageReference, {
        "conversationId": conversationId,
        "message": "",
        "from": firebaseAuth.currentUser!.uid,
        "to": 1,
        "newMessage": false,
        "date": DateTime.now(),
        "messageType": 2,
        "restaurantName": restaurant["restaurantName"],
        "restaurantImage": restaurant["restaurantImage"],
        "restaurantId": restaurant["restaurantId"],
        "facilityName": restaurant["facilityName"],
        "openTime": restaurant["openTime"],
        "closeTime": restaurant["closeTime"],
        "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
        "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
        "toToken": token,
      });
      await transaction.update(conversationReference, {
        "lastMessage": restaurant["restaurantName"],
        "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
        "lastMessageDate": DateTime.now(),
        "lastMessageType": 2,
        "lastMessageImage": restaurant["restaurantImage"],
      });
    });
  }

  GetStorage getStorage = GetStorage();

  Future<bool> sendWithoutConversation(
      String userId, Map<String, dynamic> restaurant, String token) async {
    ProfilePageController profilePageController = Get.find();
    String meId = await getStorage.read("userUid");
    QuerySnapshot<Map<String, dynamic>> conversation = await firebaseFirestore
        .collection("Conversation")
        .where("users", arrayContains: meId)
        .orderBy("createdDate")
        .get();
    List<Map<String, dynamic>> conversationMapped = [];
    for (var singleconversation in conversation.docs) {
      List users = singleconversation.data()["users"] ?? [];
      if (users.contains(userId)) {
        conversationMapped.add(singleconversation.data());
      }
    }
    if (conversationMapped.isNotEmpty) {
      DocumentReference messageReference = firebaseFirestore
          .collection("Conversation")
          .doc(conversationMapped.first["conversationId"])
          .collection("messages")
          .doc();
      DocumentReference conversationReference = firebaseFirestore
          .collection("Conversation")
          .doc(conversationMapped.first["conversationId"]);
      await firebaseFirestore.runTransaction<void>((transaction) async {
        await transaction.set(messageReference, {
          "conversationId": conversationMapped.first["conversationId"],
          "message": "",
          "from": firebaseAuth.currentUser!.uid,
          "to": 1,
          "newMessage": false,
          "date": DateTime.now(),
          "messageType": 2,
          "restaurantName": restaurant["restaurantName"],
          "restaurantImage": restaurant["restaurantImage"],
          "restaurantId": restaurant["restaurantId"],
          "facilityName": restaurant["facilityName"],
          "openTime": restaurant["openTime"],
          "closeTime": restaurant["closeTime"],
          "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
          "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
          "toToken": token,
        });
        await transaction.update(conversationReference, {
          "lastMessage": restaurant["restaurantName"],
          "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
          "lastMessageDate": DateTime.now(),
          "lastMessageType": 2,
          "lastMessageImage": restaurant["restaurantImage"],
        });
      });
      return true;
    } else {
      return false;
    }
  }
}
