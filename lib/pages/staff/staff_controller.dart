import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_service.dart';

class StaffController extends GetxController {
  final RxString searchText = ''.obs;
  final RxString selectedStaff = '-'.obs; 
  final RxList<Staff> list = <Staff>[].obs;
  final StaffService service = StaffService();
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int pageSize = 20;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  // Future<void> getStaffById(int id) async {
  //   loading.value = true;
  //   var filter = [
  //     {'field': 'id', 'operator': 'eq', 'value': id}
  //   ];

  //   var response = await staffService.getStaff(queryParameters: {
  //     'pageIndex': currentPage,
  //     'pageSize': pageSize,
  //     'filters': jsonEncode(filter)
  //   });
  //   if (response.isNotEmpty) {
  //     selectedStaff.value =
  //         '${response.first.tittleName} ${response.first.name} ${response.first.latinName}';
  //   }
  //   loading.value = false;
  // }

  Future<void> search() async {
    loading.value = true;
    list.value = [];
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
      'value': PositionEnum.housekeeping.value
    });

    var response = await service.search(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      list.addAll(response);
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
    var response = await service.search(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      list.addAll(response);
    } else {
      hasMore.value = false;
    }
    loadingMore.value = false;
  }
}
