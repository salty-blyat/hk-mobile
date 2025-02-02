// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:staff_view_ui/models/leave_balance_model.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';
import 'package:staff_view_ui/pages/leave_balance/leave_balance_service.dart';

class LeaveBalanceController extends GetxController {
  final service = LeaveBalanceService();
  final leaveBalance = LeaveBalanceModel().obs;
  final leaveTypes = <LeaveType>[].obs;
  final isLoading = false.obs;
  final year = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    getLeaveBalance();
  }

  Future<void> getLeaveBalance() async {
    try {
      isLoading.value = true;
      final response = await service.getLeaveBalance(year.value);
      leaveBalance.value = response['result'] as LeaveBalanceModel;
      leaveTypes.assignAll(response['leaveTypes'] as Iterable<LeaveType>);
      leaveTypes.insert(0, LeaveType(id: 0, name: 'Total'.tr));
    } catch (e) {
      isLoading.value = false;
      print('Error fetching leave balance: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
