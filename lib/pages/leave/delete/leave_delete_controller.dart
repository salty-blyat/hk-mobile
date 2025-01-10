import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveDeleteController extends GetxController {
  final leaveService = LeaveService();
  final leave = Leave().obs;
  final formGroup = fb.group({
    'reason': fb.control(''),
  });

  Future<void> getLeave(int id) async {
    leave.value = Leave.fromJson(await leaveService.find(id));
  }

  Future<void> deleteLeave(int id) async {
    await leaveService.delete(Leave.fromJson(formGroup.rawValue));
  }
}
