import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class LeaveOperationController extends GetxController {
  final LeaveController leaveController = Get.find<LeaveController>();
  final loading = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  final id = 0.obs;

  final formGroup = FormGroup({
    'id': FormControl<int>(
      value: 0,
    ),
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
    'totalDays': FormControl<double>(
      value: 1,
      disabled: true,
    ),
    'totalHours': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'balance': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'showBalance': FormControl<String>(
      value: '0 = 0 - 0',
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

  final leaveType = RxInt(0);
  final leaveUnit = RxString('1');

  /// Updates the leave unit
  void updateLeaveUnit(String unit) {
    leaveUnit.value = unit;
  }

  /// Updates the leave type
  void updateLeaveType(int type) {
    leaveType.value = type;
    formGroup.control('leaveTypeId').value = type;
    updateLeaveBalance(type);
  }

  void find(int id) async {
    loading.value = true;
    var leave = Leave.fromJson(await leaveService.find(id));
    setFormValue(leave);
    loading.value = false;
  }

  void setFormValue(Leave leave) {
    formGroup.patchValue({
      'id': leave.id,
      'requestNo': leave.requestNo,
      'date': leave.requestedDate?.toLocal(),
      'fromDate': leave.fromDate?.toLocal(),
      'toDate': leave.toDate?.toLocal(),
      'reason': leave.reason,
      'approverId': leave.approverId,
      'leaveTypeId': leave.leaveTypeId,
      'status': leave.status,
      'fromShiftId': leave.fromShiftId,
      'toShiftId': leave.toShiftId,
      'totalDays': leave.totalDays,
      'totalHours': leave.totalHours,
      'balance': leave.balance,
    });
    leaveType.value = leave.leaveTypeId!;
    updateLeaveBalance(leave.leaveTypeId!);
  }

  void calculateTotalDays() {
    final fromDate = formGroup.control('fromDate').value;
    final toDate = formGroup.control('toDate').value;
    final double totalDays = toDate.difference(fromDate).inDays + 1;
    formGroup.control('totalDays').value = totalDays;
  }

  Future<void> submit() async {
    try {
      Modal.loadingDialog();
      var model = {
        'requestedDate': formGroup.control('date').value.toIso8601String(),
        'fromDate': formGroup.control('fromDate').value.toIso8601String(),
        'toDate': formGroup.control('toDate').value.toIso8601String(),
      };
      if (id.value == 0) {
        await leaveService.add(
            Leave.fromJson({...formGroup.value, ...model}), Leave.fromJson);
      } else {
        await leaveService.edit(
            Leave.fromJson({...formGroup.value, ...model, 'id': id.value}),
            Leave.fromJson);
      }
      leaveController.search();
      Get.back();
      Get.back();
    } catch (e) {}
  }

  Future<void> updateLeaveBalance(int id) async {
    var leaveBalance = await leaveService.getLeaveBalance(id);
    var balance = formGroup.control('totalDays').value;
    balance = leaveBalance - (formGroup.controls['totalDays']!.value as double);

    formGroup.control('showBalance').value =
        '${numberFormat(balance)} = ${numberFormat(leaveBalance)} - ${numberFormat(formGroup.controls['totalDays']?.value as double)}';
  }

  String numberFormat(double value) {
    return NumberFormat('###.##').format(value);
  }

  @override
  void onClose() {
    formGroup.dispose();
    super.onClose();
  }
}
