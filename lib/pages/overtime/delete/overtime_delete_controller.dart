import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/overtime_model.dart';
import 'package:staff_view_ui/pages/overtime/overtime_controller.dart';
import 'package:staff_view_ui/pages/overtime/overtime_service.dart';

class OvertimeDeleteController extends GetxController {
  final overtimeService = OvertimeService();
  final OvertimeController overtimeController = Get.find<OvertimeController>();
  final loading = false.obs;
  final operationLoading = false.obs;
  final overtime = Overtime().obs;

  final formGroup = fb.group({
    'id': fb.control(0),
    'note': fb.control(''),
  });

  Future<void> getOvertime(int id) async {
    try {
      loading.value = true;
      overtime.value = Overtime.fromJson(await overtimeService.find(id));
      formGroup.value = {
        'id': overtime.value.id,
      };
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> deleteOvertime() async {
    if (operationLoading.isTrue) return;

    try {
      operationLoading.value = true;
      var res =
          await overtimeService.delete(Overtime.fromJson(formGroup.rawValue));
      if (res) {
        Get.back();
        overtimeController.search();
      }
    } catch (e) {
      operationLoading.value = false;
    } finally {
      operationLoading.value = false;
    }
  }
}
