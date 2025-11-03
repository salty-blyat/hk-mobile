import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_service.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';

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
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: '',
    filters: '[]',
  ).obs;

  @override
  void onInit() {
    selected.clear();
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
      params?.pageIndex =   1;
      });

      // print('params?.pageIndex ${queryParameters.value.pageIndex}');

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
      var response = await service.search(queryParameters.value);

      list.assignAll(response.results as Iterable<Housekeeping>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value && isLoadingMore.value) return;

    isLoadingMore.value = true;
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
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      var response = await service.search(queryParameters.value);

      list.addAll(response.results as Iterable<Housekeeping>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
      isLoadingMore.value = false;
    } catch (e) {
      canLoadMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
