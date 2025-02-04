// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/worksheet/history/history_service.dart';
import 'package:staff_view_ui/utils/get_date.dart';

class WorkingDetailController extends GetxController {
  final isLoading = false.obs;
  final attendanceRecord = <AttendanceRecordModel>[].obs;
  final Rx<Worksheets?> working = Rx<Worksheets?>(null);

  final AttendanceRecordService attendanceRecordService =
      AttendanceRecordService();

  late Worksheets worksheet;

  @override
  void onInit() {
    super.onInit();
    worksheet = Get.arguments as Worksheets;
    search(worksheet);
  }

  Future<void> search(Worksheets worksheet) async {
    isLoading.value = true;
    try {
      working.value = worksheet;
      await getAttendanceRecord(worksheet.date!);
    } catch (e) {
      print("Error fetching details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAttendanceRecord(DateTime date) async {
    try {
      final queryParam = QueryParam(
        pageIndex: 1,
        pageSize: 10,
        sorts: 'time-',
        filters:
            '[{"field":"time","operators":"contains","value":"${getDateOnlyString(date)} ~ ${getDateOnlyString(date)}"}]',
      );
      final result = await attendanceRecordService.search(queryParam);
      attendanceRecord.assignAll(result.results as List<AttendanceRecordModel>);
    } catch (e) {
      print(e);
    }
  }
}
