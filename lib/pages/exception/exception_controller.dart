import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/exception_model.dart';
import 'package:staff_view_ui/pages/exception/exception_service.dart';
import 'package:staff_view_ui/pages/leave/delete/leave_delete_screen.dart';

class ExceptionController extends GetxController {
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final service = ExceptionService();
  final formValid = false.obs;
  final lists = <ExceptionModel>[].obs;
  final year = DateTime.now().year.obs;
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
          await service.search(queryParameters.value, ExceptionModel.fromJson);
      lists.addAll(response.results as Iterable<ExceptionModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search() async {
    loading.value = true;

    queryParameters.update((params) {
      final rangeDate = '${year.value}-01-01~${year.value}-12-31';
      params?.filters = jsonEncode([
        {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate},
      ]);
    });

    try {
      final response =
          await service.search(queryParameters.value, ExceptionModel.fromJson);
      lists.assignAll(response.results as Iterable<ExceptionModel>);
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
