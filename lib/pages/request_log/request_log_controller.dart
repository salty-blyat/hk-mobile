import 'package:get/get.dart';
import 'package:staff_view_ui/models/request_log_model.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';

class RequestLogController extends GetxController {
  final model = RequestLog().obs;
  final RxBool loading = false.obs;
  final TaskService taskService = TaskService();

  @override
  void onInit() async {
    if (Get.arguments != null && Get.arguments['id'] != 0) {
      await find(Get.arguments['id'] as int);
    }
    super.onInit();
  }

  Future<void> find(int id) async {
    try {
      loading.value = true;
      final response = await taskService.find(id);

      model.value = RequestLog.fromJson(response);
      print('model.value ${model.value.toJson()}');
      // model.value = RequestLog.fromJson(jsonDecode(response.body));
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }
}
