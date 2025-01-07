import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/auth/change_password/change_password_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class ChangePasswordController extends GetxController {
  final _authService = AuthService();
  final _changePasswordService = ChangePasswordService();
  final loading = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Change Password Form Group
  final FormGroup changePasswordForm = fb.group({
    'username':
        FormControl<String>(validators: [Validators.required], disabled: true),
    'oldPassword': FormControl<String>(validators: [Validators.required]),
    'newPassword': FormControl<String>(validators: [Validators.required]),
    'confirmPassword': FormControl<String>(validators: [Validators.required]),
  }, [
    Validators.mustMatch('newPassword', 'confirmPassword'),
  ]);
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> submit() async {
    loading.value = true;
    error.value = "";
    // print(changePasswordForm.value);
    try {
      final response =
          await _changePasswordService.changePassword(changePasswordForm.value);

      if (response == 200) {
        Get.snackbar("Success", "Password changed successfully".tr,
            snackPosition: SnackPosition.TOP);
        Get.offAllNamed('/menu');
        clearForm();
      } else if (response == 400) {
        Modal.errorDialog('Error', 'Password is incorrect!'.tr);
      } else {
        error.value = "Failed to change password. Please try again.";
      }
    } catch (e) {
      error.value = "An error occurred: $e";
    } finally {
      loading.value = false;
    }
  }

  void clearForm() {
    changePasswordForm.control('oldPassword').reset();
    changePasswordForm.control('newPassword').reset();
    changePasswordForm.control('confirmPassword').reset();
  }

  Future<void> getUserInfo() async {
    loading.value = true;
    try {
      final authData = await _authService
          .readFromLocalStorage(Const.authorized['Authorized']!);
      auth.value = authData != null && authData.isNotEmpty
          ? ClientInfo.fromJson(jsonDecode(authData))
          : ClientInfo();
      changePasswordForm.control('username').value = auth.value?.name;
    } catch (e) {
      print('Error reading from local storage: $e');
    } finally {
      loading.value = false;
    }
  }
}
