import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/overtime_model.dart';
import 'package:staff_view_ui/pages/overtime/overtime_service.dart';

class OvertimeController extends GetxController {
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final overtimeService = OvertimeService();
  final formValid = false.obs;
  final lists = <Overtime>[].obs;
  final year = DateTime.now().year.obs;
  final canLoadMore = false.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 10,
    sorts: 'date-',
    filters: '[]',
  ).obs;

  final overtimeType = RxInt(0);

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
      final response = await overtimeService.search(
          queryParameters.value, Overtime.fromJson);
      lists.addAll(response.results as Iterable<Overtime>);
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
        {'field': 'date', 'operator': 'contains', 'value': rangeDate},
      ]);
    });

    try {
      final response = await overtimeService.search(
          queryParameters.value, Overtime.fromJson);
      lists.assignAll(response.results as Iterable<Overtime>);
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
