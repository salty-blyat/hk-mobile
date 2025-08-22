import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_service.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';

class HousekeepingController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<Housekeeping> selected = <Housekeeping>[].obs;
  final RxList<Housekeeping> list = <Housekeeping>[].obs;
  final HousekeepingService service = HousekeepingService();
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  late final DateTime today;
  late final String selectedDate;

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
    today = DateTime.now();
    selectedDate = "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";
    await lookupController.fetchLookups(LookupTypeEnum.housekeepingStatus.value);
    search(); 
  }

  Future<void> search() async {
    loading.value = true;
    var filter = [];
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });
    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    var response = await service.search(date: selectedDate, queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });
    if (response.isNotEmpty) {
      list.value = response;
    }
    loading.value = false;
  }
}
