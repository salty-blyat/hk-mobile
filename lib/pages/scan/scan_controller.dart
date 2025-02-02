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
import 'package:staff_view_ui/models/scan_check_model.dart';
import 'package:staff_view_ui/pages/scan/scan-check/scan_check_screen.dart';
import 'package:staff_view_ui/pages/scan/scan_service.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/alert.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/profile_avatar.dart';

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
    try {
      Modal.loadingDialog();
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
      var response = await scanService.checkAttendance(newQrScanModel);
      if (response.statusCode == 200) {
        Get.back();
        showSuccessDialog(ScanCheckModel.fromJson(response.data));
      }
    } catch (e) {
      Get.back();
      print(e);
    }
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

  void showSuccessDialog(ScanCheckModel data) {
    Get.dialog(
      Dialog.fullscreen(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 100),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const Icon(CupertinoIcons.checkmark_circle_fill,
                          size: 80, color: AppTheme.successColor),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Success'.tr,
                      style: AppTheme.style
                          .copyWith(fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 8, top: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                              fullName: data.staffName!,
                              size: 40,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.staffName!,
                                    style: AppTheme.style.copyWith(
                                        fontSize: 16, color: Colors.black)),
                                Text(data.staffCode!,
                                    style: AppTheme.style.copyWith(
                                        fontSize: 12, color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 32,
                          color: Colors.grey.shade400,
                          thickness: 1,
                        ),
                        Info(
                            title: '${'Date'.tr}:',
                            value: data.dateTime != null
                                ? convertToKhmerDate(data.dateTime!)
                                : ''),
                        Info(
                            title: '${'Terminal'.tr}:',
                            value: data.terminalName!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${'Type'.tr}:',
                                style: AppTheme.style.copyWith(
                                    fontSize: 16, color: Colors.black)),
                            Row(
                              children: [
                                Icon(CupertinoIcons.down_arrow,
                                    color: AppTheme.successColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                    data.type != 72
                                        ? 'Check-in'.tr
                                        : 'Check-out'.tr,
                                    style: AppTheme.style.copyWith(
                                        fontSize: 16,
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/menu', arguments: {
                        'redirect': '/attendance-record',
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.history, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'History'.tr,
                    style: AppTheme.style.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: MyButton(
                  onPressed: () {
                    Get.offAllNamed('/menu', arguments: {
                      'redirect': null,
                    });
                  },
                  label: 'Done'.tr,
                  icon: Icons.history,
                  color: AppTheme.primaryColor,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String title;
  final String value;
  const Info({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: AppTheme.style.copyWith(fontSize: 16, color: Colors.black)),
        Text(value,
            style: AppTheme.style.copyWith(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
