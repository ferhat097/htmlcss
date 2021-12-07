// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class FirebaseRemoteConfigController extends GetxController {
  RemoteConfig remoteConfig = RemoteConfig.instance;
  Map<String, dynamic> menuCategory = {};
  Map<String, dynamic> features = {};
  @override
  void onInit() {
    getMenuCategory();
    super.onInit();
  }

  Future getMenuCategory() async {
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setDefaults({
      "restaurantFeatures": {
        "wifi": {
          "featuresName": "WiFi",
          "id": 1,
          "info": "Bu restoranda WiFi mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fwifi.png?alt=media&token=88bf127d-6a84-4c58-965b-b9d0785f5f07",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isWifi"
        },
        "teras": {
          "featuresName": "Teras",
          "id": 2,
          "info": "Bu restoranda Teras mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fterrace.png?alt=media&token=e596b307-ee68-4361-babc-13e6c05a08bc",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isTerrace"
        },
        "wc": {
          "featuresName": "WC",
          "id": 3,
          "info": "Bu restoranda WC mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fwc-sign.png?alt=media&token=6d2b347b-9522-4a21-8122-7ee91f90527e",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isWc"
        },
        "Kondisioner": {
          "featuresName": "Kondisioner",
          "id": 4,
          "info": "Bu restoranda Kondisioner mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fhome.png?alt=media&token=fc2a38f5-ef0d-4e6e-9241-c1a6cf1041c2",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isConditioners"
        },
        "Cərəyan": {
          "featuresName": "Cərəyan",
          "id": 5,
          "info": "Bu restoranda Cərəyan mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fsocket.png?alt=media&token=25b0e49b-f99c-46e2-9d08-1101af33a5ff",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isSocket"
        },
        "Çox mərtəbə": {
          "featuresName": "Çox mərtəbə",
          "id": 6,
          "info": "Bu restoranda Çox mərtəbə mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fstairs.png?alt=media&token=9f5687c1-5c64-4033-8a63-1319d2cd730a",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isMorefloor"
        },
        "Siqaret çəkmək": {
          "featuresName": "Siqaret çəkmək",
          "id": 7,
          "info": "Bu restoranda Siqaret çəkmək mümkündür",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fsmoking.png?alt=media&token=7da97668-a2bf-4a58-bf3f-6bb588c934ec",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isSmoking"
        },
        "Heyvan gətirmə": {
          "featuresName": "Heyvan gətirmə",
          "id": 8,
          "info": "Bu restoranda Heyvan gətirmək mümkündür",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fpawprint.png?alt=media&token=b0db6fe4-db15-448f-aa36-c9d664b0afaf",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isAnimal"
        },
        "Avto dayanacaq": {
          "featuresName": "Avto dayanacaq",
          "id": 9,
          "info": "Bu restoranda Avto dayanacaq mövcuddur",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fparking.png?alt=media&token=fba87617-cc6d-4d77-aea3-40612f69fda4",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isParking"
        },
        "Music": {
          "featuresName": "Canlı Musiqi",
          "id": 10,
          "info": "Bu restoranda canlı musiqi var",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Flive-music.png?alt=media&token=5bcd6433-21cf-413a-867f-70a46a71c5a7",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isLiveMusic"
        },
        "Karaoke": {
          "featuresName": "Karaoke",
          "id": 11,
          "info": "Bu restoranda karaoke var",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fmicrophone.png?alt=media&token=2958f6eb-c2cf-4e28-a20c-e3ab302904c4",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isKaraoke"
        },
        "Spirtli içki": {
          "featuresName": "Spirtli içki",
          "id": 12,
          "info": "Bu restoranda Spirtli içki verilir",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fwhiskey.png?alt=media&token=14806604-d58c-4362-a136-525ac0da5ee5",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isAlcohol"
        },
        "Stolüstü oyunlar": {
          "featuresName": "Stolüstü oyunlar",
          "id": 13,
          "info": "Bu restoranda Stolüstü oyunlar var",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fdices.png?alt=media&token=32478053-8951-42a6-ac59-b271b56fa8c0",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isBoardGame"
        },
        "Video oyunlar": {
          "featuresName": "Stolüstü oyunlar",
          "id": 14,
          "info": "Bu restoranda Stolüstü oyunlar var",
          "active": false,
          "featuresImage":
              "https://firebasestorage.googleapis.com/v0/b/foodmood-af335.appspot.com/o/features%2Fgames.png?alt=media&token=0c2eeabb-8d82-4e18-9eb3-14d5f1ddbfbc",
          "existInfo": "",
          "noexistInfo": "",
          "additionalInfo": "",
          "field": "isVideoGame"
        }
      }
    });
    RemoteConfigValue value = remoteConfig.getValue("menuCategory");
    menuCategory = jsonDecode(value.asString());
    RemoteConfigValue feature = remoteConfig.getValue("restaurantFeatures");
    features = jsonDecode(feature.asString());
    print("features${features.length}");
    update();
  }
}
