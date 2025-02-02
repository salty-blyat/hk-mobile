// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';

// ignore: camel_case_types
enum REQUEST_TYPE {
  Leave(1),
  OT(2),
  Exception(3);

  final int value;
  const REQUEST_TYPE(this.value);
}

class RequestApproveController extends GetxController {
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final RequestApproveService service = RequestApproveService();
  final formValid = false.obs;
  final lists = <RequestModel>[].obs;
  final selectedRequestType = 0.obs;

  final totalLeave = 0.obs;
  final totalOT = 0.obs;
  final totalException = 0.obs;

  final year = DateTime.now().year.obs;
  final canLoadMore = false.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'createdDate-',
    filters: '[]',
  ).obs;

  @override
  void onInit() {
    search();
    getTotal();
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
          await service.search(queryParameters.value, RequestModel.fromJson);
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

  Future<void> search() async {
    loading.value = true;

    // queryParameters.update((params) {
    //   final rangeDate = '${year.value}-01-01~${year.value}-12-31';
    //   params?.filters = jsonEncode([
    //     {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate},
    //   ]);
    // });
    queryParameters.update((params) {
      final filters = [];
      if (selectedRequestType.value != 0) {
        filters.add(
          {
            'field': 'requestType',
            'operator': 'eq',
            'value': selectedRequestType.value.toString()
          },
        );
      }
      params?.filters = jsonEncode(filters);
    });

    try {
      final response =
          await service.search(queryParameters.value, RequestModel.fromJson);
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

  Future<void> getTotal() async {
    loading.value = true;
    try {
      final total = await service.getTotal();
      totalLeave.value = total['totalLeave'] ?? 0;
      totalOT.value = total['totalOT'] ?? 0;
      totalException.value = total['totalException'] ?? 0;
    } catch (e) {
      print("Error during getTotal: $e");
    } finally {
      loading.value = false;
    }
  }
}
