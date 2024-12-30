import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';

class AuthController extends GetxController {
  final _authService = AuthService();

  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final loading = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    logout();
  }

  login() async {
    loading.value = true;
    try {
      final response = await _authService.login(
        {
          'username': username.text,
          'password': password.text,
        },
        false,
      );
      if (response == 200) {
        Get.offAllNamed('/menu');
      }
    } catch (e) {
      print('error: $e');
      error.value = 'Check your username or password';
    } finally {
      loading.value = false;
    }
  }

  logout() {
    _authService.deleteFromLocalStorage('APP_STORAGE_KEY_Authorized');
  }
}
