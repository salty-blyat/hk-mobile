import 'dart:convert';

import 'package:get/get.dart'; 
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_op_multi_model.dart';
import 'package:staff_view_ui/models/task_res_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class TaskOPController extends GetxController {
  final ServiceItemController serviceItemController = Get.put(ServiceItemController());
  final HousekeepingController hkController = Get.put(HousekeepingController());
  final TaskController taskController = Get.put(TaskController());
  final RxBool loading = false.obs;
  final TaskService service = TaskService();

  final formGroup = FormGroup({
    'id': FormControl<int>(value: 0),
    'roomIds': FormControl<List<int?>>(
        value: [],
        validators: [Validators.delegate(CommonValidators.required)]),
    'staffId': FormControl<int>(value: null),
    'requestTime': FormControl<DateTime>(value: DateTime.now()),
    'requestType': FormControl<int>(
        value: RequestTypes.internal.value,
        validators: [Validators.delegate(CommonValidators.required)]),
    'guestId': FormControl<int>(value: 0),
    'reservationId': FormControl<int>(value: 0),
    'serviceTypeId': FormControl<int>(value: 0, validators: [Validators.delegate(CommonValidators.required)]),
    'serviceItemId': FormControl<int>(value: 0, disabled: true,
        validators: [Validators.delegate(CommonValidators.required)]),
    'quantity': FormControl<int>(value: 0, validators: [
      Validators.delegate(CommonValidators.required),
      Validators.number(allowNegatives: false)
    ]),
    'status': FormControl<int>(
        value: RequestStatusEnum.pending.value, validators: []),
    'note': FormControl<String>()
  });

  @override
  void onInit() {
    formGroup.control('serviceTypeId').valueChanges.listen((value) {
      if (value != null && value != 0) {
        formGroup.control('serviceItemId').markAsEnabled();
      } else {
        formGroup.control('serviceItemId').markAsDisabled();
      }
      if (serviceItemController.selected.value.trackQty == true) {
        formGroup.control('quantity').updateValue(1);
      } else {
        formGroup.control('quantity').updateValue(0);
      }
    });
    formGroup.control('serviceItemId').valueChanges.listen((value) {
      if (serviceItemController.selected.value.trackQty == true) {
        formGroup.control('quantity').updateValue(1);
      } else {
        formGroup.control('quantity').updateValue(0);
      }
    });
    super.onInit();
  }

  Future<void> submit() async {
    if (loading.isTrue) return;
    try {
      loading.value = true;
      Modal.loadingDialog();
      List<int?> roomIds = hkController.selected.map((r) => r.id).toList();
      final rawValue = Map<String, dynamic>.from(formGroup.value);
      rawValue['requestTime'] = (rawValue['requestTime'] as DateTime?)?.toIso8601String();
      rawValue['roomIds'] = roomIds;
      rawValue['staffId'] = formGroup.control('staffId').value ?? 0;
 
      TaskOPMultiModel model = TaskOPMultiModel.fromJson(rawValue);
      print(rawValue);
      var res = await service.add(model, TaskResModel.fromJson);
      await taskController.search();
      await hkController.search();
      clearForm();
      Get.back();
      Get.back();

      Modal.successDialog('Success', "Task created successfully");
      loading.value = false;
    } catch (e) {
      print(e);
      Get.back();
      Get.back();
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  void clearOrFillForm({TaskModel? task}) {
    if (task == null) {
      try {
        formGroup.reset(value: {
          'id': null,
          'reservationId': 0,
          'requestType': RequestTypes.internal.value,
          'requestTime': DateTime.now(),
          'roomIds': <int>[],
          'guestId': 0,
          'staffId': 0,
          'serviceTypeId': 0,
          'serviceItemId': 0,
          'quantity': 1,
          'status': RequestStatusEnum.pending.value,
          'note': '',
        });
      } catch (e) {
        print(e);
      }
    } else {
      formGroup.patchValue({
        'requestType': task.requestType,
        'requestTime': task.requestTime,
        'roomIds': [task.roomId],
        // 'staffId': task.staffId,
        'serviceTypeId': task.serviceTypeId,
        'serviceItemId': task.serviceItemId,
        'quantity': task.quantity,
        'status': task.status,
        'note': task.note,
        'reservationId': task.reservationId,
        'guestId': task.guestId,
      });
    }
  }

  void clearForm() { 
    hkController.selected.value=[];
    serviceItemController.list.value = [];
    serviceItemController.selected.value = ServiceItem();
    clearOrFillForm();
  }
}
