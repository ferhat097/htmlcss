// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'MessageController.dart';
import 'ProfilePageController.dart';

class JoinPromotionController extends GetxController {
  @override
  void onClose() {
    promotionJoined?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    listenPromotionJoined();
    setMessages();
    super.onInit();
  }

  StreamSubscription? promotionJoined;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  listenPromotionJoined() {}

  bool isSearched = false;
  bool isSearching = false;
  Timer? timer;

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

  MessageController messageController = Get.find();

  setMessages() {
    isSearched = false;
    isSearching = false;
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

  Future sendRequest(Map<String, dynamic> user, Map<String, dynamic> promotion,
      int index) async {
    print("sennnn");
    sendedIndex = index;
    sendLoading = true;
    update();
    if (user["fromConversation"]) {
      String token;
      if (user["from"] == FirebaseAuth.instance.currentUser!.uid) {
        token = user["toToken"] ?? "";
      } else {
        token = user["fromToken"] ?? "";
      }
      print("sennnn2");
      await sendToConversation(user["conversationId"], user, promotion, token);
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
      await sendWithoutConversation(
        user["userId"],
        promotion,
        user["token"] ?? "",
        user,
      );

      sendLoading = false;
      update();
      Get.back();
      Get.snackbar(
        "Restoran göndərildi",
        "",
        snackPosition: SnackPosition.TOP,
      );
      //  else {
      //     sendLoading = false;
      //     update();
      //     Get.snackbar(
      //       "Sizin bu istifadəçi ilə daha öncə mesajlaşmanız yoxdur",
      //       "",
      //       snackPosition: SnackPosition.BOTTOM,
      //     );
      //   }
    }
  }

  ProfilePageController profilePageController = Get.find();

  Future sendToConversation(String conversationId, Map<String, dynamic> user,
      Map<String, dynamic> promotion, String token) async {
    DocumentReference messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc();
    DocumentReference conversationReference =
        firebaseFirestore.collection("Conversation").doc(conversationId);
    await firebaseFirestore.runTransaction<void>((transaction) async {
      transaction.set(messageReference, {
        "conversationId": conversationId,
        "from": firebaseAuth.currentUser!.uid,
        "date": DateTime.now(),
        "messageType": 5,
        "messageId": messageReference.id,
        "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
        "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
        "toToken": token,
        "promotionName": promotion["promotionName"],
        "award": promotion["award"] ?? 0,
        "currency": promotion["currency"] ?? "",
        "sponsorName": promotion["sponsorName"] ?? "",
        "sponsorSlogan": promotion["sponsorSlogan"] ?? "",
        "sponsorImage": promotion["sponsorImage"] ?? "",
        "sponsorType": promotion["sponsorType"] ?? 1,
        "sponsorId": promotion["sponsorId"] ?? "",
        "color": promotion["color"],
        "promotionId": promotion["promotionId"],
      });
      transaction.update(conversationReference, {
        "lastMessage": "Yarışmaya dəvət",
        "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
        "lastMessageDate": DateTime.now(),
        "lastMessageType": 5,
        "lastMessageImage": "",
      });
    });
  }

  GetStorage getStorage = GetStorage();

  Future sendWithoutConversation(
    String userId,
    Map<String, dynamic> promotion,
    String token,
    Map<String, dynamic> user,
  ) async {
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
        await firebaseFirestore.runTransaction<void>((transaction) async {
          transaction.set(messageReference, {
            "conversationId": conversationMapped.first["conversationId"],
            "from": firebaseAuth.currentUser!.uid,
            "date": DateTime.now(),
            "messageType": 5,
            "messageId": messageReference.id,
            "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
            "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
            "toToken": token,
            "promotionName": promotion["promotionName"],
            "award": promotion["award"] ?? 0,
            "currency": promotion["currency"] ?? "",
            "sponsorName": promotion["sponsorName"] ?? "",
            "sponsorSlogan": promotion["sponsorSlogan"] ?? "",
            "sponsorImage": promotion["sponsorImage"] ?? "",
            "sponsorType": promotion["sponsorType"] ?? 1,
            "sponsorId": promotion["sponsorId"] ?? "",
            "color": promotion["color"],
            "promotionId": promotion["promotionId"],
          });
          transaction.update(conversationReference, {
            "lastMessage": "Yarışmaya dəvət",
            "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
            "lastMessageDate": DateTime.now(),
            "lastMessageType": 5,
            "lastMessageImage": "",
          });
        });
      });

      return true;
    } else {
      await createConversation(userId, user, promotion);
    }
  }

  Future createConversation(
    String userId,
    Map<String, dynamic> user,
    Map<String, dynamic> promotion,
  ) async {
    DocumentReference<Map<String, dynamic>> conversationReference =
        firebaseFirestore.collection("Conversation").doc();
    DocumentReference<Map<String, dynamic>> messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationReference.id)
        .collection("messages")
        .doc();
    String fromName = profilePageController.meSocial!.data()!["name"] ?? "";
    String fromUserName = profilePageController.meSocial!.data()!["userName"];
    String fromPhoto =
        profilePageController.meSocial!.data()!["userPhoto"] ?? "";
    String fromToken = profilePageController.meSocial!.data()!["token"] ?? "";
    String toToken = user["token"];
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
        "to": userId,
        "toName": user["name"] ?? "",
        "toUserName": user["userName"] ?? "",
        "toPhoto": user["userPhoto"] ?? "",
        "conversationId": conversationReference.id,
        "users": [firebaseAuth.currentUser!.uid, userId],
        "lastOnlineFrom": true,
        "lastOnlineTo": true,
        "onlineTo": true,
        "onlineFrom": true,
        "lastMessage": "Yarışmaya dəvət",
        "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
        "lastMessageDate": DateTime.now(),
        "lastMessageType": 5,
        "lastMessageImage": "",
        "fromToken": fromToken,
        "toToken": toToken,
      });
      transaction.set(messageReference, {
        "conversationId": conversationReference.id,
        "from": firebaseAuth.currentUser!.uid,
        "date": DateTime.now(),
        "messageType": 5,
        "messageId": messageReference.id,
        "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
        "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
        "toToken": toToken,
        "promotionName": promotion["promotionName"],
        "award": promotion["award"] ?? 0,
        "currency": promotion["currency"] ?? "",
        "sponsorName": promotion["sponsorName"] ?? "",
        "sponsorSlogan": promotion["sponsorSlogan"] ?? "",
        "sponsorImage": promotion["sponsorImage"] ?? "",
        "sponsorType": promotion["sponsorType"] ?? 1,
        "sponsorId": promotion["sponsorId"] ?? "",
        "color": promotion["color"],
        "promotionId": promotion["promotionId"],
      });
    });
    Get.back();
    update();
  }
}
