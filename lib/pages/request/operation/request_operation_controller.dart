import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/request/request_controller.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';
import 'package:staff_view_ui/pages/request/view/request_view_controller.dart';

class RequestOperationController extends GetxController {
  final requestService = RequestApproveService();
  final RequestViewController requestViewController = Get.find();
  final RequestApproveController requestApproveController = Get.find();
  final loading = false.obs;

  final formGroup = FormGroup({
    'note': FormControl<String>(
      value: '',
    ),
    'nextApproverId': FormControl<int>(value: 0),
    'id': FormControl<int>(
      value: 0,
    ),
  });

  void approve() {
    loading.value = true;
    formGroup.markAsTouched();
    if (formGroup.valid) {
      requestService.approve(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
        }
      });
    }
    loading.value = false;
  }

  void reject() {
    loading.value = true;
    formGroup.markAsTouched();
    if (formGroup.valid) {
      requestService.reject(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
        }
      });
    }
    loading.value = false;
  }

  void undo() {
    loading.value = true;
    if (formGroup.valid) {
      requestService.undo(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
        }
      });
    }
    loading.value = false;
  }
}
