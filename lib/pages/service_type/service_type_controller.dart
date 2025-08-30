import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/service_type_model.dart';
import 'package:staff_view_ui/pages/service_type/service_type_service.dart';

class ServiceTypeController extends GetxController {
  final ServiceTypeService service = ServiceTypeService();
  final list = <ServiceType>[].obs;
  final isLoading = false.obs;
  int currentPage = 1;
  final int pageSize = 20;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: '',
    filters: '[]',
  ).obs;

  Future<void> search() async {
    isLoading.value = true;
    try {
      var response = await service.search(
          queryParameters.value, (item) => ServiceType.fromJson(item));
      list.assignAll(response.results as Iterable<ServiceType>);
      // canLoadMore.value =
      //     response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      // canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
