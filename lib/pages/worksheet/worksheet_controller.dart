import 'package:get/get.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_service.dart';

class WorkingController extends GetxController {
  final loading = false.obs;
  final working = <Worksheets>[].obs;
  final WorkingService workingService = WorkingService();
  final startDate = ''.obs;
  final endDate = ''.obs;

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
