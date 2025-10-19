import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_service.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class HousekeepingController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<Housekeeping> selected = <Housekeeping>[].obs;
  final RxList<Housekeeping> list = <Housekeeping>[].obs;
  final HousekeepingService service = HousekeepingService();
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  final LookupController lookupController = Get.put(LookupController());
  late final DateTime today;
  late String selectedDate;
  final Rx<int> houseKeepingStatus = 0.obs;
  late Rx<StaffUserModel?> staffUser = StaffUserModel().obs;
  final storage = Storage();
  final StaffUserController staffUserController =
      Get.put(StaffUserController());
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
    selected.clear();
    // await staffUserController.getUser();
    final rawData = storage.read(StorageKeys.staffUser);
    if (rawData != null) {
      staffUser.value = StaffUserModel.fromJson(jsonDecode(rawData));
    } else {
      staffUser.value = StaffUserModel();
    }
    search();
    lookupController.fetchLookups(LookupTypeEnum.housekeepingStatus.value);
    super.onInit();
  }

  Future<void> search() async {
    try {
      loading.value = true;
      queryParameters.update((params) {
        params?.pageIndex = (params.pageIndex ?? 0) + 1;
      });
      var filter = [];

      if (searchText.value.isNotEmpty) {
        filter.add({
          'field': 'search',
          'operator': 'contains',
          'value': searchText.value
        });
      }
      if (houseKeepingStatus.value != 0) {
        filter.add({
          'field': 'houseKeepingStatus',
          'operator': 'contains',
          'value': houseKeepingStatus.value
        });
      }
      var response = await service.search(queryParameters: {
        'pageIndex': currentPage,
        'pageSize': pageSize,
        'filters': jsonEncode(filter)
      });
      if (response.isNotEmpty) {
        // list.value = response;
        list.assignAll(response);
      }
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value) return;
    var filter = [];

    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    if (houseKeepingStatus.value != 0) {
      filter.add({
        'field': 'houseKeepingStatus',
        'operator': 'contains',
        'value': houseKeepingStatus.value
      });
    }
    isLoadingMore.value = true;
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      final response = await service.search(queryParameters: {
        'pageIndex': currentPage,
        'pageSize': pageSize,
        'filters': jsonEncode(filter)
      });
      list.addAll(response);
      canLoadMore.value = response.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}
