// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_string/random_string.dart';

class CompleteSignUpController extends GetxController {
  PageController pageController = PageController();
  int currentPage = 0;
  void setCurrentPage(page) {
    currentPage = page;
    update();
  }

  List selectedFoods = [];
  void selecetFood(int id) {
    if (selectedFoods.contains(id)) {
      selectedFoods.remove(id);
    } else {
      if (selectedFoods.length < 3) {
        selectedFoods.add(id);
      } else {
        Get.snackbar("Maksimum 3 ədəd", "");
      }
    }

    update();
  }

  List selectedDrinks = [];
  void selecetDrink(int id) {
    if (selectedDrinks.contains(id)) {
      selectedDrinks.remove(id);
    } else {
      if (selectedDrinks.length < 3) {
        selectedDrinks.add(id);
      } else {
        Get.snackbar("Maksimum 3 ədəd", "");
      }
    }

    update();
  }

  List selectedRestaurants = [];
  void selecetRestaurant(int id) {
    if (selectedRestaurants.contains(id)) {
      selectedRestaurants.remove(id);
    } else {
      if (selectedRestaurants.length < 3) {
        selectedRestaurants.add(id);
      } else {
        Get.snackbar("Maksimum 3 ədəd", "");
      }
    }

    update();
  }

  List errorList = [];

  bool checkError() {
    errorList.clear();
    if (selectedFoods.length < 3) {
      errorList.add(1);
    }
    if (selectedDrinks.length < 3) {
      errorList.add(2);
    }
    if (selectedRestaurants.length < 3) {
      errorList.add(3);
    }
    if (errorList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  int definePercentage() {
    if ((selectedFoods.length +
            selectedDrinks.length +
            selectedRestaurants.length) <
        9) {
      return ((selectedFoods.length +
                  selectedDrinks.length +
                  selectedRestaurants.length) /
              9 *
              100)
          .toInt();
    } else {
      return 100;
    }
  }

  //invite
  bool? openInvite;
  setOpenInvite(bool invite) {
    openInvite = invite;
    update();
  }

  //sex
  int? sex;
  void setSex(int selectedSex) {
    sex = selectedSex;
    update();
  }

  //birthday
  ///age
  DateTime? birthday;

  setBirthday(DateTime dateTime) {
    birthday = dateTime;
    update();
  }

  //username
  /// generate username
  String? userName;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  bool completeLoading = false;

  Future checkUserName(String userName) async {
    progress = true;
    update();
    QuerySnapshot<Map<String, dynamic>> users = await firebaseFirestore
        .collection("Users")
        .where("userName", isEqualTo: userName)
        .get();
    if (users.docs.isNotEmpty) {
      progress = false;
      availableUserName = false;
      Get.snackbar("Bu istifadəçi adı möcvuddur", "");
      update();
    } else {
      progress = false;
      availableUserName = true;
      userName = userNameController.text;
      update();
    }
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool availableUserName = true;
  bool progress = false;

  setFalse() {
    availableUserName = true;
    update();
  }

  //checkfirsterror
  List<int> completeCheckErrors = [];
  bool cCheckErrors() {
    completeCheckErrors.clear();
    if (birthday == null) {
      completeCheckErrors.add(1);
    }
    if (sex == null) {
      completeCheckErrors.add(2);
    }
    if (openInvite == null) {
      completeCheckErrors.add(3);
    }
    if (isPrivateCar == null) {
      completeCheckErrors.add(4);
    }
    if (isAlcohol == null) {
      completeCheckErrors.add(5);
    }

    if (completeCheckErrors.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //private car
  bool? isPrivateCar;
  setPrivateCar(bool isCar) {
    isPrivateCar = isCar;
    update();
  }

  //alcohol
  bool? isAlcohol;
  setAlcohol(bool isAl) {
    isAlcohol = isAl;
    update();
  }

  //tabacoo
  bool? isTabacoo;
  setTabacoo(bool isTab) {
    isTabacoo = isTab;
    update();
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  GetStorage get_storage = GetStorage();

  ///set
  Future setFoodMoodSocial(String currentName, String currentUserName) async {
    completeLoading = true;
    update();
    String userId = await get_storage.read("userUid");
    String name;
    if (nameController.text.isEmpty) {
      name = currentName;
    } else {
      name = nameController.text;
    }
    String username;
    if (userNameController.text.isNotEmpty && availableUserName) {
      username = userName!;
    } else {
      username = currentUserName;
    }
    List allList = selectedFoods + selectedDrinks + selectedRestaurants;
    HttpsCallable httpsCallable =
        firebaseFunctions.httpsCallable("completeFoodMoodSocial");
    await httpsCallable.call(<String, dynamic>{
      "userId": userId,
      "name": name,
      "userName": username,
      "sex": sex,
      "openInvite": openInvite,
      "isAlcohol": isAlcohol,
      "isTabacoo": isTabacoo,
      "isPrivateCar": isPrivateCar,
      "birthday": birthday!.millisecondsSinceEpoch,
      "foodList": selectedFoods,
      "drinkList": selectedDrinks,
      "restaurantList": selectedRestaurants,
      "allList": allList,
    });
    await get_storage.write("sex", sex);
    await get_storage.write("completed", true);
    completeLoading = false;
    update();
  }
}
