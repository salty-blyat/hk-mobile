import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveDeleteController extends GetxController {
  final leaveService = LeaveService();
  final LeaveController leaveController = Get.find<LeaveController>();
  final loading = false.obs;
  final operationLoading = false.obs;
  final leave = Leave().obs;
  final formGroup = fb.group({
    'id': fb.control(0),
    'reason': fb.control(''),
  });

  Future<void> getLeave(int id) async {
    try {
      loading.value = true;
      leave.value = Leave.fromJson(await leaveService.find(id));
      formGroup.value = {
        'id': leave.value.id,
      };
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> deleteLeave() async {
    if (operationLoading.isTrue) return;
    try {
      operationLoading.value = true;
      var res = await leaveService.delete(Leave.fromJson(formGroup.rawValue));
      if (res) {
        Get.back();
        leaveController.search();
      } else {
        operationLoading.value = false;
      }
    } catch (e) {
      operationLoading.value = false;
      print(e);
    }
  }
}
