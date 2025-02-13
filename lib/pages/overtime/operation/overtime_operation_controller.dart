import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/overtime_model.dart';
import 'package:staff_view_ui/pages/overtime/overtime_controller.dart';
import 'package:staff_view_ui/pages/overtime/overtime_service.dart';
import 'package:staff_view_ui/utils/file_type.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OvertimeOperationController extends GetxController {
  final dio = Dio();
  final OvertimeController overtimeController = Get.find<OvertimeController>();
  final filePickerController = Get.put(FilePickerController());
  final storage = Storage();
  final loading = false.obs;
  final overtimeService = OvertimeService();
  final formValid = false.obs;
  final id = 0.obs;
  final overtimeId = 0.obs;

  final overtimeType = RxInt(0);

  final formGroup = FormGroup({
    'id': FormControl<int>(
      value: 0,
    ),
    'requestNo': FormControl<String>(
      disabled: true,
      value: null,
    ),
    'overtimeTypeId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'requestedDate': FormControl<DateTime>(
      value: DateTime.now(),
      disabled: true,
      validators: [Validators.required],
    ),
    'date': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
    ),
    'fromTime': FormControl<TimeOfDay>(
      value: TimeOfDay.now(),
      validators: [Validators.required],
    ),
    'toTime': FormControl<TimeOfDay>(
      value: TimeOfDay.now(),
      validators: [Validators.required],
    ),
    'overtimeHour': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'note': FormControl<String>(
      value: null,
    ),
    'attachments': FormControl<List<dynamic>>(
      value: [],
    ),
    'attachementString': FormControl<String>(
      value: null,
    ),
    'approverId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
  });
  bool firstTime = true;

  @override
  void onInit() {
    super.onInit();

    formGroup.control('fromTime').valueChanges.listen((_) {
      if (!firstTime) {
        calculateTotalHours();
      }
    });

    formGroup.control('toTime').valueChanges.listen((_) {
      if (!firstTime) {
        calculateTotalHours();
      }
    });

    firstTime = false;

    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
    id.value = Get.arguments['id'];
    if (id.value != 0) {
      find(id.value);
    }
  }

  void find(int id) async {
    try {
      loading.value = true;
      var overtime = Overtime.fromJson(await overtimeService.find(id));

      setFormValue(overtime);
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  void setFormValue(Overtime overtime) {
    formGroup.patchValue({
      'id': overtime.id,
      'requestNo': overtime.requestNo,
      'requestedDate': overtime.requestedDate?.toLocal(),
      'staffId': overtime.staffId,
      'date': overtime.date?.toLocal(),
      'fromTime': TimeOfDay(
        hour: overtime.fromTime!.toLocal().hour,
        minute: overtime.fromTime!.toLocal().minute,
      ),
      'toTime': TimeOfDay(
        hour: overtime.toTime!.toLocal().hour,
        minute: overtime.toTime!.toLocal().minute,
      ),
      'overtimeHour': overtime.overtimeHour!,
      'overtimeTypeId': overtime.overtimeTypeId,
      'note': overtime.note,
      'status': overtime.status,
      'approverId': overtime.approverId
    });

    overtimeType.value = overtime.overtimeTypeId!;
    overtime.attachments?.forEach((attachment) {
      filePickerController.attachments.add(attachment);
      formGroup.control('attachments').value.add({
        'name': attachment.name,
        'url': attachment.url,
        'uid': attachment.uid,
      });
    });
  }

  Future<void> submit() async {
    if (loading.isTrue) return;
    Get.focusScope?.unfocus();

    try {
      Modal.loadingDialog();

      var model = {
        'requestedDate':
            formGroup.control('requestedDate').value.toIso8601String(),
        'date': formGroup.control('date').value.toIso8601String(),
        'fromTime': convertTimeToDateTime(formGroup.control('fromTime').value)
            .toIso8601String(),
        'toTime': convertTimeToDateTime(formGroup.control('toTime').value)
            .toIso8601String(),
      };

      if (id.value == 0) {
        await overtimeService.add(
          Overtime.fromJson({...formGroup.rawValue, ...model}),
          Overtime.fromJson,
        );
      } else {
        await overtimeService.edit(
          Overtime.fromJson({...formGroup.rawValue, ...model, 'id': id.value}),
          Overtime.fromJson,
        );
      }

      Get.back();
      Get.back();

      Modal.successDialog(
          'Success'.tr,
          (id.value == 0
              ? 'Overtime has been submitted successfully'.tr
              : 'Overtime has been updated successfully'.tr));

      overtimeController.search();
    } catch (e) {
      print(e);
    }
  }

  DateTime convertTimeToDateTime(TimeOfDay time) {
    var now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).toLocal();
  }

  void updateOvertimeType(int type) {
    overtimeType.value = type;
    formGroup.control('overtimeTypeId').value = type;
  }

  void calculateTotalHours() {
    final fromTimeControl = formGroup.control('fromTime');
    final toTimeControl = formGroup.control('toTime');

    if (fromTimeControl.value != null && toTimeControl.value != null) {
      final fromTime = fromTimeControl.value as TimeOfDay;
      final toTime = toTimeControl.value as TimeOfDay;

      final fromDateTime = convertTimeToDateTime(fromTime);
      final toDateTime = convertTimeToDateTime(toTime);

      // Calculate the difference in hours
      final duration = toDateTime.difference(fromDateTime).inMinutes / 60;

      // If the duration is negative, it means `toTime` is on the next day
      final totalHours = duration >= 0 ? duration : 24 + duration;

      // Update the overtimeHour field
      formGroup.control('overtimeHour').value =
          double.parse(totalHours.toStringAsFixed(2));
    }
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
              child: isImageType(url)
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
    filePickerController.dispose();
    super.onClose();
  }
}
