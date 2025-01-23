import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/change_password/change_password_service.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class ChangePasswordController extends GetxController {
  final _changePasswordService = ChangePasswordService();
  final loading = false.obs;
  final formValid = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();

  // Change Password Form Group
  final FormGroup formGroup = fb.group({
    'name': FormControl<String>(disabled: true),
    'oldPassword': FormControl<String>(
      value: null,
      validators: [Validators.delegate(CommonValidators.required)],
    ),
    'newPassword': FormControl<String>(
      value: null,
      validators: [Validators.delegate(CommonValidators.required)],
    ),
    'confirmPassword': FormControl<String>(
      value: null,
      validators: [Validators.delegate(CommonValidators.required)],
    ),
  }, [
    Validators.delegate(CommonValidators.mustMatch(
        'newPassword', 'confirmPassword',
        markAsDirty: false)),
  ]);
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  Rx<ClientInfo?> info = Rxn<ClientInfo>();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
  }

  Future<void> submit() async {
    loading.value = true;

    try {
      Modal.loadingDialog();
      final response =
          await _changePasswordService.changePassword(formGroup.rawValue);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success".tr,
          "Change password successfully".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 40,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          overlayColor: Colors.transparent,
          isDismissible: true,
        );

        Get.offAllNamed('/menu');
      } else {
        Modal.errorDialog('Unsuccessful', '$response.statusMessage');
      }
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  Future<void> getUserInfo() async {
    loading.value = true;
    try {
      var response = await _changePasswordService.getUserInfo();

      var userInfo = ClientInfo.fromJson(response.data);
      formGroup.patchValue({'name': userInfo.name});
      info.value = userInfo;
    } catch (e) {
      print('Error reading from local storage: $e');
    } finally {
      loading.value = false;
    }
  }
}
