import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/app_model.dart';
import 'package:staff_view_ui/models/assign_staff_model.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_op_multi_model.dart';
import 'package:staff_view_ui/models/task_res_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class TaskOPController extends GetxController {
  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());
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
    'serviceTypeId': FormControl<int>(
        value: 0, validators: [Validators.delegate(CommonValidators.required)]),
    'serviceItemId': FormControl<int>(
        value: 0,
        disabled: true,
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
  Future<void> onReady() async {
    int taskId = Get.arguments['id'] as int? ?? 0;
    if (taskId != 0) {
      Modal.loadingDialog();
      Get.back();
    }
  }

  @override
  Future<void> onInit() async {
    int taskId = Get.arguments['id'] as int? ?? 0;
    if (taskId != 0) {
      loading.value = true;
      var task = await service.find(taskId);
      clearOrFillForm(task: task);
      getFormAssignStaff();
      loading.value = false;
    }

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
      if (serviceItemController.selected.value.trackQty == null) return;
      if (serviceItemController.selected.value.trackQty as bool) {
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
      rawValue['requestTime'] =
          (rawValue['requestTime'] as DateTime?)?.toIso8601String();
      rawValue['roomIds'] = roomIds;
      rawValue['staffId'] = formGroup.control('staffId').value ?? 0;
      if (rawValue['id'] != null && rawValue['id'] != 0) {
        AssignStaffModel model = AssignStaffModel.fromJson({
          "requestId": rawValue['id'],
          "staffId": rawValue['staffId'],
          'note': rawValue['note']
        });
        var res = await service.assignStaff(model);
      } else {
        TaskOPMultiModel model = TaskOPMultiModel.fromJson(rawValue);
        var res = await service.add(model, TaskResModel.fromJson);
      }
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

  void getFormAssignStaff() {
    formGroup.control('requestType').markAsDisabled();
    formGroup.control('serviceItemId').markAsDisabled();
    formGroup.control('serviceTypeId').markAsDisabled();
    formGroup.control('quantity').markAsDisabled();
  }

  void clearOrFillForm({TaskResModel? task}) {
    if (task == null) {
      // clear data
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
      // set data for assigning staff
      formGroup.patchValue({
        "id": task.id,
        'requestType': task.requestType,
        'requestTime': task.requestTime,
        'roomIds': [task.roomId],
        'serviceTypeId': task.serviceTypeId,
        'serviceItemId': task.serviceItemId,
        'quantity': task.quantity,
        'status': task.status,
        'staffId': 0,
        'note': task.note,
        'reservationId': task.reservationId,
        'guestId': task.guestId,
      });
      serviceItemController.selected.value =
          ServiceItem(trackQty: task.trackQty);
      hkController.selected
          .assignAll([Housekeeping(roomNumber: task.roomNumber)]);

      print(formGroup.rawValue);
    }
  }

  void clearForm() {
    hkController.selected.value = [];
    serviceItemController.list.value = [];
    serviceItemController.selected.value = ServiceItem();
    clearOrFillForm();
  }
}
