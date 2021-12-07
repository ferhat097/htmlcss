import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color defineWhiteBlack() {
  if (Get.isDarkMode) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color defineColor(Color light, Color dark) {
  if (Get.isDarkMode) {
    return light;
  } else {
    return dark;
  }
}

Color defineSelectedBottomNavBarColor() {
  if (Get.isDarkMode) {
    return Colors.white24;
  } else {
    return Colors.transparent;
  }
}

Color defineMainBackgroundColor() {
  if (Get.isDarkMode) {
    return Color(0xFF434343);
  } else {
    return Color(0xFFf5fbfc);
  }
}

Color defineTextFieldColor() {
  if (Get.isDarkMode) {
    return Colors.black45;
  } else {
    return Color(Colors.grey[200]!.value);
  }
}

List<Color> defineMainButtonGradientColors() {
  if (Get.isDarkMode) {
    return [Colors.black54, Colors.black45];
  } else {
    return [
      Color(Colors.grey[50]!.value).withOpacity(0.8),
      Color(Colors.grey[100]!.value).withOpacity(0.8)
    ];
  }
}

List<Color> defineMainCardGradient() {
  if (Get.isDarkMode) {
    return [Colors.black45, Colors.black26];
  } else {
    return [Color(Colors.grey[300]!.value), Colors.white];
  }
}
