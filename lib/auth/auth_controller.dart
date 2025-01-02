import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/client_info_model.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  final loading = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final FormGroup formGroup = fb.group({
    'username': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });
  final FormGroup changePasswordForm = fb.group({
    'username':
        FormControl<String>(validators: [Validators.required], disabled: true),
    'oldPassword': FormControl<String>(validators: [Validators.required]),
    'newPassword': FormControl<String>(validators: [Validators.required]),
    'confirmPassword': FormControl<String>(validators: [Validators.required]),
  });
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  @override
  void onInit() {
    super.onInit();
    // logout();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final authData = await _authService
          .readFromLocalStorage(Const.authorized['Authorized']!);
      auth.value = authData != null && authData.isNotEmpty
          ? ClientInfo.fromJson(jsonDecode(authData))
          : ClientInfo();
      changePasswordForm.control('username').value = auth.value?.name;
    } catch (e) {
      print('Error reading from local storage: $e');
    }
  }

  login() async {
    loading.value = true;
    try {
      final response = await _authService.login(
        formGroup.value,
        false,
      );
      if (response == 200) {
        Get.offAllNamed('/menu');
      }
    } catch (e) {
      error.value = 'Check your username or password';
    } finally {
      loading.value = false;
    }
  }

  logout() {
    _authService.deleteFromLocalStorage(Const.authorized['Authorized']!);
    secureStorage.delete(key: Const.authorized['AccessToken']!);
    secureStorage.delete(key: Const.authorized['RefreshToken']!);
  }
}
