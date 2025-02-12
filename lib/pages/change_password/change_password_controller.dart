import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/change_password/change_password_service.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/snack_bar.dart';

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
    Get.focusScope?.unfocus();
    if (formGroup.valid) {
      try {
        Modal.loadingDialog();
        final response =
            await _changePasswordService.changePassword(formGroup.rawValue);

        if (response.statusCode == 200) {
          successSnackbar('Success', 'Change password successfully');
          Get.offAllNamed('/menu');
        }
      } catch (e) {
        print(e);
      }
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
      print(e);
    } finally {
      loading.value = false;
    }
  }
}
