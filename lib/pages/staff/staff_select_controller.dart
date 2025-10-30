import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/staff/staff_service.dart';

class StaffSelectController extends GetxController {
  final RxBool isDelegate = false.obs;
  final RxString searchText = ''.obs;
  final Rx<Staff> selectedStaff = Staff().obs;
  final RxList<Staff> staff = <Staff>[].obs;
  final StaffService staffService = StaffService();
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    getStaff(); 
  }

  Future<void> getStaff() async {
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
    filter.add({
      'field': 'positionId',
      'operator': 'eq',
      'value': PositionEnum.housekeeper.value
    });

    var response = await staffService.search(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      staff.addAll(response);
      staff.insert(0, Staff(id: 0, name: '-'));
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
    var filter = [];
    var response = await staffService.search(queryParameters: {
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
