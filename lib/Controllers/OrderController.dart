import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:foodmood/Controllers/TableSocialController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

import '../FirebaseRemoteConfigController.dart';

class OrderController extends GetxController {
  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription? orderListen;
  StreamSubscription? orderMenuListen;
  DocumentSnapshot<Map<String, dynamic>>? order;
  List<DocumentSnapshot<Map<String, dynamic>>> foods = [];
  List<DocumentSnapshot<Map<String, dynamic>>> messages = [];
  bool orderEnded = false;
  bool progressing = false;

  activeProgress(bool state) {
    progressing = state;
    update();
  }

  @override
  void onInit() {
    every1second();
    super.onInit();
  }

  @override
  void onClose() {
    orderListen?.cancel();
    orderMenuListen?.cancel();
    joinedMeStream?.cancel();
    joinedUserStream?.cancel();
    super.onClose();
  }

  StreamSubscription? joinedUserStream;
  StreamSubscription? joinedMeStream;
  QuerySnapshot<Map<String, dynamic>>? joinedUsers;
  DocumentSnapshot<Map<String, dynamic>>? meJoined;

  listenJoinedUser(String orderId) {
    joinedUserStream = firebaseFirestore
        .collection("Orders")
        .doc(orderId)
        .collection("joinedUsers")
        .snapshots()
        .listen(
      (joinedUsersQuery) {
        joinedUsers = joinedUsersQuery;
        update();
      },
    );
  }

  listenOrder(String restaurantId, int tableNumber, String orderId) async {
    listenOrderMenu(orderId);
    listenOrderMessage(orderId);
    orderListen =
        firebaseFirestore.collection("Orders").doc(orderId).snapshots().listen(
      (orderQuery) {
        if (orderQuery.data()!["active"]) {
          List<dynamic> userList = orderQuery.data()!["userList"];
          if (!userList.contains(firebaseAuth.currentUser!.uid)) {
            Get.back(closeOverlays: true);
            Get.delete<OrderController>(force: true);
          }
          order = orderQuery;
        } else {
          Get.back(closeOverlays: true);
          Get.delete<OrderController>(force: true);
        }
        update();
      },
    );
  }

  listenOrderMenu(String orderId) {
    orderMenuListen = firebaseFirestore
        .collection("Orders")
        .doc(orderId)
        .collection("foods")
        .orderBy("orderedStartTime", descending: true)
        .snapshots()
        .listen((foodsQuery) {
      foods = foodsQuery.docs;
      update();
    });
  }

  listenOrderMessage(String orderId) {
    orderMenuListen = firebaseFirestore
        .collection("Orders")
        .doc(orderId)
        .collection("messages")
        .snapshots()
        .listen((messagesQuery) {
      messages = messagesQuery.docs;
      update();
    });
  }

  Future createOrder(String restaurantId, int tableNumber) async {
    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("openTable");
    String orderPassword = randomNumeric(4);
    int orderPass = int.parse(orderPassword);
    HttpsCallableResult orderId = await httpsCallable.call(<String, dynamic>{
      "restaurantId": restaurantId,
      "tableNumber": tableNumber,
      "from": 3,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "orderPassword": orderPass
    });
    print(orderId.data);
    print("ok");
    listenOrder(restaurantId, tableNumber, orderId.data);
    listenJoinedUser(orderId.data);
  }

  ProfilePageController profilePageController = Get.find();

  Future joinOrder(String restaurantId, int tableNumber, String orderId) async {
    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("joinTable");
    HttpsCallableResult orderIdData =
        await httpsCallable.call(<String, dynamic>{
      "restaurantId": restaurantId,
      "tableNumber": tableNumber,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "orderId": orderId,
      "userPhoto": profilePageController.meSocial!.data()!["userPhoto"],
      "userName": profilePageController.meSocial!.data()!["userName"],
      "name": profilePageController.meSocial!.data()!["name"],
    });
    listenOrder(restaurantId, tableNumber, orderIdData.data);
    listenJoinedUser(orderIdData.data);
  }

