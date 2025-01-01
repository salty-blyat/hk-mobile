import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final leaveNoController = TextEditingController(text: 'New'.tr);
  final dateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  final fromDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  final toDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  final totalDaysController = TextEditingController(text: '1');
  final totalHoursController = TextEditingController(text: '1');
  final balanceController = TextEditingController(text: '0 = 0 - 0');

  // Observable leave type value
  final leaveType = 0.obs;
  final leaveUnit = '1'.obs;

  void updateLeaveUnit(String unit) {
    leaveUnit.value = unit;
  }

  void updateLeaveType(int type) {
    leaveType.value = type;
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed from memory
    leaveNoController.dispose();
    dateController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    totalDaysController.dispose();
    totalHoursController.dispose();
    balanceController.dispose();
    leaveType.value = 0;
    leaveUnit.value = '1';
    super.onClose();
  }
}
