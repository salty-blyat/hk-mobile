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

  // Observable leave type value
  final leaveType = '0'.obs;
  final leaveUnit = '1'.obs;

  @override
  void onClose() {
    // Dispose controllers when the controller is removed from memory
    leaveNoController.dispose();
    dateController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    totalDaysController.dispose();
    totalHoursController.dispose();
    super.onClose();
  }

  void updateLeaveUnit(String unit) {
    leaveUnit.value = unit;
  }

  void updateLeaveType(String type) {
    leaveType.value = type;
  }
}
