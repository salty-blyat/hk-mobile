import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/request/request_controller.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';
import 'package:staff_view_ui/pages/request/view/request_view_controller.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class RequestOperationController extends GetxController {
  final requestService = RequestApproveService();
  final RequestViewController requestViewController =
      Get.put(RequestViewController());
  final RequestApproveController requestApproveController =
      Get.put(RequestApproveController());
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
    formGroup.markAsTouched();
    if (!loading.value) {
      loading.value = true;
      Modal.loadingDialog();
      requestService.approve(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.checkCanDoAction();
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
          Get.back();
          loading.value = false;
        }
      });
    }
    loading.value = false;
  }

  void reject() {
    formGroup.markAsTouched();
    if (!loading.value) {
      loading.value = true;
      Modal.loadingDialog();
      requestService.reject(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.checkCanDoAction();
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
          Get.back();
          loading.value = false;
        }
      });
    }
    loading.value = false;
  }

  void undo() {
    formGroup.markAsTouched();
    if (formGroup.valid && !loading.value) {
      Modal.loadingDialog();
      requestService.undo(formGroup.rawValue).then((value) {
        if (value.statusCode == 200) {
          requestViewController.checkCanDoAction();
          requestViewController.findById(formGroup.value['id'] as int);
          requestApproveController.search();
          Get.back();
          Get.back();
          loading.value = false;
        }
      });
    }
    loading.value = false;
  }
}
