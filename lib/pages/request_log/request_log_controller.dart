import 'package:get/get.dart';
import 'package:staff_view_ui/models/request_log_model.dart';
import 'package:staff_view_ui/pages/request_log/request_log_service.dart';

class RequestLogController extends GetxController {
  final Rx<RequestLogModel> model = RequestLogModel().obs;
  final loading = false.obs;
  final RequestLogService service = RequestLogService();

   @override
  void onInit() {
    super.onInit();
    if (Get.arguments['id'] != 0) {
      find(Get.arguments['id'] as int);
    }
  }

  Future<void> find(int id) async {
    try {
      loading.value = true;
      final response = await service.find(id);
      model.value = response;
      print(model.value);
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }
}
