import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/models/exception_model.dart';
import 'package:staff_view_ui/pages/exception/exception_controller.dart';
import 'package:staff_view_ui/pages/exception/exception_service.dart';
import 'package:staff_view_ui/pages/exception_type/exception_type_controller.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class ExceptionOperationController extends GetxController {
  final loading = false.obs;
  final formValid = false.obs;
  final id = 0.obs;
  final exceptionTypeId = 0.obs;
  final unit = '1'.obs;
  final filePickerController = Get.put(FilePickerController());
  final ExceptionService exceptionService = ExceptionService();
  final ExceptionController exceptionController =
      Get.find<ExceptionController>();
  final formGroup = fb.group({
    'id': FormControl<int>(
      value: 0,
    ),
    'requestNo': FormControl<String>(
      value: null,
      disabled: true,
    ),
    'terminalId': FormControl<int>(
      value: 0,
    ),
    'exceptionTypeId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'requestedDate': FormControl<DateTime>(
      value: DateTime.now(),
      disabled: true,
    ),
    'fromDate': FormControl<DateTime>(
      value: DateTime.now(),
    ),
    'toDate': FormControl<DateTime>(
      value: DateTime.now(),
    ),
    'note': FormControl<String>(
      value: null,
    ),
    'attachments': FormControl<List<dynamic>>(
      value: [],
    ),
    'attachmentString': FormControl<String>(
      value: '',
    ),
    'scanType': FormControl<int>(
      value: 0,
    ),
    'scanTime': FormControl<DateTime>(
      value: DateTime.now(),
    ),
    'date': FormControl<DateTime>(
      value: DateTime.now(),
    ),
    'duration': FormControl<double>(
      value: 0,
    ),
    'approverId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'totalDays': FormControl<double>(
      value: 1,
      disabled: true,
    ),
    'absentType': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'totalHours': FormControl<double>(
      value: 0,
    ),
  });

  @override
  void onInit() {
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
    id.value = Get.arguments['id'];
    if (id.value != 0) {
      find(id.value);
    }
    super.onInit();
  }

  void find(int id) async {
    try {
      loading.value = true;
      var exception = ExceptionModel.fromJson(await exceptionService.find(id));
      setFormValue(exception);
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  void updateUnit(String unit) {
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
    this.unit.value = unit;
  }

  void updateExceptionType(int value) {
    formGroup.control('exceptionTypeId').value = value;
    exceptionTypeId.value = value;
    disableForm();
  }

  void setFormValue(ExceptionModel exception) {
    exceptionTypeId.value = exception.exceptionTypeId!;
    formGroup.patchValue({
      'id': exception.id,
      'requestNo': exception.requestNo,
      'terminalId': exception.terminalId,
      'date': exception.requestedDate?.toLocal(),
      'fromDate': exception.fromDate?.toLocal(),
      'toDate': exception.toDate?.toLocal(),
      'note': exception.note,
      'approverId': exception.approverId,
      'exceptionTypeId': exception.exceptionTypeId,
      'scanType': exception.scanType,
      'scanTime': exception.scanTime?.toLocal(),
      'duration': exception.duration,
      'totalDays':
          exception.totalDays! < 1 ? exception.totalHours : exception.totalDays,
      'totalHours': exception.totalHours,
      'absentType': exception.absentType,
    });
    formGroup.control('attachments').value = [
      {
        'name': exception.attachments?.first.name,
        'url': exception.attachments?.first.url,
        'uid': exception.attachments?.first.uid,
      }
    ];
    filePickerController.isImage.value =
        Const.isImage(exception.attachments?.first.url ?? '');
    filePickerController.attachments.value = exception.attachments ?? [];
  }

  disableForm() {
    if (exceptionTypeId.value == EXCEPTION_TYPE.ABSENT_EXCEPTION.value) {
      formGroup.control('scanType').markAsDisabled();
      formGroup.control('scanTime').markAsDisabled();
      formGroup.control('terminalId').markAsDisabled();
      formGroup.control('totalDays').markAsEnabled();
      formGroup.control('totalHours').markAsEnabled();
      formGroup.control('absentType').markAsEnabled();
      formGroup.control('fromDate').markAsEnabled();
      formGroup.control('toDate').markAsEnabled();
    } else if (exceptionTypeId.value == EXCEPTION_TYPE.MISS_SCAN.value) {
      formGroup.control('scanType').markAsEnabled();
      formGroup.control('scanTime').markAsEnabled();
      formGroup.control('terminalId').markAsEnabled();
      formGroup.control('totalDays').markAsDisabled();
      formGroup.control('totalHours').markAsDisabled();
      formGroup.control('absentType').markAsDisabled();
      formGroup.control('fromDate').markAsDisabled();
      formGroup.control('toDate').markAsDisabled();
    }
  }

  Future<void> submit() async {
    if (loading.isTrue) return;
    if (exceptionTypeId.value == EXCEPTION_TYPE.ABSENT_EXCEPTION.value) {
      formGroup.control('scanType').value = 0;
      formGroup.control('scanTime').value = null;
      formGroup.control('terminalId').value = 0;
    } else if (exceptionTypeId.value == EXCEPTION_TYPE.MISS_SCAN.value) {
      formGroup.control('totalDays').value = 0.0;
      formGroup.control('totalHours').value = 0.0;
      formGroup.control('absentType').value = 0;
      formGroup.control('fromDate').value = formGroup.control('scanTime').value;
      formGroup.control('toDate').value = formGroup.control('scanTime').value;
    }
    formGroup.control('requestedDate').value = DateTime.now();

    try {
      if (unit.value == '1') {
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
        'date': formGroup.control('toDate').value.toIso8601String(),
        'scanTime': formGroup.control('scanTime').value?.toIso8601String(),
      };

      if (id.value == 0) {
        await exceptionService.add(
            ExceptionModel.fromJson({...formGroup.rawValue, ...model}),
            ExceptionModel.fromJson);
      } else {
        await exceptionService.edit(
            ExceptionModel.fromJson(
                {...formGroup.rawValue, ...model, 'id': id.value}),
            ExceptionModel.fromJson);
      }

      exceptionController.search();
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

  void calculateTotalDays() {
    final fromDateControl = formGroup.control('fromDate');
    final toDateControl = formGroup.control('toDate');
    final totalDays =
        toDateControl.value.difference(fromDateControl.value).inDays;
    formGroup.control('totalDays').value =
        double.parse(totalDays.toString()) + 1;
  }

  void updateScanTime(DateTime date, TimeOfDay time) {
    formGroup.control('scanTime').value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
