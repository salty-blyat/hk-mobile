import 'dart:convert'; 

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/pages/service_item/service_item_service.dart';

class ServiceItemController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<ServiceItem> list = <ServiceItem>[].obs;
  final ServiceItemService service = ServiceItemService();
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  final RxInt serviceTypeId = 0.obs;
  var selected = ServiceItem().obs;
  int currentPage = 1;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 999,
    sorts: '',
    filters: '[]',
  ).obs;

  Future<void> search() async {
    loading.value = true;

    queryParameters.update((params) {
      final filters = [
        {"field": "Name", "operator": "contains", "value": ""}
      ];
      if (serviceTypeId.value != 0) {
        filters.add({
          'field': 'serviceTypeId',
          'operator': 'eq',
          'value': serviceTypeId.value.toString()
        });
      }
      params?.filters = jsonEncode(filters);
    });
    try {
      var response = await service.search(
          queryParameters.value, (item) => ServiceItem.fromJson(item));
      list.assignAll(response.results as Iterable<ServiceItem>);
    } catch (e) {
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }
}
