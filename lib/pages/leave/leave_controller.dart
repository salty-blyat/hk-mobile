import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LeaveController extends GetxController {
  // Reactive FormGroup with initial values and configurations
  final formGroup = FormGroup({
    'leaveNo': FormControl<String>(
      value: 'New'.tr,
      validators: [Validators.required],
      disabled: true,
    ),
    'date': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
      disabled: true,
    ),
    'fromDate': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
    ),
    'toDate': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
    ),
    'note': FormControl<String>(),
    'approver': FormControl<String>(),
    'totalDays': FormControl<String>(
      value: '1',
      disabled: true,
    ),
    'totalHours': FormControl<String>(
      value: '1',
      disabled: true,
    ),
    'balance': FormControl<String>(
      value: '0 = 0 - 0',
      disabled: true,
    ),
  });

  // Observable state for leave type and unit
  final leaveType = RxInt(0);
  final leaveUnit = RxString('1');

  /// Updates the leave unit
  void updateLeaveUnit(String unit) {
    leaveUnit.value = unit;
    // Additional logic for recalculation or state update can go here
  }

  /// Updates the leave type
  void updateLeaveType(int type) {
    leaveType.value = type;
    // Trigger any additional updates based on leave type selection
  }

  /// Resets the form to its initial state
  void resetForm() {
    formGroup.reset();
    leaveType.value = 0;
    leaveUnit.value = '1';
  }

  @override
  void onClose() {
    // Dispose of form controls to release resources
    formGroup.dispose();
    super.onClose();
  }
}
