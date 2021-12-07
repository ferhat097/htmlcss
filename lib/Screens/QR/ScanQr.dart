import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/ScanQrController.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  ScanQrController scanQrController = Get.put(ScanQrController());
  @override
  void initState() {
    checkPermission();

    super.initState();
  }

  void checkPermission() async {
    PermissionStatus permissionStatus = await Permission.camera.status;
    if (permissionStatus.isDenied) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanQrController>(
        builder: (controller) {
          return QRView(
            overlayMargin: EdgeInsets.all(10),
            overlay: QrScannerOverlayShape(overlayColor: Colors.black38),
            formatsAllowed: [BarcodeFormat.qrcode],
            key: scanQrController.qrKey,
            onQRViewCreated: scanQrController.onQRViewCreated,
          );
        },
      ),
    );
  }
}
