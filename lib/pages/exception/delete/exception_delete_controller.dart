import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/exception_model.dart';
import 'package:staff_view_ui/pages/exception/exception_controller.dart';
import 'package:staff_view_ui/pages/exception/exception_service.dart';

class ExceptionDeleteController extends GetxController {
  final exceptionService = ExceptionService();
  final ExceptionController exceptionController =
      Get.find<ExceptionController>();
  final loading = false.obs;
  final operationLoading = false.obs;
  final exception = ExceptionModel().obs;
  final formGroup = fb.group({
    'id': fb.control(0),
    'note': fb.control(''),
  });

  Future<void> getException(int id) async {
    try {
      loading.value = true;
      exception.value =
          ExceptionModel.fromJson(await exceptionService.find(id));
      formGroup.value = {
        'id': exception.value.id,
      };
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> deleteException() async {
    if (operationLoading.isTrue) return;

    try {
      operationLoading.value = true;
      var res = await exceptionService
          .delete(ExceptionModel.fromJson(formGroup.rawValue));
      if (res) {
        Get.back();
        exceptionController.search();
      }
    } catch (e) {
      operationLoading.value = false;
    } finally {
      operationLoading.value = false;
    }
  }
}