  Future<String> payWithFoodMoodAccount() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithFoodMoodAccount");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "userId": firebaseAuth.currentUser!.uid,
      "orderId": order!.id
    });
    activeProgress(false);
    return result.data;
  }

  Future<String> payWithCoupon(String couponId) async {
    print(couponId);
    print(order!.id);
    print(firebaseAuth.currentUser!.uid);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithCoupon");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "userId": firebaseAuth.currentUser!.uid,
      "couponId": couponId,
      "orderId": order!.id,
    });
    print(result.data);
    activeProgress(false);
    return result.data;
  }

  Future payWithOnline() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithOnline");
    await httpsCallable.call();
  }

  Future<String> payWithCash() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithCash");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "userId": firebaseAuth.currentUser!.uid,
      "orderId": order!.id
    });
    activeProgress(false);
    return result.data;
  }

  Future payWithFoodMoodCredit() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithFoodMoodCredit");
    await httpsCallable.call();
  }

  Future payWithSendAwayCode() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("payWithSendAwayCode");
    await httpsCallable.call();
  }

  Future completeOrder(
      String restaurantId, int tableNumber, String orderId) async {
    print(restaurantId);
    print(tableNumber);
    print(orderId);
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("completeTableOrder");
    HttpsCallableResult result = await httpsCallable.call(<String, dynamic>{
      "restaurantId": restaurantId,
      "tableNumber": tableNumber,
      "orderId": orderId,
      "userId": FirebaseAuth.instance.currentUser!.uid
    });
    return result.data;
  }

  Future addUsertoOrder() async {
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("addUsertoTable");
    await httpsCallable.call();
  }

  Widget defineFoodStatus(bool status, Timestamp orderStart, String orderId,
      String foodId, int tableNumber,
      {Timestamp? orderComplete}) {
    if (status) {
      DateTime start = orderStart.toDate();
      DateTime end = orderComplete!.toDate();
      Duration result = end.difference(start);
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "${result.inMinutes.toString()} DQ",
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
        ),
      );
    } else {
      DateTime start = orderStart.toDate();
      DateTime now = DateTime.now();
      Duration result = start.difference(now);
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.yellow),
        child: Row(
          children: [
            // Container(
            //   height: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.red,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Material(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Colors.transparent,
            //     child: InkWell(
            //       borderRadius: BorderRadius.circular(20),
            //       onTap: () async {
            //         print("yes");
            //         // await canceledOrder(tableNumber, orderId, foodId);
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 4),
            //         child: Icon(
            //           Icons.close,
            //           size: 30,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "${(result.inMinutes) * (-1)} DQ",
                style: GoogleFonts.quicksand(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            // Container(
            //   height: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.green,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Material(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Colors.transparent,
            //     child: InkWell(
            //       borderRadius: BorderRadius.circular(20),
            //       onTap: () async {
            //         print("yes");
            //         //await checkOrderComplete(tableNumber, orderId, foodId);
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 4),
            //         child: Icon(
            //           Icons.check,
            //           size: 30,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      );
    }
  }

  Timer? timer;
  every1second() {
    timer = Timer.periodic(Duration(seconds: 1), updateEndTime);
  }

  updateEndTime(Timer timer) {
    update(["endTime"], true);
  }

  PageController orderPageController = PageController();

  FirebaseRemoteConfigController firebaseRemoteConfigController = Get.find();

  Widget defineFoodImage(String? foodImage, int categoryId) {
    if (foodImage != null && foodImage.isNotEmpty) {
      return Image.network(
        foodImage,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    } else {
      return Image.network(
        firebaseRemoteConfigController.menuCategory.entries
            .where((element) => element.value["categoryId"] == categoryId)
            .first
            .value["categoryPhoto"],
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    }
  }

  ImageProvider defineUserImage(String? imageUrl) {
    if (imageUrl != null) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage("assets/personal.png");
    }
  }
}
