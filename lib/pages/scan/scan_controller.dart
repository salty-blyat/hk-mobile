import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:staff_view_ui/models/qr_scan_model.dart';
import 'package:staff_view_ui/pages/scan/scan-check/scan_check_screen.dart';
import 'package:staff_view_ui/pages/scan/scan_service.dart';
import 'package:staff_view_ui/utils/widgets/alert.dart';

class ScanController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImage = Rx<File?>(null);

  final scannerController = MobileScannerController(
      cameraResolution: const Size(1280, 720),
      detectionSpeed: DetectionSpeed.noDuplicates);
  var isScanning = true.obs;
  var isFlashOn = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  Rx<String> qrCodeData = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    final pos = await determinePosition();
    latitude.value = pos.latitude;
    longitude.value = pos.longitude;
  }

  QrScanModel getQrScanModel() {
    return QrScanModel.fromJson(jsonDecode(qrCodeData.value));
  }

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
    scannerController.toggleTorch();
  }

  void stopScanning() {
    isScanning.value = false;
    scannerController.stop();
  }

  void startScanning() {
    isScanning.value = true;
    scannerController.start();
  }

  Future<void> scanAttendance() async {
    final QrScanModel qrScanModel = getQrScanModel();
    final scanService = ScanService();
    var newQrScanModel = QrScanModel(
      lat: latitude.value.toString(),
      lng: longitude.value.toString(),
      key: qrScanModel.key,
      type: qrScanModel.type,
      fd: qrScanModel.fd,
      td: qrScanModel.td,
    );
    await scanService.checkAttendance(newQrScanModel);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> pickImage(ImageSource source) async {
    stopScanning();
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);

        String? qrCode =
            await decodeQRCodeWithMobileScanner(selectedImage.value!);
        if (qrCode != null) {
          handleQRCode(qrCode);
        } else {
          Alert.errorAlert(
              "Invalid QR Code", "Could not read QR code from the image.");
        }
      } else {
        Alert.errorAlert("No Image Selected", "Please pick an image.");
        startScanning();
      }
    } catch (e) {
      Alert.errorAlert("Error", "Failed to pick an image: $e");
    }
  }

  Future<String?> decodeQRCodeWithMobileScanner(File imageFile) async {
    try {
      final result = await scannerController.analyzeImage(imageFile.path);

      if (result?.barcodes != null) {
        return result?.barcodes.first.rawValue;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void handleQRCode(String code) {
    try {
      String prefix = "https://staffview.sgx.bz/scan?data=";
      String convertCode = code.replaceFirst(prefix, "");
      List<int> decodedBytes = base64Decode(convertCode);
      String decodedString = String.fromCharCodes(decodedBytes);

      qrCodeData.value = decodedString;
      stopScanning();
      Get.to(() => ScanCheckScreen());
    } catch (e) {
      Alert.errorAlert('Error'.tr, 'QR Code invalid !'.tr);
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
