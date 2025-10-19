import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/change_status_model.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_summary_model.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/request_log/request_log_service.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';
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
  final RxString searchText = ''.obs;
  final RxList<TaskModel> list = <TaskModel>[].obs;
  final RxList<TaskSummaryModel> summaryList = <TaskSummaryModel>[].obs;
  RxInt roomId = 0.obs;
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  final Rx<ClientInfo> auth = ClientInfo().obs;
  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());
  final Rx<StaffUserModel?> staffUser = StaffUserModel().obs;

  final AuthService authService = AuthService();
  final TaskService service = TaskService();
  final storage = Storage();
  final RequestLogService requestLogService = RequestLogService();
  final StaffUserController staffUserController =
      Get.put(StaffUserController());

  // changing status of the task
  final statusForm = FormGroup(
      {'id': FormControl<int>(value: 0), 'note': FormControl<String>()});

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
  void onInit() {
    
    try {
      if (Get.arguments != null && Get.arguments['roomId'] != 0) {
        roomId.value = Get.arguments['roomId'];
      } 
    } catch (e) {
      print(e);
    }
      search();
      lookupController.fetchLookups(LookupTypeEnum.requestStatuses.value);

    //for falling back when the no staff is linked to the user.
    // try {
    //   final authData = await authService
    //       .readFromLocalStorage(Const.authorized['Authorized']!);
    //   final staffUserStorage = storage.read(StorageKeys.staffUser);
    //   staffUser.value = staffUserStorage != null
    //       ? StaffUserModel.fromJson(jsonDecode(staffUserStorage))
    //       : StaffUserModel();
    //   auth.value = authData != null && authData.isNotEmpty
    //       ? ClientInfo.fromJson(jsonDecode(authData))
    //       : ClientInfo();
    // } catch (e) {
    //   print('Error during initialization: $e');
    // }
    // await staffUserController.getUser();
    final rawData = storage.read(StorageKeys.staffUser);
    if (rawData != null) {
      staffUser.value = StaffUserModel.fromJson(jsonDecode(rawData));
    } else {
      staffUser.value = StaffUserModel();
      Modal.errorDialog(
          "Cannot find staff", "Sorry we cannot find staff link to this user");
    }
    super.onInit();
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
    if (roomId.value != 0) {
      filter.add({'field': 'roomId', 'operator': 'eq', 'value': roomId.value});
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
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      loading.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateTaskStatus(int id, int taskStatus) async {
    loading.value = true;
    try {
      Modal.loadingDialog();
      ChangeStatusModel model = ChangeStatusModel.fromJson(statusForm.rawValue);
      final res = await service.updateTaskStatus(id, model, taskStatus);
      Get.back();
      Get.back();

      Modal.successDialog("Success", '');
    } catch (e) {
      loading.value = false;
      print("cant start task because of $e");
    } finally {
      loading.value = false;
    }
  }
}
