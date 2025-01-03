import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class LeaveController extends GetxController {
  final loading = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  // Reactive FormGroup with initial values and configurations
  final formGroup = FormGroup({
    'requestNo': FormControl<String>(
      disabled: true,
      value: null,
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
    'reason': FormControl<String>(
      validators: [Validators.required],
    ),
    'approverId':
        FormControl<int>(value: null, validators: [Validators.required]),
    'totalDays': FormControl<int>(
      value: 1,
      disabled: true,
    ),
    'totalHours': FormControl<int>(
      value: 0,
      disabled: true,
    ),
    'balance': FormControl<int>(
      value: 0,
      disabled: true,
    ),
    'leaveTypeId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'status': FormControl<int>(
      value: 74,
    ),
    'fromShiftId': FormControl<int>(
      value: 0,
    ),
    'toShiftId': FormControl<int>(
      value: 0,
    ),
  });

  @override
  void onInit() {
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
    super.onInit();
  }

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
    Modal.loadingDialog();
    await leaveService.add({
      'requestNo': null,
      'requestedDate': formGroup.control('date').value.toIso8601String(),
      'fromDate': formGroup.control('fromDate').value.toIso8601String(),
      'toDate': formGroup.control('toDate').value.toIso8601String(),
      'reason': formGroup.control('reason').value,
      'totalDays': formGroup.control('totalDays').value,
      'totalHours': formGroup.control('totalHours').value,
      'balance': formGroup.control('balance').value,
      'leaveTypeId': formGroup.control('leaveTypeId').value,
      'status': formGroup.control('status').value,
      'fromShiftId': formGroup.control('fromShiftId').value,
      'toShiftId': formGroup.control('toShiftId').value,
    });
    resetState();
    Get.back();
  }

  resetState() {
    formGroup.resetState({
      'requestNo': ControlState<String>(value: null),
      'date': ControlState<DateTime>(value: DateTime.now()),
      'fromDate': ControlState<DateTime>(value: DateTime.now()),
      'toDate': ControlState<DateTime>(value: DateTime.now()),
      'totalDays': ControlState<int>(value: 1),
      'totalHours': ControlState<int>(value: 0),
      'balance': ControlState<int>(value: 0),
      'leaveTypeId': ControlState<int>(value: null),
      'status': ControlState<int>(value: 74),
      'fromShiftId': ControlState<int>(value: 0),
      'toShiftId': ControlState<int>(value: 0),
    });
  }

  @override
  void onClose() {
    // Dispose of form controls to release resources
    formGroup.dispose();
    super.onClose();
  }
}
