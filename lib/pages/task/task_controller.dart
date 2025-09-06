import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
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
  final TaskService service = TaskService();
  final RxBool loading = false.obs;

  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  final HousekeepingController housekeepingController =
      Get.put(HousekeepingController());

  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());

  final FormGroup formGroup = FormGroup({
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
    'roomIds': FormControl<List<int>>(value: [], validators: []),
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
  final Rx<int> taskStatus = 0.obs;
  final LookupController lookupController = Get.put(LookupController());

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
    try {
      if (Get.arguments['roomId'] != 0) {
        roomId = RxInt(Get.arguments['roomId']);
        print('in controller roomId $roomId');
      }
    } catch (e) {
      print(e);
    }
    print('called init task controller');
    await search();
    await lookupController.fetchLookups(LookupTypeEnum.requestStatuses.value);
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

    if (taskStatus.value != 0) {
      filter.add(
          {'field': 'status', 'operator': 'eq', 'value': taskStatus.value});
    }

    if (roomId?.value != 0 && roomId != null) {
      filter.add({'field': 'roomId', 'operator': 'eq', 'value': roomId!.value});
    }

    queryParameters.update((params) {
      params!.filters = jsonEncode(filter);
    });
    print('queryParameters: ${queryParameters.value.filters}');
    try {
      var response = await service.search(
          queryParameters.value, (item) => TaskModel.fromJson(item));
      list.assignAll(response.results as Iterable<TaskModel>);
      print("list : $list");
      print("roomId?.list : ${roomId?.value}");
      print("list taskStatus.value: ${taskStatus.value}"); 

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
      print('formGroup ${formGroup.rawValue}');

      // await service.add(
      //     TaskModel.fromJson({
      //       ...formGroup.rawValue,
      //       'roomIds': roomIds,
      //     }),
      //     TaskModel.fromJson);

      fillForm();
      Get.back();
      Get.back();

      Modal.successDialog('Success'.tr, "Task created successfully.");
    } catch (e) {
      print(e);
    }
  }

  Future<void> find(int id) async {
    // loading.value = true;
    var response = await service.find(id);
    print(response);
    // loading.value = false;
  }

  void fillForm({TaskModel? task}) {
    if (task == null) {
      // formGroup.reset(value: {'taskFrom': TaskFromEnum.internal.value});
      // formGroup.reset(value: {'requestTime': DateTime.now()});
      // formGroup.reset(value: {'roomIds': <int>[]});
      // formGroup.reset(value: {  'staffId': 0});
      // formGroup.reset(value:{'serviceTypeId': 0});
      // formGroup.reset(value:{'serviceItemId': 0});
      // formGroup.reset(value:{'quantity': 1});
      // formGroup.reset(value:{'status': RequestStatus.pending.value});
      // formGroup.reset(value:{'note': null});
      // formGroup.reset(value:{'reservationId': 0});
      // formGroup.reset(value:{'guestId': 0});
      try {
        formGroup.reset(value: {
          'id': null,
          'reservationId': 0,
          'taskFrom': TaskFromEnum.internal.value,
          'requestTime': DateTime.now(),
          'roomIds': <int>[],
          'guestId': 0,
          'staffId': 0,
          'serviceTypeId': 0,
          'serviceItemId': 0,
          'quantity': 1,
          'status': RequestStatus.pending.value,
          'note': '',
        });
      } catch (e) {
        print(e);
      }
    } else {
      formGroup.patchValue({
        'taskFrom': task.taskFrom,
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

  void clearForm() {
    serviceItemController.list.value = [];
    serviceItemController.selected.value = ServiceItem();
    print('before: ${formGroup.rawValue}');
    fillForm();
    print('after ${formGroup.rawValue}');
  }
}
