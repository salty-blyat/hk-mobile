import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_service.dart';

class StaffSelectController extends GetxController {
  final RxString searchText = ''.obs;
  String? selectedStaff;
  final RxList<Staff> staff = <Staff>[].obs;
  final StaffService staffService = StaffService();
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

  Future<void> getStaff() async {
    loading.value = true;
    staff.value = [];
    var filter = [];
    filter.add({
      'field': 'positionId',
      'operator': 'eq',
      'value': LookupTypeEnum.position.value.toString()
    });

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
    var filter = [];
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
