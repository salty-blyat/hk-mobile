import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:staff_view_ui/pages/scan/scan_controller.dart';
import 'package:staff_view_ui/pages/scan/scan_overlay.dart';

class ScanScreen extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.primary,
      appBar: AppBar(
        title: Text('Scan QR'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (!controller.isScanning.value) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Scanning is stopped.'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              }

              return Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: MobileScanner(
                        fit: BoxFit.fill,
                        controller: controller.scannerController,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final String? code = barcodes.first.rawValue;

                            if (code != null) {
                              controller.handleQRCode(code);
                            }
                          }
                        },
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: QRScannerOverlay(
                        overlayColour: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24.0),
            Text(
              'Align frame with QR code'.tr,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.0, // Set a fixed width for both buttons
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12.0,
                        fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                      ),
                    ),
                    onPressed: controller.toggleFlash,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flashlight_on_rounded,
                          size: 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text('Flash'.tr),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 150.0, // Same fixed width for the second button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12.0,
                        fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.qrcode, size: 16.0),
                        const SizedBox(width: 8.0),
                        Text('Select QR'.tr),
                      ],
                    ),
                    onPressed: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
