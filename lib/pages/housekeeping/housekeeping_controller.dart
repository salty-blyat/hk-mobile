import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_service.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';

enum HousekeepingView { room, block }

extension HousekeepingViewExtension on HousekeepingView {
  static const Map<HousekeepingView, int> _values = {
    HousekeepingView.room: 1,
    HousekeepingView.block: 2,
  };
  int get value => _values[this]!;
}

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
  final Rx<int> housekeepingView = HousekeepingView.room.value.obs;

  final FormGroup formGroup = fb.group({
    'roomIds': FormControl<List<int>>(
      value: [],
      validators: [Validators.required],
    ),
    'staffId': FormControl<int>(validators: [Validators.required]),
    'hkActivityType':
        FormControl<int>(value: 2, validators: [Validators.required]),
    'houseKeepingStatus':
        FormControl<String>(validators: [Validators.required]),
    'note': FormControl<String>(validators: [Validators.required]),
    // roomIds: [this.modal.roomIds, [required]],
    // staffId: [null, this.isFixOOS ? [] : [required]],
    // hkActivityType: [this.modal.HkActivityType, [required]],
    // houseKeepingStatus: [this.modal.statusHouseKeeping, [required]],
    // note: [null, this.isFixOOS ? [required] : []],
  });

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
    await search();
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
    if (houseKeepingStatus.value != 0) {
      filter.add({
        'field': 'houseKeepingStatus',
        'operator': 'contains',
        'value': houseKeepingStatus.value
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

  // Future<void> changeStatus() async {
  //   loading.value = true;
  //   var filter = [];

  //   queryParameters.update((params) {
  //     params?.pageIndex = (params.pageIndex ?? 0) + 1;
  //   });
  //   if (searchText.value.isNotEmpty) {
  //     filter.add({
  //       'field': 'search',
  //       'operator': 'contains',
  //       'value': searchText.value
  //     });
  //   }
  //   if (houseKeepingStatus.value != 0) {
  //     filter.add({
  //       'field': 'houseKeepingStatus',
  //       'operator': 'contains',
  //       'value': houseKeepingStatus.value
  //     });
  //   }
  //   var response = await service.changeStatus(date: selectedDate, queryParameters: {
  //     'pageIndex': currentPage,
  //     'pageSize': pageSize,
  //     'filters': jsonEncode(filter)
  //   });
  //   if (response.isNotEmpty) {
  //     list.value = response;
  //   }
  //   search();
  //   loading.value = false;
  // }
}
