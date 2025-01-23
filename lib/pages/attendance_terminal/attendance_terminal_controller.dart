import 'package:get/get.dart';
import 'package:staff_view_ui/models/attendance_terminal_model.dart';
import 'package:staff_view_ui/pages/attendance_terminal/attendance_terminal_service.dart';

class AttendanceTerminalController extends GetxController {
  final AttendanceTerminalService service = AttendanceTerminalService();
  final lists = <AttendanceTerminalModel>[].obs;
  final isLoading = false.obs;

  Future<void> search() async {
    try {
      isLoading.value = true;
      final res = await service.search();
      lists.assignAll(res);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
