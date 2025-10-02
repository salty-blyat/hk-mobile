import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_op_multi_model.dart';
import 'package:staff_view_ui/models/task_summary_model.dart';
import 'package:staff_view_ui/models/task_with_summary_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

enum RequestStatusEnum {
  pending,
  inProgress,
  done,
  cancel,
}

extension RequestStatusExtension on RequestStatusEnum {
  static const Map<RequestStatusEnum, int> _values = {
    RequestStatusEnum.pending: 1,
    RequestStatusEnum.inProgress: 2,
    RequestStatusEnum.done: 3,
    RequestStatusEnum.cancel: 4,
  };

  int get value => _values[this]!;
}

enum RequestTypes {
  internal,
  guest,
}

extension RequestTypesExtension on RequestTypes {
  static const Map<RequestTypes, int> _values = {
    RequestTypes.internal: 1,
    RequestTypes.guest: 2,
  };

  int get value => _values[this]!;
}

class TaskController extends GetxController {
  final RxInt pendingCount = 0.obs;
  final RxInt inProgressCount = 0.obs;
  final RxInt doneCount = 0.obs; 
  final RxString searchText = ''.obs;
  final RxList<TaskModel> list = <TaskModel>[].obs;
  final RxList<TaskSummaryModel> summaryList = <TaskSummaryModel>[].obs; 
  Rx<ClientInfo?> auth = Rxn<ClientInfo>(); 
  RxInt? roomId; 
  final RxBool loading = false.obs; 
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;

  final HousekeepingController housekeepingController = Get.put(HousekeepingController()); 
  final ServiceItemController serviceItemController = Get.put(ServiceItemController());
  final HousekeepingController hkController = Get.put(HousekeepingController());

  final AuthService authService = AuthService();
  final TaskService service = TaskService(); 

  final formGroup = FormGroup({
    'id': FormControl<int>(value: 0, validators: []),
    'roomIds': FormControl<List<int>>(value: [], validators: []),
    'staffId': FormControl<int>(value: null, validators: [Validators.delegate(CommonValidators.required)]),
    'requestNo': FormControl<String>(value: null, validators: [Validators.delegate(CommonValidators.required)]),
    'requestTime': FormControl<DateTime>(value: DateTime.now(), validators: [Validators.delegate(CommonValidators.required)]),
    'requestType': FormControl<int>(value: RequestTypes.internal.value, validators: [Validators.delegate(CommonValidators.required)],),
    'guestId': FormControl<int>(value: 0),
    'reservationId': FormControl<int>(value: 0),
    'serviceTypeId': FormControl<int>(value: 0, validators: [Validators.delegate(CommonValidators.required)]),
    'serviceItemId': FormControl<int>(value: 0, disabled: true, validators: [Validators.delegate(CommonValidators.required)]),
    'quantity': FormControl<int>(value: 1, validators: [Validators.delegate(CommonValidators.required), Validators.number(allowNegatives: false)]),
    'status': FormControl<int>(value: RequestStatusEnum.pending.value, validators: [Validators.delegate(CommonValidators.required)]),
    'note': FormControl<String>()
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
    final authData =
        await authService.readFromLocalStorage(Const.authorized['Authorized']!);
    auth.value = authData != null && authData.isNotEmpty
        ? ClientInfo.fromJson(jsonDecode(authData))
        : ClientInfo();
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
    try {
      var response = await service.searchTaskSummary(
          queryParameters.value, (item) => SearchTaskResult.fromJson(item));

      summaryList
          .assignAll(response.summaryByStatuses as Iterable<TaskSummaryModel>);
      list.assignAll(response.results as Iterable<TaskModel>);
      pendingCount.value =
          list.where((e) => e.status == RequestStatusEnum.pending.value).length;
      inProgressCount.value =
          list.where((e) => e.status == RequestStatusEnum.inProgress.value).length;
      doneCount.value =
          list.where((e) => e.status == RequestStatusEnum.done.value).length;
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
    try {
      loading.value = true;
      // Modal.loadingDialog();
      var roomIds = hkController.selected.map((r) => r.id).toList();
      print({
        ...formGroup.rawValue,
        'roomIds': roomIds,
      });

      print(formGroup.rawValue);
      await service.add(
          TaskOPMultiModel.fromJson({
            ...formGroup.rawValue,
            'roomIds': roomIds,
          }),
          TaskModel.fromJson);
      await search();

      Get.back();
      Get.back();
      var tempdata = {...formGroup.rawValue, 'roomIds': roomIds};
      Modal.successDialog('Success'.tr, "Submitted data: $tempdata");
      clearOrFillForm(); 
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

  Future<void> find(int id) async {
    var response = await service.find(id);
    print(response);
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
    serviceItemController.list.value = [];
    serviceItemController.selected.value = ServiceItem();
    clearOrFillForm();
  }
}
