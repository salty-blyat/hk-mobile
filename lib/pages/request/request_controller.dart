import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';

class RequestApproveController extends GetxController {
  final RequestApproveService service = RequestApproveService();

  final RxList<RequestModel> lists = RxList.empty();
  final RxBool loading = false.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 20,
    sorts: 'createdDate-',
    filters: '[]',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    search();
  }

  Future<void> search() async {
    loading.value = true;
    var response =
        await service.search(queryParameters.value, RequestModel.fromJson);
    lists.assignAll(response.results as Iterable<RequestModel>);
    loading.value = false;
  }
}
