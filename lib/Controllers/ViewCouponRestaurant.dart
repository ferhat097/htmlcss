import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ViewCouponRestaurant extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> couponsRestaurant = [];
  @override
  void onInit() {
    super.onInit();
  }

  Future getRestaurant(String couponId) async {
    QuerySnapshot<Map<String, dynamic>> couponQuery = await firebaseFirestore
        .collection("Coupons")
        .doc(couponId)
        .collection("Restaurants")
        .get();
    couponsRestaurant = couponQuery.docs;
    update();
  }
}
