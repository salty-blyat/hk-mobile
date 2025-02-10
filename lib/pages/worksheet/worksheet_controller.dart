import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/worksheet/history/history_service.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_detail/worksheet_detail.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_service.dart';

enum AttendanceTypes {
  present(1),
  offDuty(4),
  absent(5),
  unknown(6);

  final int value;
  const AttendanceTypes(this.value);
}

enum RequestTypes {
  leave(1),
  ot(2),
  exception(3);

  final int value;
  const RequestTypes(this.value);
}

class WorkingController extends GetxController {
  final loading = false.obs;
  final showDetailLoading = false.obs;
  final working = <Worksheets>[].obs;
  final attendanceRecord = <AttendanceRecordModel>[].obs;
  final WorkingService workingService = WorkingService();
  final AttendanceRecordService attendanceRecordService =
      AttendanceRecordService();
  final startDate = ''.obs;
  final endDate = ''.obs;
  final isDownloading = false.obs;
  final downloading = ''.obs;
  final downloadProgress = 0.0.obs;

  final Rx<Total> total =
      Total(actual: 0, expected: 0, absent: 0, permission: 0).obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
  }

  Future<void> search() async {
    loading.value = true;

    try {
      final worksheets = await workingService.getWorking(
        fromDate: startDate.value,
        toDate: endDate.value,
      );
      working.assignAll(worksheets);

      calculateTotal();
    } catch (e) {
      // loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void showDetail(BuildContext context, Worksheets working) {
    Get.bottomSheet(
      const WorkingDetailBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      settings: RouteSettings(arguments: working),
    );
  }

  void calculateTotal() {
    final actual = working
        .where((x) => x.adrWorkingHour != null)
        .map((x) => x.adrWorkingHour ?? 0)
        .fold(0.0, (sum, value) => sum + value);
    final expected = working
        .where((x) => x.expectedWorkingHour != null)
        .map((x) => x.expectedWorkingHour ?? 0)
        .fold(0.0, (sum, value) => sum + value);
    final absent = working
        .where((x) => x.absentUnAuthHour != null)
        .map((x) => x.absentUnAuthHour ?? 0)
        .fold(0.0, (sum, value) => sum + value);
    final permission = working
        .where((x) => x.absentAuthHour != null && x.absentAuthHour! > 0)
        .map((x) => x.absentAuthHour ?? 0)
        .fold(0.0, (sum, value) => sum + value);

    total.value = Total(
        actual: actual,
        expected: expected,
        absent: absent,
        permission: permission);
  }

  Future<void> downloadReport(String reportName) async {
    try {
      final dio = Dio();
      final response = await workingService.downloadReport(
          reportName: reportName,
          dateRange: '${startDate.value} ~ ${endDate.value}');
      Directory? directory;

      if (Platform.isAndroid) {
        // if (await _requestStoragePermission()) {
        var tmp = await getExternalStorageDirectory();
        directory = Directory(
            '${tmp?.path.split('/Android').first}/Download/StaffView');
        // } else {
        //   throw Exception("Storage permission denied");
        // }
      } else if (Platform.isIOS) {
        directory = Directory(
            '${(await getApplicationDocumentsDirectory()).path}/StaffView');
      }

      if (directory == null) {
        throw Exception("Could not find a valid directory");
      }

      final path =
          "${directory.path}/${reportName}_$startDate-$endDate(${DateTime.now().toString().split(' ').first}).pdf";
      if (response.statusCode == 200) {
        isDownloading.value = true;
        downloading.value = reportName;
        await dio.download(response.data['url'], path,
            onReceiveProgress: (received, total) {
          downloadProgress.value = received / total;
        });
        downloading.value = '';
        isDownloading.value = false;
        Get.to(
          () => Scaffold(
            appBar: AppBar(
              title: Text(reportName.tr),
              actions: [
                IconButton(
                  onPressed: () async {
                    await Share.shareXFiles([XFile(path)]);
                  },
                  icon: const Icon(CupertinoIcons.share),
                ),
              ],
            ),
            body: PDFView(filePath: path),
          ),
        );
      }
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}

class Total {
  final double actual;
  final double expected;
  final double absent;
  final double permission;

  Total({
    required this.actual,
    required this.expected,
    required this.absent,
    required this.permission,
  });
}
