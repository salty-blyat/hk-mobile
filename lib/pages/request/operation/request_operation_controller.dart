import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
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
  final isNextApprove = false.obs;
  final formValid = false.obs;

  final formGroup = FormGroup({
    'note': FormControl<String>(
      value: '',
    ),
    'nextApproverId': FormControl<int>(
      value: null,
      disabled: true,
      validators: [
        Validators.delegate(CommonValidators.required),
      ],
    ),
    'id': FormControl<int>(
      value: 0,
    ),
  });

  @override
  void onInit() {
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });

    super.onInit();
  }

  void approve() {
    formGroup.markAsTouched();
    if (!loading.value) {
      loading.value = true;
      Modal.loadingDialog();
      requestService
          .approve({...formGroup.rawValue, 'nextApproverId': 0}).then((value) {
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

  void nextApprove() {
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

  void showNextApprover() {
    isNextApprove.value = true;
  }

  void hideNextApprover() {
    isNextApprove.value = false;
  }
}
