import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/qr_scan_model.dart';
import 'package:staff_view_ui/pages/scan/scan_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

enum ScanType {
  scanIn(72),
  scanOut(73),
  scanNone(83);

  final int value;

  const ScanType(this.value);
}

class ScanCheckScreen extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());
  ScanCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    String amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = (hour == 0) ? 12 : hour;
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm';
    final QrScanModel qrScanModel = controller.getQrScanModel();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.startScanning();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Scan Attendance'.tr),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80),
          GestureDetector(
            onTap: () {
              // Get.to(() => ScanScreen());
              controller.scanAttendance();
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: ScanType.scanIn.value == qrScanModel.type
                      ? AppTheme.successColor
                      : AppTheme.dangerColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Check-${ScanType.scanIn.value == qrScanModel.type ? 'in' : 'out'}'
                            .tr,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(formattedTime,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
