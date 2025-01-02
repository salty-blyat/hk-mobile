import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveController extends GetxController {
  final leaveService = LeaveService();
  // Reactive FormGroup with initial values and configurations
  final formGroup = FormGroup({
    'leaveNo': FormControl<String>(
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
    'approverId': FormControl<String>(),
    'totalDays': FormControl<int>(
      value: 1,
      disabled: true,
    ),
    'totalHours': FormControl<int>(
      value: 0,
      disabled: true,
    ),
    'balance': FormControl<String>(
      value: '0 = 0 - 0',
      disabled: true,
    ),
    'leaveTypeId': FormControl<int>(),
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
    formGroup.control('leaveTypeId').value = type;
    // Trigger any additional updates based on leave type selection
  }

  /// Resets the form to its initial state
  void resetForm() {
    formGroup.reset();
    leaveType.value = 0;
    leaveUnit.value = '1';
  }

  /// Calculates the total days of leave
  void calculateTotalDays() {
    final fromDate = formGroup.control('fromDate').value;
    final toDate = formGroup.control('toDate').value;
    final totalDays = toDate.difference(fromDate).inDays + 1;
    formGroup.control('totalDays').value = totalDays;
  }

  Future<void> submit() async {
    //
  }

  @override
  void onClose() {
    // Dispose of form controls to release resources
    formGroup.dispose();
    super.onClose();
  }
}
