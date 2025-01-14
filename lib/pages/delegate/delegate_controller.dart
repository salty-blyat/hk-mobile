import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/delegate_model.dart';
import 'package:staff_view_ui/pages/delegate/delegate_screen.dart';
import 'package:staff_view_ui/pages/delegate/delegate_service.dart';

class DelegateController extends GetxController {
  final loading = false.obs;
  final delegateService = DelegateService();
  final formValid = false.obs;
  final lists = <Delegate>[].obs;
  final year = DateTime.now().year.obs;
  int currentPage = 1;
  final Rx<FilterDelegateTypes> filterType = FilterDelegateTypes.Uncomplete.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'fromDate-',
    filters: '[]',
  ).obs;

  Future<void> search() async {
    loading.value = true;
    var rangeDate = '${year.value}-01-01~${year.value}-12-31';
    var filters = [
      {'field': 'fromDate', 'operator': 'contains', 'value': rangeDate}
    ];
    filters.add({
      'field': 'delegateType',
      'operator': 'eq',
      'value': filterType.value.value.toString()
    });
    queryParameters.value.filters = jsonEncode(filters);

    var delegate =
        await delegateService.search(queryParameters.value, Delegate.fromJson);
    lists.assignAll(delegate.results as Iterable<Delegate>);
    loading.value = false;
  }
}
