// ignore_for_file: file_names, void_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Models/PresenceModel.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageFood.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageGift.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageInvite.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageRestaurant.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageText.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail/MessageVoice.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageDetailController extends GetxController {
  @override
  onClose() {
    streamUser?.cancel();
    streamConversation?.cancel();
    timer?.cancel();
    timerForInvite?.cancel();
    //streamSubscription?.cancel();
    userPresenceSubs?.cancel();
    super.onClose();
  }

  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  //message detail
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  StreamSubscription? streamUser;
  StreamSubscription? streamConversation;
  //StreamSubscription? streamSubscription;
  StreamSubscription? userPresenceSubs;
  String? conversationId;

  DocumentSnapshot<Map<String, dynamic>>? user;
  PresenceModel? presenceModel;
  bool userOnline = false;
  DocumentSnapshot<Map<String, dynamic>>? conversation;
  Stream<QuerySnapshot<Map<String, dynamic>>> loadMessages() async* {
    yield* firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
  }

  listenConversation(String conversationId) {
    streamConversation = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .snapshots()
        .listen((event) {
      conversation = event;
      print("okk");
      print(conversation);
      update();
    });
    return streamConversation;
    //listenUser("AQ8ys0e2RYPbaG8Ifa6Gk4n7gkz2");
  }

  listenUser(String userId) {
    streamUser = firebaseFirestore
        .collection("FoodMoodSocial")
        .doc(userId)
        .snapshots()
        .listen((userQuery) {
      user = userQuery;
      update();
    });
  }

  // listenDatabase() async {
  //   print("databaselistened");
  //   FirebaseDatabase firebasePresence = FirebaseDatabase(
  //       databaseURL: "https://foodmood-messages.firebaseio.com/");
  //   streamSubscription = firebasePresence
  //       .reference()
  //       .child("/con1/messages")
  //       .orderByChild("date")
  //       .onValue
  //       .listen((event) {
  //     event.snapshot.value;
  //   });
  // }

  listenPrensence(String userId) {
    FirebaseDatabase firebasePresence = FirebaseDatabase(
        databaseURL: "https://foodmood-presence.firebaseio.com/");
    userPresenceSubs = firebasePresence
        .reference()
        .child("/$userId")
        .onValue
        .listen((userPresenceQuery) {
      if (userPresenceQuery.snapshot.exists) {
        //userPresence = jsonDecode(userPresenceQuery.snapshot.toString());
        //userOnline = userPresenceQuery.snapshot.value["online"];
        presenceModel = PresenceModel(
          online: userPresenceQuery.snapshot.value["online"] ?? false,
          date: userPresenceQuery.snapshot.value["date"] ?? "",
        );
      }
      print(presenceModel!.online);
      update();
    });
  }

  String presence(int date, bool online, bool lastOnlineDate, bool showOnline) {
    if (showOnline) {
      if (online) {
        return "Xətdə";
      } else {
        if (lastOnlineDate) {
          DateTime lastOnlineDate = DateTime.fromMillisecondsSinceEpoch(date);
          DateTime lastOnlineDay = DateTime(
              lastOnlineDate.year, lastOnlineDate.month, lastOnlineDate.day);
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          String hour;
          String minute;
          if (lastOnlineDate.hour >= 10) {
            hour = "${lastOnlineDate.hour}";
          } else {
            hour = "0${lastOnlineDate.hour}";
          }
          if (lastOnlineDate.minute >= 10) {
            minute = "${lastOnlineDate.minute}";
          } else {
            minute = "0${lastOnlineDate.minute}";
          }
          if (lastOnlineDay == today) {
            return "Son görülmə: $hour:$minute";
          } else {
            DateFormat dateFormat = DateFormat.MMMM("az_AZ");
            return "Son görülmə: ${lastOnlineDay.day} ${dateFormat.format(lastOnlineDay)} $hour:$minute";
          }
        } else {
          return "Xətdə deyil";
        }
      }
    } else {
      return "bilinmir";
    }
  }

  Color presenceIndicatorColor(bool showOnline, bool online) {
    if (showOnline) {
      if (online) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      return Colors.yellow;
    }
  }

  Future setOnline() async {
    String from = conversation!.data()!["from"];
    String field;
    if (from == firebaseAuth.currentUser!.uid) {
      field = "onlineFrom";
    } else {
      field = "onlineTo";
    }
    bool currentStatus = conversation!.data()![field];
    await firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .update({
      field: !currentStatus,
    });
  }

  Future setLastSeen() async {
    String from = conversation!.data()!["from"];
    String field;
    if (from == firebaseAuth.currentUser!.uid) {
      field = "lastOnlineFrom";
    } else {
      field = "lastOnlineTo";
    }
    bool currentStatus = conversation!.data()![field];
    await firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .update({
      field: !currentStatus,
    });
  }

  Future acceptConversation() async {
    await firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .update(
      {
        "accepted": true,
      },
    );
  }

  TextEditingController messageController = TextEditingController();

  ////////////////
  bool newMessage = true;
  //String conversationId = "";
  bool wait = false;

  // Future sendNewMessage(
  //     {String? fromName,
  //     String? toName,
  //     String? toId,
  //     String? fromPhoto,
  //     String? toPhoto,
  //     String? fromToken,
  //     String? toToken,
  //     String? fromUserName,
  //     String? toUserName}) async {
  //   wait = true;
  //   update();

  //   if (newMessage) {
  //     String newConversationReference =
  //         firebaseFirestore.collection("Conversation").doc().id;
  //     conversationId = newConversationReference;
  //   }
  //   HttpsCallable httpsCallable =
  //       firebaseFunctions.httpsCallable("sendMessage");
  //   print(conversationId);

  //   await httpsCallable.call(<String, dynamic>{
  //     "conversationId": conversationId,
  //     "message": messageController.text,
  //     "from": firebaseAuth.currentUser!.uid,
  //     "to": 1,
  //     "newMessage": newMessage,
  //     "fromName": fromName,
  //     "toName": toName,
  //     "toId": toId,
  //     "fromPhoto": fromPhoto,
  //     "toPhoto": toPhoto,
  //     "fromToken": fromToken,
  //     "toToken": toToken,
  //     "fromUserName": fromUserName,
  //     "toUserName": toUserName
  //   });

  //   wait = false;
  //   newMessage = false;
  //   update();
  // }

  Future sendMessage() async {
    print("ok1");
    wait = true;
    update();
    if (defineAvailable(user!.id)) {
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
          "message": messageController.text,
          "from": firebaseAuth.currentUser!.uid,
          "to": 1,
          "newMessage": false,
          "date": DateTime.now(),
          "messageType": 1,
          "messageId": messageReference.id,
          "fromToken": profilePageController.meSocial!.data()!["token"],
          "toToken": user!.data()!["token"],
          "fromName": profilePageController.meSocial!.data()!["name"],
          "toName": user!.data()!["toName"],
        });
        await transaction.update(conversationReference, {
          "lastMessage": messageController.text,
          "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
          "lastMessageDate": DateTime.now(),
          "lastMessageType": 1,
        });
      });
      print("seneded");
      // HttpsCallable httpsCallable =
      //     firebaseFunctions.httpsCallable("sendMessage");
      // await httpsCallable.call(<String, dynamic>{
      //   "conversationId": conversationId,
      //   "message": messageController.text,
      //   "from": firebaseAuth.currentUser!.uid,
      //   "to": 1,
      //   "newMessage": false,
      // });

      messageController.clear();
    } else {
      Get.snackbar("Bu istifadəçiyə mesaj yaza bilməzsiniz",
          "Bu istifadəçiyə mesaj yaza bilmək üçün sizin göndərdiyin hədiyən qəbul etməlidir.");
    }

    wait = false;
    update();
  }

  bool searchingConversation = true;

  // Future checkConversationExist(String userId) async {
  //   QuerySnapshot<Map<String, dynamic>> conversation = await firebaseFirestore
  //       .collection("Conversation")
  //       .where("users", arrayContains: userId)
  //       .where("archive", isEqualTo: false)
  //       .get();
  //   if (conversation.docs.isEmpty) {
  //     searchingConversation = false;
  //   } else if (conversation.docs.first.exists) {
  //     conversationId = conversation.docs.first.id;
  //     newMessage = false;
  //     searchingConversation = false;
  //   }
  //   update();
  // }

  Future blockUser(String userId, bool block) async {
    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("blockUser");
    await httpsCallable.call(<String, dynamic>{
      "userId": userId,
      "meId": firebaseAuth.currentUser!.uid,
      "block": block
    });
  }

  Future deleteChat(String conversationId) async {
    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("deleteChat");
    await httpsCallable
        .call(<String, dynamic>{"conversationId": conversationId});
  }

  Future reportMessage(String reportedMessage, String reportedUserId,
      String conversationId) async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("reportMessage");
    await httpsCallable.call(<String, dynamic>{
      "reportMessage": reportedMessage,
      "reporterUserId": firebaseAuth.currentUser!.uid,
      "reportedUserId": reportedUserId,
      "conversationId": conversationId,
    });
  }

  bool start = false;

  GetStorage getStorage = GetStorage();
  ////////////////////////////////////////////////////////////////////////////////////////////////
  Future setWithoutConversation(
      String userId, Map<String, dynamic> user) async {
    listenUser(userId);
    listenPrensence(userId);
    String meId = await getStorage.read("userUid");
    QuerySnapshot<Map<String, dynamic>> conversation = await firebaseFirestore
        .collection("Conversation")
        .where("users", arrayContains: meId)
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate")
        .get();
    print("conversation ${conversation.docs.length}");
    List<Map<String, dynamic>> conversationMapped = [];
    for (var singleconversation in conversation.docs) {
      List users = singleconversation.data()["users"] ?? [];
      if (users.contains(userId)) {
        conversationMapped.add(singleconversation.data());
      }
    }
    print("conversationMapped ${conversationMapped.length}");
    if (conversationMapped.isEmpty) {
      await createConversation(meId, userId, user);
      listenConversation(conversationId!);
      //listenDatabase();
      //listenUser(userId);
    } else {
      listenConversation(conversationMapped.first["conversationId"]);
      //listenUser(userId);
      //listenDatabase();
      conversationId = conversationMapped.first["conversationId"];
      start = true;
      update();
    }
  }

  ProfilePageController profilePageController = Get.find();

  Future createConversation(
      String meId, String userId, Map<String, dynamic> user) async {
    DocumentReference<Map<String, dynamic>> conversationReference =
        firebaseFirestore.collection("Conversation").doc();
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
    await conversationReference.set({
      "accepted": false,
      "archive": false,
      "deleted": false,
      "createdDate": DateTime.now(),
      "from": meId,
      "fromName": fromName,
      "fromUserName": fromUserName,
      "fromPhoto": fromPhoto,
      "lastMessage": "",
      "lastMessageFrom": "",
      "lastMessageDate": DateTime.now(),
      "to": userId,
      "toName": user["name"] ?? "",
      "toUserName": user["userName"] ?? "",
      "toPhoto": user["userPhoto"] ?? "",
      "conversationId": conversationReference.id,
      "users": [meId, userId],
      "lastOnlineFrom": lastOnlineFrom,
      "lastOnlineTo": lastOnlineTo,
      "onlineTo": onlineTo,
      "onlineFrom": onlineFrom,
      "toToken": user["token"],
      "fromToken": fromToken,
    });
    print("ok");
    conversationId = conversationReference.id;
    start = true;
    update();
  }

  // Future setRead() async {
  //   firebaseFirestore
  //       .collection("Conversation")
  //       .doc("s")
  //       .collection("messages")
  //       .where("read", isEqualTo: false)

  // }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void setWithConversation(String currentconversationId) async {
    print("without1");
    conversationId = currentconversationId;
    listenConversation(currentconversationId);
    await Future.delayed(const Duration(milliseconds: 500));
    if (conversation != null) {
      String userId;
      if (conversation!.data()!["from"] ==
          FirebaseAuth.instance.currentUser!.uid) {
        userId = conversation!.data()!["to"];
      } else {
        userId = conversation!.data()!["from"];
      }
      listenUser(userId);
      listenPrensence(userId);
      //listenDatabase();
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      String userId;
      if (conversation!.data()!["from"] ==
          FirebaseAuth.instance.currentUser!.uid) {
        userId = conversation!.data()!["to"];
      } else {
        userId = conversation!.data()!["from"];
      }
      listenUser(userId);
      listenPrensence(userId);
      // listenDatabase();
    }
    print("without2");
    start = true;
    update();
  }

  //definelast online
  String defineLastOnline(Timestamp? timestamp, bool lastOnlineOpen) {
    if (lastOnlineOpen) {
      DateTime lastOnline = timestamp!.toDate();
      int hours = lastOnline.hour;
      int minute = lastOnline.minute;
      return "$hours : $minute";
    } else {
      return "Xətdə deyil";
    }
  }

  String defineOnline(bool lastOnlineOpen) {
    if (lastOnlineOpen) {
      return "Xətdə";
    } else {
      return "";
    }
  }

  defineMessage(Map<String, dynamic> message, int index) {
    if (message["messageType"] != null) {
      if (message["messageType"] == 1) {
        return MessageText(
          message: message["message"],
          timestamp: message["date"],
        );
      } else if (message["messageType"] == 2) {
        return MessageRestaurant(
          url: message["restaurantImage"],
          name: message["restaurantName"],
          restaurantId: message["restaurantId"],
          timeStamp: message["date"],
        );
      } else if (message["messageType"] == 3) {
        return MessageGift(
          message: message,
          timeStamp: message["date"],
          from: message["from"],
        );
      } else if (message["messageType"] == 4) {
        return MessageVoice(
          url: message["message"],
          seconds: message["duration"] ?? 0,
          index: index,
          timestamp: message["date"],
        );
      } else if (message["messageType"] == 5) {
        return PromotionInvite(
          promotion: message,
          accepted: message["accepted"],
        );
      } else if (message["messageType"] == 6) {
        return MessageFood(
          message: message,
        );
      }
    } else {
      return MessageText(
        message: message["message"],
        timestamp: message["date"],
      );
    }
  }

  bool defineAvailable(String userId) {
    List likedUsers =
        profilePageController.meSocial!.data()!["likedUsers"] ?? [];
    List likerUsers =
        profilePageController.meSocial!.data()!["likerUsers"] ?? [];
    bool available = conversation!.data()!["accepted"] ?? false;
    if (likedUsers.contains(userId) && likerUsers.contains(userId)) {
      return true;
    } else {
      if (available) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool defineType3Color(int type, bool accepted) {
    if (type == 3 && accepted) {
      return true;
    } else {
      return false;
    }
  }

  Future acceptGift(
    String conversationId,
    String messageId,
    int moodx,
  ) async {
    // FirebaseDatabase firebaseDatabase = FirebaseDatabase(
    //     databaseURL: "https://foodmood-messages.firebaseio.com/");
    // FirebaseDatabase firebasePresence = FirebaseDatabase(
    //     databaseURL: "https://foodmood-presence.firebaseio.com/");
    // await firebaseDatabase
    //     .reference()
    //     .child("messages/${firebaseAuth.currentUser!.uid}")
    //     .set({
    //   "accepted": true,
    //   "acceptedDate": DateTime.now().millisecondsSinceEpoch,
    // });
    // DataSnapshot dataSnapshot = await firebaseDatabase
    //     .reference()
    //     .child("messages/${firebaseAuth.currentUser!.uid}")
    //     .get();
    // print(dataSnapshot.value);
    // await firebasePresence
    //     .reference()
    //     .child("/${firebaseAuth.currentUser!.uid}")
    //     .set({"online": true});

    DocumentReference messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc(messageId);
    String meId = firebaseAuth.currentUser!.uid;
    DocumentReference conversationReference =
        firebaseFirestore.collection("Conversation").doc(conversationId);
    DocumentReference meReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(meId);
    DocumentReference<Map<String, dynamic>> moodxReference =
        meReference.collection("moodx").doc();
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.update(messageReference, {
        "accepted": true,
        "acceptedDate": DateTime.now(),
      });
      transaction.update(conversationReference, {
        "accepted": true,
      });
      transaction.update(meReference, {
        "gifts": FieldValue.increment(1),
        "moodx": FieldValue.increment(moodx)
      });
      transaction.set(moodxReference, {
        "date": DateTime.now(),
        "moodx": moodx,
        "isIncome": true,
        "isADS": false,
        "messageId": messageId,
        "conversationId": conversationId,
      });
    });
  }

  ////audio
  AudioSource theSource = AudioSource.microphone;
  Codec codec = Codec.aacADTS;
  String mPath = '${DateTime.now().millisecondsSinceEpoch}';
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  FlutterSoundHelper flutterSoundHelper = FlutterSoundHelper();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  @override
  InternalFinalCallback<void> get onDelete => super.onDelete;

  @override
  void onInit() {
    setUpdateInvite();
    initalizeMic();
    super.onInit();
  }

  Future initalizeMic() async {
    await mRecorder!.openAudioSession();
  }

  bool recorded = false;
  Timer? timer;
  int time = 0;

  Future startRecord() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    recorded = true;
    update();
    await mRecorder!.openAudioSession();
    await mRecorder!.startRecorder(
      toFile: mPath,
      audioSource: theSource,
    );
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time++;
      update(["time"]);
    });
  }

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future stopRecord() async {
    String? url = await mRecorder!.stopRecorder();
    timer!.cancel();
    time = 0;
    recorded = false;
    update();
    Duration? duration = await flutterSoundHelper.duration(url!);
    int seconds = duration!.inSeconds;
    File file = File(url);
    print(duration);

    if (defineAvailable(user!.id)) {
      Reference reference = firebaseStorage.ref(
          "Conversation/$conversationId/audio/${DateTime.now().millisecondsSinceEpoch}");
      await reference.putFile(file);
      String urls = await reference.getDownloadURL();
      print(urls);
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
          "message": urls,
          "duration": seconds,
          "from": firebaseAuth.currentUser!.uid,
          "to": 1,
          "newMessage": false,
          "date": DateTime.now(),
          "messageType": 4,
          "messageId": messageReference.id,
          "toToken": user!["token"],
          "fromName": profilePageController.meSocial!.data()!["name"] ?? "",
          "fromToken": profilePageController.meSocial!.data()!["token"] ?? "",
        });
        await transaction.update(conversationReference, {
          "lastMessage": "Voice",
          "lastMessageFrom": FirebaseAuth.instance.currentUser!.uid,
          "lastMessageDate": DateTime.now(),
          "lastMessageType": 4,
        });
      });
    } else {
      Get.snackbar("Bu istifadəçiyə mesaj yaza bilməzsiniz",
          "Bu istifadəçiyə mesaj yaza bilmək üçün sizin göndərdiyin hədiyən qəbul etməlidir.");
    }
  }

  int playedIndex = 0;
  bool isPlaying = false;

  Future playMessage(String uri, int index) async {
    await mPlayer!.openAudioSession();
    playedIndex = index;
    isPlaying = true;
    update();
    await mPlayer!.startPlayer(
      fromURI: uri,
      whenFinished: () {
        isPlaying = false;
        update();
        mPlayer!.stopPlayer();
        mPlayer!.closeAudioSession();
      },
    );
  }

  Future stopMessage() async {
    isPlaying = false;
    update();
    mPlayer!.stopPlayer();
    mPlayer!.closeAudioSession();
  }

  Future deleteRecord(String fileName) async {
    recorded = false;
    update();
    mRecorder!.stopRecorder();
    mRecorder!.deleteRecord(fileName: fileName);
    timer!.cancel();
    time = 0;
  }

  String defineVoiceDuration(int seconds) {
    if (seconds < 60) {
      if (seconds < 10) {
        return "0:0$seconds";
      } else {
        return "0:$seconds";
      }
    } else {
      int minutes = seconds ~/ 60;
      int newseconds = seconds - (minutes * 60);
      if (newseconds < 10) {
        return "$minutes:0$newseconds";
      } else {
        return "$minutes:$newseconds";
      }
    }
  }

  ///invite
  Timer? timerForInvite;
  void setUpdateInvite() {
    timerForInvite = Timer.periodic(const Duration(seconds: 1), (timer) {
      update(["timerForInvite"]);
    });
  }

  Future acceptInvitation(String messageId, String conversationId,
      String promotionId, String userId) async {
    String meId = firebaseAuth.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> messageReference = firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc(messageId);
    DocumentReference<Map<String, dynamic>> promotionReference =
        firebaseFirestore.collection("Promotion").doc(promotionId);
    DocumentReference<Map<String, dynamic>> promotionJoinedReference =
        firebaseFirestore
            .collection("Promotion")
            .doc(promotionId)
            .collection("joinedUsers")
            .doc();
    await firebaseFirestore.runTransaction((transaction) async {
      bool available = false;
      DocumentSnapshot<Map<String, dynamic>> promotion =
          await transaction.get(promotionReference);
      List joinedUsers = promotion.data()!["joinedList"];
      bool withTime = promotion.data()!["withTime"];
      if (!joinedUsers.contains(meId) && !joinedUsers.contains(userId)) {
        if (withTime) {
          Timestamp endedTime = promotion.data()!["endedTime"];
          DateTime endedDate = endedTime.toDate();
          DateTime nowDate = DateTime.now();
          Duration duration = endedDate.difference(nowDate);
          if (duration.inSeconds < 60) {
            available = false;
            return Get.snackbar("Yarışma bitmək üzərədir!",
                "Yarışmanın bitməsinə son 60 saniyə qaldıqda qoşula bilməzsiniz");
          } else {
            available = true;
          }
        } else {
          int joinedUsers = promotion.data()!["joinedUsers"];
          int joinForEnded = promotion.data()!["joinForEnded"];
          if (joinForEnded - joinedUsers <= 0) {
            available = false;
            return Get.snackbar("Yarışmaya qoşulma limiti bitib!",
                "Bu yarışma üçün qoşulma limiti $joinForEnded nəfər idi");
          } else {
            available = true;
          }
        }
      } else {
        available = false;
        if (joinedUsers.contains(userId)) {
          return Get.snackbar("Qarşı tərəf artıq bu yarışmaya qoşulub!", "");
        } else {
          return Get.snackbar("Siz artıq bu yarışmaya qoşulubsunuz!", "");
        }
      }

      if (available) {
        String fromPhoto;
        String toPhoto;
        String toName;
        String fromName;
        String toToken;
        String fromToken;
        if (conversation!.data()!["from"] == firebaseAuth.currentUser!.uid) {
          fromPhoto = conversation!.data()!["toPhoto"] ?? "";
          toPhoto = conversation!.data()!["fromPhoto"] ?? "";
          toName = conversation!.data()!["fromName"] ?? "";
          fromName = conversation!.data()!["toName"] ?? "";
          toToken = conversation!.data()!["fromToken"] ?? "";
          fromToken = conversation!.data()!["toToken"] ?? "";
        } else {
          fromPhoto = conversation!.data()!["fromPhoto"] ?? "";
          toPhoto = conversation!.data()!["toPhoto"] ?? "";
          toName = conversation!.data()!["toName"] ?? "";
          fromName = conversation!.data()!["fromName"] ?? "";
          toToken = conversation!.data()!["toToken"] ?? "";
          fromToken = conversation!.data()!["fromToken"] ?? "";
        }
        transaction.update(messageReference, {
          "accepted": true,
        });
        transaction.update(promotionReference, {
          "joinedList": FieldValue.arrayUnion([meId, userId]),
          "joinedUsers": FieldValue.increment(2),
        });
        transaction.set(promotionJoinedReference, {
          "users": [meId, userId],
          "from": userId,
          "to": meId,
          "date": DateTime.now(),
          "reference": promotionJoinedReference.id,
          "fromPhoto": fromPhoto,
          "toPhoto": toPhoto,
          "fromName": toName,
          "toName": fromName,
          "toToken": toToken,
          "fromToken": fromToken,
        });
      }
    });
  }

  Future deleteMessage(String messageId) async {
    await firebaseFirestore
        .collection("Conversation")
        .doc(conversationId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}
