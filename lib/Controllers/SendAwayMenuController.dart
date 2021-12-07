import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SendAwayMenuController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> sendAwayFoods = [];
  Future getSendAwayMenu(String orderId, String sendAwayId) async {
    QuerySnapshot<Map<String, dynamic>> sendAwayFoodQuery =
        await firebaseFirestore
            .collection("Orders")
            .doc(orderId)
            .collection("sendAway")
            .doc(sendAwayId)
            .collection("foods")
            .get();
    sendAwayFoods = sendAwayFoodQuery.docs;
    update();
  }
}
