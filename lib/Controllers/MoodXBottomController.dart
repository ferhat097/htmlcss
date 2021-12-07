// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MoodXBottomController extends GetxController {
  @override
  void onInit() {
    if (getStorage.hasData("moodxDate")) {
      int dateTimeEpoch = getStorage.read("moodxDate");
      DateTime moodxDate = DateTime.fromMillisecondsSinceEpoch(dateTimeEpoch);
      print(moodxDate);
      DateTime dateTimeNow = DateTime.now();
      int difference = DateTime(
              dateTimeNow.year, dateTimeNow.month, dateTimeNow.day)
          .difference(DateTime(moodxDate.year, moodxDate.month, moodxDate.day))
          .inDays;
      print(difference);
      if (difference > 0) {
        getStorage.write("moodxTime", 0);
      }
    }

    if (getStorage.hasData("moodxTime")) {
      moodxTime = getStorage.read("moodxTime");
    }
    super.onInit();
  }

  GetStorage getStorage = GetStorage();
  int moodxTime = 0;

  bool adsLoading = false;

  Future getADS(
    int dailyLimit,
  ) async {
    adsLoading = true;
    update();

    if (moodxTime >= dailyLimit) {
      Get.snackbar(
        "Siz günlük maksimum Moodx qazanma limitinə çatıbsınız",
        "Sabah yenidən davam edə bilərsiniz",
        snackPosition: SnackPosition.BOTTOM,
      );
      adsLoading = false;
      update();
    } else {
      String adId;
      if (Platform.isIOS) {
        adId = "ca-app-pub-9770261708355804/9240914907";
      } else {
        adId = "ca-app-pub-9770261708355804/4289896584";
      }
      await RewardedAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            //loaded
            ad.show(onUserEarnedReward:
                (RewardedAd ad, RewardItem rewardItem) async {
              await getReward(rewardItem.amount.toInt(), dailyLimit);
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            //failed
          },
        ),
      );
    }
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;

  Future getReward(int award, int dailyLimit) async {
    String phoneId;
    String phoneName;
    String systemVersion;
    String additional1;
    String additionalId;
    if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await DeviceInfoPlugin().iosInfo;
      phoneId = deviceInfo.identifierForVendor ?? "";
      phoneName = deviceInfo.name ?? "";
      systemVersion = deviceInfo.systemVersion ?? "";
      additional1 = deviceInfo.model ?? "";
      additionalId = deviceInfo.identifierForVendor ?? "";
    } else {
      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
      phoneId = deviceInfo.androidId ?? "";
      phoneName = deviceInfo.model ?? "";
      systemVersion = deviceInfo.type ?? "";
      additional1 = deviceInfo.device ?? "";
      additionalId = deviceInfo.id ?? "";
    }

    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("moodXADS");
    await httpsCallable.call(<String, dynamic>{
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "award": award,
      "adsLimit": dailyLimit,
      "phoneId": phoneId,
      "phoneName": phoneName,
      "systemVersion": systemVersion,
      "additional1": additional1,
      "additionalId": additionalId,
    });
    int currentmoodxTime = getStorage.read("moodxTime") ?? 0;
    getStorage.write("moodxTime", (currentmoodxTime + 1));
    DateTime dateTime = DateTime.now();
    getStorage.write("moodxDate", dateTime.millisecondsSinceEpoch);
    Get.snackbar(
      "MoodX uğurla artırıldı",
      "Hesabınıza $award MoodX əlavə edildi",
      snackPosition: SnackPosition.BOTTOM,
    );
    moodxTime = getStorage.read("moodxTime");
    adsLoading = false;
    update();
  }

  //getpremium

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  bool loadingPremium = false;
  Future getPremium(String userId, int moodx) async {
    loadingPremium = true;
    update();
    DocumentReference meSocialReference =
        firebaseFirestore.collection("FoodMoodSocial").doc(userId);
    DocumentReference backMoodxReference =
        firebaseFirestore.collection("General").doc("backMoodx");
    await firebaseFirestore.runTransaction((transaction) async {
      transaction.update(meSocialReference, {
        "premium": true,
        "premiumDate": DateTime.now(),
        "moodx": FieldValue.increment(-moodx),
      });
      transaction.update(
        backMoodxReference,
        {
          "total": FieldValue.increment(moodx),
          "goPremium": FieldValue.increment(1),
        },
      );
    });
    loadingPremium = false;
    update();
  }
}
