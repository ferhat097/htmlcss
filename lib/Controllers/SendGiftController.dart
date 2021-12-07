// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';

class SendGiftController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ProfilePageController profilePageController = Get.find();

  Future sendGift(
    int neededMoodx,
    bool fromConversation,
    String userId,
    Map<String, dynamic> gift,
    Map<String, dynamic>? user,
    String? token,
    String? toName,
    int percentage,
  ) async {
    int moodx = profilePageController.meSocial!.data()!["moodx"] ?? 0;
    if (moodx >= neededMoodx) {
      await send(
        fromConversation,
        userId,
        gift,
        neededMoodx,
        user!,
        token,
        toName,
        percentage,
      );
    } else {
      Get.snackbar(
        "Sizdə lazımı qədər moodX yoxdur.",
        "MoodX artırmaq üçün profilinizdə reklam izləyə bilərsiniz.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future send(
    bool fromConversation,
    String userId,
    Map<String, dynamic> gift,
    int neededMoodx,
    Map<String, dynamic> user,
    String? token,
    String? toName,
    int percentage,
  ) async {
    if (fromConversation) {
      await sendToConversation(
        userId,
        gift,
        token!,
        toName!,
        percentage,
      );
    } else {
      await sendWithoutConversation(
        userId,
        gift,
        neededMoodx,
        user,
        percentage,
      );
    }
  }

  Future sendToConversation(
    String conversationId,
    Map<String, dynamic> gift,
    String token,
    String toName,
    percentage,
  ) async {
    int earnedMoodx;
    int percent = (gift["moodx"] ~/ 100) * percentage;
    if (percentage != 0 && percent <= 0) {
      earnedMoodx = gift["moodx"] - 1;
    } else {
      earnedMoodx = gift["moodx"] - percent;
    }
    DocumentReference messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc();
    DocumentReference conversationReference =
        firebaseFirestore.collection("Conversation").doc(conversationId);
    DocumentReference backMoodxReference =
        firebaseFirestore.collection("General").doc("backMoodx");
    await firebaseFirestore.runTransaction<void>((transaction) async {
      transaction.set(messageReference, {
        "conversationId": conversationId,
        "message": "",
        "from": firebaseAuth.currentUser!.uid,
        "to": 1,
        "newMessage": false,
        "date": DateTime.now(),
        "messageType": 3,
        "giftName": gift["giftName"],
        "moodx": gift["moodx"],
        "level": gift["level"],
        "id": gift["giftId"],
        "image": gift["image"],
        "accepted": false,
        "messageId": messageReference.id,
        "toToken": token,
        "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
        "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
        "toName": toName,
        "percentage": percentage,
        "earnedMoodx": earnedMoodx,
      });
      transaction.update(conversationReference, {
        "lastMessage": gift["giftName"],
        "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
        "lastMessageDate": DateTime.now(),
        "lastMessageType": 3,
        "lastMessageImage": gift["image"],
        "accepted": false,
      });
      transaction.update(
        backMoodxReference,
        {
          "total": FieldValue.increment(gift["moodx"] - earnedMoodx),
          "fromGift": FieldValue.increment(1),
        },
      );
    });
    Get.back();
  }

  Future sendWithoutConversation(
    String userId,
    Map<String, dynamic> gift,
    int neededMoodx,
    Map<String, dynamic>? user,
    int percentage,
  ) async {
    int earnedMoodx;
    int percent = (gift["moodx"] ~/ 100) * percentage;
    if (percentage != 0 && percent <= 0) {
      earnedMoodx = gift["moodx"] - 1;
    } else {
      earnedMoodx = gift["moodx"] - percent;
    }
    String meId = firebaseAuth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> conversation = await firebaseFirestore
        .collection("Conversation")
        .where("users", arrayContains: meId)
        .where("deleted", isEqualTo: false)
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
      DocumentReference meSocialReference =
          firebaseFirestore.collection("FoodMoodSocial").doc(meId);
      DocumentReference backMoodxReference =
          firebaseFirestore.collection("General").doc("backMoodx");
      await firebaseFirestore.runTransaction<void>((transaction) async {
        transaction.set(messageReference, {
          "accepted": false,
          "conversationId": conversationMapped.first["conversationId"],
          "messageId": messageReference.id,
          "message": "",
          "from": firebaseAuth.currentUser!.uid,
          "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
          "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
          "to": 1,
          "newMessage": false,
          "date": DateTime.now(),
          "messageType": 3,
          "giftName": gift["giftName"],
          "moodx": gift["moodx"],
          "level": gift["level"],
          "id": gift["giftId"],
          "image": gift["image"],
          "toToken": user!["token"],
          "toName": user["name"],
          "percentage": percentage,
          "earnedMoodx": earnedMoodx,
        });
        transaction.update(conversationReference, {
          "lastMessage": gift["giftName"],
          "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
          "lastMessageDate": DateTime.now(),
          "lastMessageType": 3,
          "lastMessageImage": gift["image"],
        });
        transaction.update(
          meSocialReference,
          {
            "moodx": FieldValue.increment(-neededMoodx),
          },
        );
        transaction.update(
          backMoodxReference,
          {
            "total": FieldValue.increment(gift["moodx"] - earnedMoodx),
            "fromGift": FieldValue.increment(1),
          },
        );
      });
      Get.back();
    } else {
      await createConversation(
        userId,
        user!,
        gift,
        percentage,
      );
    }
  }

  Future createConversation(
    String userId,
    Map<String, dynamic> user,
    Map<String, dynamic> gift,
    int percentage,
  ) async {
    int earnedMoodx;
    int percent = (gift["moodx"] ~/ 100) * percentage;
    if (percentage != 0 && percent <= 0) {
      earnedMoodx = gift["moodx"] - 1;
    } else {
      earnedMoodx = gift["moodx"] - percent;
    }

    //print(user);
    DocumentReference<Map<String, dynamic>> conversationReference =
        firebaseFirestore.collection("Conversation").doc();
    DocumentReference<Map<String, dynamic>> messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationReference.id)
        .collection("messages")
        .doc();
    DocumentReference backMoodxReference =
        firebaseFirestore.collection("General").doc("backMoodx");
    String fromName = profilePageController.meSocial!.data()!["name"] ?? "";
    String fromUserName = profilePageController.meSocial!.data()!["userName"];
    String fromPhoto =
        profilePageController.meSocial!.data()!["userPhoto"] ?? "";
    String fromToken = profilePageController.meSocial!.data()!["token"] ?? "";
    bool onlineTo = user["showOnline"] ?? false;
    bool onlineFrom =
        profilePageController.meSocial!.data()!["showOnline"] ?? false;
    bool lastOnlineTo = user["showLastSeen"] ?? false;
    bool lastOnlineFrom =
        profilePageController.meSocial!.data()!["showLastSeen"] ?? false;
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.set(conversationReference, {
        "accepted": false,
        "archive": false,
        "deleted": false,
        "createdDate": DateTime.now(),
        "from": firebaseAuth.currentUser!.uid,
        "fromName": fromName,
        "fromUserName": fromUserName,
        "fromPhoto": fromPhoto,
        "fromToken": fromToken,
        "to": userId,
        "toName": user["name"] ?? "",
        "toUserName": user["userName"] ?? "",
        "toPhoto": user["userPhoto"] ?? "",
        "toToken": user["token"] ?? "",
        "conversationId": conversationReference.id,
        "users": [firebaseAuth.currentUser!.uid, userId],
        "lastOnlineFrom": lastOnlineFrom,
        "lastOnlineTo": lastOnlineTo,
        "onlineTo": onlineTo,
        "onlineFrom": onlineFrom,
        "lastMessage": gift["giftName"],
        "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
        "lastMessageDate": DateTime.now(),
        "lastMessageType": 3,
        "lastMessageImage": gift["image"],
      });
      transaction.set(messageReference, {
        "accepted": false,
        "conversationId": conversationReference.id,
        "messageId": messageReference.id,
        "message": "",
        "from": firebaseAuth.currentUser!.uid,
        "fromName": fromName,
        "fromToken": fromToken,
        "to": 1,
        "newMessage": false,
        "date": DateTime.now(),
        "messageType": 3,
        "giftName": gift["giftName"],
        "moodx": gift["moodx"],
        "earnedMoodx": earnedMoodx,
        "level": gift["level"],
        "id": gift["giftId"],
        "image": gift["image"],
        "toName": user["name"],
        "toToken": user["token"],
        "percentage": percentage,
      });
      transaction.update(
        backMoodxReference,
        {
          "total": FieldValue.increment(gift["moodx"] - earnedMoodx),
          "fromGift": FieldValue.increment(1),
        },
      );
    });
    Get.back();
    update();
  }
}
