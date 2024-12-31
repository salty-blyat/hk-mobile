import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final leaveNoController = TextEditingController(text: 'New'.tr);
  final dateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);

  final fromDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  final toDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
}

class LeaveTypeController extends GetxController {
  final LeaveTypeService leaveTypeService = LeaveTypeService();
  final RxList<LeaveType> leaveType = RxList.empty();
  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getLeaveType();
  }

  Future<void> getLeaveType() async {
    try {
      isLoading.value = true;
      leaveType.value = await leaveTypeService.getLeaveType();
      print('Leave Types: ${leaveType.value}');
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching leave types: $e');
    }
  }
}
