// ignore_for_file: file_names

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Screens/Common/MenuPage.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    update();
    controller.scannedDataStream.listen(
      (scanData) async {
        result = scanData;
        PendingDynamicLinkData? pendingDynamicLinkData =
            await FirebaseDynamicLinks.instance.getDynamicLink(
          Uri.parse(result!.code),
        );
        print(pendingDynamicLinkData!.link);
        String qr = pendingDynamicLinkData.link.toString();
        List<String> linkList = qr.split("?");
        if (linkList[0].endsWith("menu")) {
          String restaurant = linkList[1];
          List<String> resta = restaurant.split("=");
          String restaurantId = resta[1];
          restaurantId.trim();
          String tableN = linkList[2];
          List<String> table = tableN.split("%3D");
          String tableNumberStr = table[1];
          int tableNumber = int.parse(tableNumberStr);
          Get.off(
            () => MenuPage(
              restaurantId: restaurantId,
              fromQr: true,
              tableNumber: tableNumber,
            ),
          );
          update();
        }
      },
    );
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
