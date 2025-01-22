import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LeaveOperationController extends GetxController {
  final dio = Dio();
  final LeaveController leaveController = Get.find<LeaveController>();
  final filePickerController = Get.put(FilePickerController());
  final storage = Storage();
  final loading = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  final id = 0.obs;
  final leaveId = 0.obs;
  var leaveBalance = 0.0.obs;

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
    'attachments': FormControl<List<dynamic>>(
      value: [],
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
    final toDateControl = formGroup.control('toDate');
    final fromDateControl = formGroup.control('fromDate');
    final totalDaysControl = formGroup.control('totalDays');
    if (unit == '1') {
      toDateControl.markAsEnabled();
      totalDaysControl.markAsDisabled();
      totalDaysControl.value = 1.0;
    } else {
      toDateControl.value = fromDateControl.value;
      totalDaysControl.value = 1.0;
      toDateControl.markAsDisabled();
      totalDaysControl.markAsEnabled();
    }
    leaveUnit.value = unit;
    updateBalance();
  }

  /// Updates the leave type
  void updateLeaveType(int type) {
    leaveType.value = type;
    formGroup.control('leaveTypeId').value = type;
    updateLeaveBalance(type);
  }

  void find(int id) async {
    try {
      loading.value = true;
      var leave = Leave.fromJson(await leaveService.find(id));
      setFormValue(leave);
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
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
      'totalDays': leave.totalDays! < 1 ? leave.totalHours : leave.totalDays,
      'totalHours': leave.totalHours,
      'balance': leave.balance,
    });
    leaveType.value = leave.leaveTypeId!;
    leaveUnit.value = leave.totalDays! < 1 ? '2' : '1';
    if (leave.totalDays! < 1) {
      formGroup.control('totalDays').markAsEnabled();
    }
    updateLeaveBalance(leave.leaveTypeId!);
    formGroup.control('attachments').value = [
      {
        'name': leave.attachments?.first.name,
        'url': leave.attachments?.first.url,
        'uid': leave.attachments?.first.uid,
      }
    ];
    filePickerController.isImage.value =
        Const.isImage(leave.attachments?.first.url ?? '');
    filePickerController.attachments.value = leave.attachments ?? [];
  }

  void calculateTotalDays() async {
    final fromDate = formGroup.control('fromDate').value;
    final toDate = formGroup.control('toDate').value;
    final staffId = int.parse(storage.read(Const.staffId) ?? '0');
    final totalDays =
        await leaveService.getActualLeaveDay(staffId, fromDate, toDate);
    formGroup.control('totalDays').value = totalDays;
    updateBalance();
  }

  Future<void> submit() async {
    if (loading.isTrue) return;

    try {
      if (leaveUnit.value == '1') {
        formGroup.control('totalHours').value = 0.0;
      } else {
        var dayField = formGroup.control('totalDays').value;
        formGroup.control('totalHours').value = dayField;
        dayField = dayField / 8;
        formGroup.control('totalDays').value = dayField;
      }

      // Show loading dialog
      Modal.loadingDialog();

      var model = {
        'requestedDate': formGroup.control('date').value.toIso8601String(),
        'fromDate': formGroup.control('fromDate').value.toIso8601String(),
        'toDate': formGroup.control('toDate').value.toIso8601String(),
      };

      if (id.value == 0) {
        await leaveService.add(
            Leave.fromJson({...formGroup.rawValue, ...model}), Leave.fromJson);
      } else {
        await leaveService.edit(
            Leave.fromJson({...formGroup.rawValue, ...model, 'id': id.value}),
            Leave.fromJson);
      }

      leaveController.search();
      // Close the loading dialog
      Get.back(); // Navigate back or close extra layers if needed
      Get.back(); // Navigate back or close extra layers if needed
    } catch (e) {
      print(e);
      // Handle specific errors if necessary
    } finally {
      // Ensure the loading dialog is dismissed
      // Modal.closeLoadingDialog();
    }
  }

  Future<void> updateLeaveBalance(int id) async {
    leaveBalance.value = await leaveService.getLeaveBalance(id);
    updateBalance();
  }

  void updateBalance() {
    var leaveBalance = this.leaveBalance.value;
    var balance = formGroup.control('totalDays').value;
    var minus = (balance ?? 0) / 8;
    if (leaveUnit.value == '1') {
      minus = balance;
      balance = leaveBalance - balance;
    } else {
      balance = leaveBalance - minus;
    }
    formGroup.control('balance').value = balance;

    formGroup.control('showBalance').value =
        '${Const.numberFormat(balance)} = ${Const.numberFormat(leaveBalance)} - ${Const.numberFormat(minus)}';
  }

  void showAttachments() async {
    final controller = WebViewController();
    var url = formGroup.control('attachments').value.first['url'];

    controller.loadRequest(Uri.parse(url));

    Get.dialog(Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Text('Attachment'.tr, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
            ],
          ),
          Expanded(
              child: Const.isImage(url)
                  ? WebViewWidget(controller: controller)
                  : PDFView(
                      filePath: filePickerController.filePath.value,
                    )),
        ],
      ),
    ));
  }

  @override
  void onClose() {
    formGroup.dispose();
    super.onClose();
  }
}
