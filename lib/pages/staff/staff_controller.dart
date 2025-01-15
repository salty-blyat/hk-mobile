import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/staff/staff_service.dart';

enum FilterTypesStaff {
  DirectFollower(4),
  AnyFollower(5),
  AnyStaff(9);

  final int value;

  const FilterTypesStaff(this.value);
}

enum FilterTypesApprover {
  DirectManager(1),
  UpperManager(2),
  AnyManager(3),
  AnyStaff(9),
  SelfApprove(10);

  final int value;
  const FilterTypesApprover(this.value);
}

class StaffSelectController extends GetxController {
  final RxBool isDelegate = false.obs;
  final RxString searchText = ''.obs;
  final RxString selectedStaff = '-'.obs;
  final RxList<Staff> staff = <Staff>[].obs;
  final StaffService staffService = StaffService();
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int pageSize = 20;
  final Rx<int> filterType = FilterTypesApprover.DirectManager.value.obs;

  @override
  void onInit() {
    super.onInit();
    filterType.value = isDelegate.value
        ? FilterTypesStaff.DirectFollower.value
        : FilterTypesApprover.DirectManager.value;
  }

  Future<void> getStaffById(int id) async {
    loading.value = true;
    var filter = [
      {'field': 'id', 'operator': 'eq', 'value': id}
    ];

    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });
    if (response.isNotEmpty) {
      selectedStaff.value =
          '${response.first.tittleName} ${response.first.name} ${response.first.latinName}';
    }
    loading.value = false;
  }

  Future<void> getStaff() async {
    if (isDelegate.value &&
        filterType.value == FilterTypesApprover.DirectManager.value) {
      filterType.value = FilterTypesStaff.DirectFollower.value;
    }
    loading.value = true;
    staff.value = [];
    var filter = [];
    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    if (isDelegate.value) {
      filter.add({
        'field': 'staffFilterTypes',
        'operator': 'eq',
        'value': filterType.value
      });
    } else {
      filter.add({
        'field': 'staffFilterTypes',
        'operator': 'eq',
        'value': filterType.value
      });
    }

    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      staff.addAll(response);
      hasMore.value = response.length == pageSize;
    } else {
      hasMore.value = false;
    }
    loading.value = false;
  }

  Future<void> loadMoreStaff() async {
    if (!hasMore.value || loadingMore.value) return;

    loadingMore.value = true;
    currentPage++;
    var filter = [
      {'field': 'staffFilterTypes', 'operator': 'eq', 'value': filterType.value}
    ];
    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      staff.addAll(response);
    } else {
      hasMore.value = false;
    }
    loadingMore.value = false;
  }
}
