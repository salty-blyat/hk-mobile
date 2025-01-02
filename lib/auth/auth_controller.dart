import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';

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
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    logout();
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
