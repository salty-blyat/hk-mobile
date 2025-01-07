import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveController extends GetxController {
  final loading = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  final lists = <Leave>[].obs;
  final year = DateTime.now().year.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 20,
    sorts: 'fromDate-',
    filters: '[]',
  ).obs;

  Future<void> search() async {
    loading.value = true;
    var rangeDate = '${year.value}-01-01~${year.value}-12-31';
    var filters = [
      {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate}
    ];
    queryParameters.value.filters = jsonEncode(filters);

    var leave =
        await leaveService.search(queryParameters.value, Leave.fromJson);
    lists.assignAll(leave.results as Iterable<Leave>);
    loading.value = false;
  }
}
