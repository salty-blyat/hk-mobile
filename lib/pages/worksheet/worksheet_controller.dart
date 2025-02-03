import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/worksheet/history/history_service.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_service.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/summary_box.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

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
  final workingByDay = <Worksheets>[].obs;
  final attendanceRecord = <AttendanceRecordModel>[].obs;
  final WorkingService workingService = WorkingService();
  final AttendanceRecordService attendanceRecordService =
      AttendanceRecordService();
  final startDate = ''.obs;
  final endDate = ''.obs;
  final isDownloading = false.obs;
  final downloading = ''.obs;
  final downloadProgress = 0.0.obs;
  final queryParam = QueryParam(
    pageIndex: 1,
    pageSize: 10,
    sorts: 'time-',
    filters: '[]',
  ).obs;

  final Rx<Total> total =
      Total(actual: 0, expected: 0, absent: 0, permission: 0).obs;

  final Rx<Total> totalByDay =
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

  Future<void> getTotalByDay(DateTime date) async {
    try {
      final worksheets = await workingService.getWorking(
        fromDate: date.toLocal().toIso8601String(),
        toDate: date.toLocal().toIso8601String(),
      );
      totalByDay.value = Total(
          actual: worksheets.first.adrWorkingHour ?? 0,
          expected: worksheets.first.expectedWorkingHour ?? 0,
          absent: worksheets.first.absentUnAuthHour ?? 0,
          permission: worksheets.first.absentAuthHour ?? 0);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAttendanceRecord(DateTime date) async {
    queryParam.update((params) {
      params?.filters =
          '[{"field":"time","operators":"contains","value":"${date.toLocal()} ~ ${date.toLocal()}"}]';
    });
    try {
      final result = await attendanceRecordService.search(queryParam.value);
      attendanceRecord.assignAll(result.results as List<AttendanceRecordModel>);
    } catch (e) {
      print(e);
    } finally {}
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
        if (await _requestStoragePermission()) {
          var tmp = await getExternalStorageDirectory();
          directory = Directory(
              '${tmp?.path.split('/Android').first}/Download/StaffView');
        } else {
          throw Exception("Storage permission denied");
        }
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

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need permission
  }

  void showDetail(BuildContext context, DateTime time) {
    showDetailLoading.value = true;
    Future.wait([
      getTotalByDay(time),
      getAttendanceRecord(time),
    ]).then((_) {
      showDetailLoading.value =
          false; // Set loading to false after both complete
    }).catchError((e) {
      print("Error in showDetail: $e");
      showDetailLoading.value =
          false; // Ensure loading is stopped even if an error occurs
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Obx(() {
                  return showDetailLoading.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 50,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Worksheet'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Calendar(date: time),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Obx(() {
                                          return Row(
                                            children: [
                                              SummaryBox(
                                                label: 'Working hour',
                                                height: 56,
                                                child: Row(
                                                  children: [
                                                    RichTextWidget(
                                                      value:
                                                          '${totalByDay.value.actual}',
                                                      unit: 'h',
                                                      fontSize: 16,
                                                    ),
                                                    const Text(
                                                      '/',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 4,
                                                        fontFamilyFallback: [
                                                          'Gilroy',
                                                          'Kantumruy'
                                                        ],
                                                      ),
                                                    ),
                                                    RichTextWidget(
                                                      value:
                                                          '${totalByDay.value.expected}',
                                                      unit: 'h',
                                                      fontSize: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SummaryBox(
                                                label: 'Absent authorized',
                                                height: 56,
                                                child: RichTextWidget(
                                                  value:
                                                      '${totalByDay.value.permission}',
                                                  unit: 'h',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SummaryBox(
                                                label: 'Absent unauthorized',
                                                height: 56,
                                                child: RichTextWidget(
                                                  value:
                                                      '${totalByDay.value.absent}',
                                                  unit: 'h',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Scan Log'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 300,
                                child: Obx(() {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: attendanceRecord.length,
                                    itemBuilder: (context, index) {
                                      final item = attendanceRecord[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          subtitle: Text(
                                            item.terminalName!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: convertToKhmerDate(
                                                          item.time!),
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          ' ${DateFormat('h:mm a').format(item.time!.toLocal())}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Tag(
                                                color: item.checkInOutTypeName!
                                                        .contains('In')
                                                    ? AppTheme.successColor
                                                    : AppTheme.dangerColor,
                                                text: item.checkInOutTypeNameKh!
                                                    .trim(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                });
              },
            ),
          ),
        );
      },
    );
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
