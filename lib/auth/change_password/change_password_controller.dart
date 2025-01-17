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
  final formValid = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Change Password Form Group
  final FormGroup formGroup = fb.group({
    'username': FormControl<String>(disabled: true),
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
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
  }

  Future<void> submit() async {
    loading.value = true;

    try {
      Modal.loadingDialog();
      final response =
          await _changePasswordService.changePassword(formGroup.value);

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
      error.value = "An error occurred: $e";
    } finally {
      loading.value = false;
    }
  }

  Future<void> getUserInfo() async {
    loading.value = true;
    try {
      final authData = await _authService
          .readFromLocalStorage(Const.authorized['Authorized']!);
      auth.value = authData != null && authData.isNotEmpty
          ? ClientInfo.fromJson(jsonDecode(authData))
          : ClientInfo();
      formGroup.control('username').value = auth.value?.name;
    } catch (e) {
      print('Error reading from local storage: $e');
    } finally {
      loading.value = false;
    }
  }
}
