// ignore_for_file: file_names

import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchRestaurantBottomController extends GetxController {
  AlgoliaQuerySnapshot? searchResults;
  bool searching = false;
  Future searchAlgolia(String querytext) async {
    print("searched");
    Algolia algolia = Algolia.init(
        applicationId: "X47Q4IOWZ3",
        apiKey: "8e66460b474ae360303b13ef6f4a5caf");
    AlgoliaQuery query = algolia.instance.index("Restaurants").query(querytext);
    searchResults = await query.getObjects();
    searching = false;
    update();
  }

  Widget defineRestaurantImage(String? image, BuildContext context) {
    if (image == null || image.isEmpty) {
      return Container(color: Theme.of(context).primaryColor);
    } else {
      return Image.network(
        image,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    }
  }

  Widget defineType(int type) {
    if (type == 1) {
      return Image.asset("assets/restaurant.png");
    } else if (type == 3) {
      return Image.asset("assets/hotel.png");
    } else if (type == 2) {
      return Image.asset("assets/burger.png");
    } else if (type == 4) {
      return Image.asset("assets/homemade.png");
    } else {
      return Image.asset("assets/restaurant.png");
    }
  }

  bool defineOpenedStatus(int openedTime, int closedTime, bool? is247) {
    DateTime dateTime = DateTime.now();
    if (is247 != null && is247) {
      return true;
    }
    if (dateTime.hour > openedTime && dateTime.hour < closedTime) {
      return true;
    } else {
      return false;
    }
  }

  void select() {}
  TextEditingController searchController = TextEditingController();
  Timer? searchDelay;
  searchDelayFunction(
    String queryText,
  ) {
    searchDelay = Timer(
      const Duration(seconds: 2),
      () => searchAlgolia(queryText),
    );
  }
}
