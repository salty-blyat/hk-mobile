import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';

class RequestHistoryController extends GetxController {
  final RequestApproveService service = RequestApproveService();
  final ScrollController scrollController = ScrollController();

  final RxList<RequestModel> lists = RxList.empty();
  final RxBool loading = false.obs;
  final RxBool canLoadMore = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt year = DateTime.now().year.obs;

  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'createdDate-',
    filters: '[]',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    search();
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value) return;

    isLoadingMore.value = true;
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      final response =
          await service.all(queryParameters.value, RequestModel.fromJson);
      lists.addAll(response.results as Iterable<RequestModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshData() async {
    queryParameters.update((params) {
      params?.pageIndex = 1;
    });
    canLoadMore.value = true;
    await search();
  }

  Future<void> search() async {
    loading.value = true;

    queryParameters.update((params) {
      final rangeDate = '${year.value}-01-01~${year.value}-12-31';
      params?.filters = jsonEncode([
        {'field': 'createdDate', 'operator': 'contains', 'value': rangeDate},
      ]);
    });

    try {
      final response =
          await service.all(queryParameters.value, RequestModel.fromJson);
      lists.assignAll(response.results as Iterable<RequestModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }
}
