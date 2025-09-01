import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

enum RequestStatus {
  pending,
  inProgress,
  done,
  cancel,
}

extension RequestStatusExtension on RequestStatus {
  static const Map<RequestStatus, int> _values = {
    RequestStatus.pending: 1,
    RequestStatus.inProgress: 2,
    RequestStatus.done: 3,
    RequestStatus.cancel: 4,
  };

  int get value => _values[this]!;
}

enum TaskFromEnum {
  internal,
  guest,
}

extension TaskFromEnumExtension on TaskFromEnum {
  static const Map<TaskFromEnum, int> _values = {
    TaskFromEnum.internal: 1,
    TaskFromEnum.guest: 2,
  };

  int get value => _values[this]!;
}

class TaskController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<TaskModel> list = <TaskModel>[].obs;
  final HousekeepingController hkController =
      Get.find<HousekeepingController>();
  RxInt? roomId;
  RxString? roomNumber;
  final TaskService service = TaskService();
  final RxBool loading = false.obs;

  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;

  final FormGroup formGroup = fb.group({
    'id': FormControl<int?>(
      value: null,
    ),
    'reservationId': FormControl<int>(
      value: 0,
    ),
    'taskFrom': FormControl<int>(
      value: TaskFromEnum.internal.value,
      validators: [Validators.required],
    ),
    'requestTime': FormControl<DateTime>(
        value: DateTime.now(), validators: [Validators.required]),
    'roomIds':
        FormControl<List<int>>(value: [], validators: [Validators.required]),
    'guestId': FormControl<int>(value: 0),

    // 'requestNo': FormControl<>(value: null, validators: [Validators.required]),
    'staffId': FormControl<int>(value: null, validators: [Validators.required]),
    'serviceTypeId':
        FormControl<int>(value: 0, validators: [Validators.required]),
    'serviceItemId': FormControl<int>(
        value: 0, disabled: true, validators: [Validators.required]),
    'quantity': FormControl<int>(value: 1, validators: [Validators.required]),
    'status': FormControl<int>(
        value: RequestStatus.pending.value, validators: [Validators.required]),
    'note': FormControl<String>(validators: []),
  });
  var serviceTypeId = 0.obs;

  int currentPage = 1;
  final int pageSize = 20;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: '',
    filters: '[]',
  ).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments['roomId'] != null) {
      roomId = RxInt(Get.arguments['roomId']);
      roomNumber = RxString(Get.arguments['roomNumber']);
    }
    await search();
    formGroup.control('serviceTypeId').valueChanges.listen((value) {
      if (value == 0) {
        formGroup.control('serviceItemId').markAsDisabled();
      } else {
        formGroup.control('serviceItemId').markAsEnabled();
      }
      formGroup.control('quantity').value = 1;
      formGroup.control('serviceItemId').value = 0;
    });
  }

  Future<void> search() async {
    loading.value = true;
    var filter = [];

    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    if (roomId?.value != null) {
      filter.add({'field': 'roomId', 'operator': 'eq', 'value': roomId?.value});
    }

    queryParameters.update((params) {
      params!.filters = jsonEncode(filter);
    });

    try {
      var response = await service.search(
          queryParameters.value, (item) => TaskModel.fromJson(item));
      list.assignAll(response.results as Iterable<TaskModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> submit() async {
    if (loading.isTrue) return;
    Get.focusScope?.unfocus();

    try {
      // Show loading dialog
      Modal.loadingDialog();
      var roomIds = hkController.selected.map((r) => r.roomId).toList();
      print('roomIds $roomIds');
      // await service.add(
      //     TaskModel.fromJson({
      //       ...formGroup.rawValue,
      //       'roomIds': roomIds,
      //     }),
      //     TaskModel.fromJson);
      formGroup.reset();
      Get.back();
      Get.back();

      Modal.successDialog('Success'.tr, "Task created successfully.");
    } catch (e) {
      print(e);
    }
  }

  // Future<void> find(int id) async {
  //   // loading.value = true;
  //   var response = await service.find(id);
  //   if (response.isNotEmpty) {
  //     fillForm(response.value);
  //   }
  //   // loading.value = false;
  // }

  void fillForm(TaskModel task) {
    formGroup.patchValue({
      'taskFrom': task.taskFrom, // must be int (TaskFromEnum.internal.value)
      'requestTime': task.requestTime,
      'roomIds': [task.roomId],
      'staffId': task.staffId,
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
