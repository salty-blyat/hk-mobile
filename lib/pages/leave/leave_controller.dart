import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/delete/leave_delete_screen.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

enum LeaveStatus {
  pending(74),
  approved(75),
  rejected(76),
  processing(77),
  removed(78);

  final int value;
  const LeaveStatus(this.value);
}

class LeaveController extends GetxController {
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  final lists = <Leave>[].obs;
  final year = DateTime.now().year.obs;
  final leaveTypeId = 0.obs;
  final canLoadMore = false.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'fromDate-',
    filters: '[]',
  ).obs;
  @override
  void onInit() {
    search();
    super.onInit();
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value) return;

    isLoadingMore.value = true;
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      final response =
          await leaveService.search(queryParameters.value, Leave.fromJson);
      lists.addAll(response.results as Iterable<Leave>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Future<void> search() async {
  //   loading.value = true;
  //   var rangeDate = '${year.value}-01-01~${year.value}-12-31';
  //   var filters = [
  //     {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate}
  //   ];
  //   queryParameters.value.filters = jsonEncode(filters);

  //   var leave =
  //       await leaveService.search(queryParameters.value, Leave.fromJson);
  //   lists.assignAll(leave.results as Iterable<Leave>);
  //   loading.value = false;
  // }
  Future<void> search() async {
    loading.value = true;

    queryParameters.update((params) {
      final rangeDate = '${year.value}-01-01~${year.value}-12-31';
      final filters = [
        {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate},
      ];
      if (leaveTypeId.value != 0) {
        filters.add({
          'field': 'leaveTypeId',
          'operator': 'eq',
          'value': leaveTypeId.value.toString()
        });
      }
      params?.filters = jsonEncode(filters);
    });

    try {
      final response =
          await leaveService.search(queryParameters.value, Leave.fromJson);
      lists.assignAll(response.results as Iterable<Leave>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }

  void delete(int id) {
    Get.dialog(
      Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: 380,
            child: LeaveDeleteScreen(id: id),
          ),
        ),
      ),
    );
  }
}
