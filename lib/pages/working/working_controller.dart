import 'package:get/get.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/working/working_service.dart';

class WorkingController extends GetxController {
  final WorkingService workingService = WorkingService();
  final RxList<Worksheets> working = RxList.empty();
  final Rx<Total> total =
      Total(actual: 0, expected: 0, absent: 0, permission: 0).obs;

  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getWorking();
  }

  Future<void> getWorking() async {
    try {
      isLoading.value = true;
      working.value = await workingService.getWorking();
      calculateTotal();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
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
