import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/firebase_service.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  final _firebaseService = NotificationService();
  final loading = false.obs;
  final formValid = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final FormGroup formGroup = fb.group({
    'username': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  @override
  void onInit() {
    super.onInit();
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
  }

  // Login Form Group

  final isPasswordVisible = false.obs;

  Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  login() async {
    loading.value = true;
    try {
      Modal.loadingDialog();
      final response = await _authService.login(
        formGroup.value,
        false,
      );
      if (response == 200) {
        _firebaseService.handlePassToken();
        Get.offAllNamed('/menu');
      }
    } catch (e) {
      Get.back();
      error.value = 'Check your username or password';
    } finally {
      loading.value = false;
    }
  }

  logout() async {
    try {
      final res = await _firebaseService.handleRemoveToken();
      if (res.statusCode == 200) {
        handleLogout();
      } else {
        handleLogout();
      }
    } catch (e) {
      handleLogout();
    }
  }

  handleLogout() async {
    try {
      final res = await _authService.logout();
      if (res.statusCode == 200) {
        _authService.deleteFromLocalStorage(Const.authorized['Authorized']!);
        secureStorage.delete(key: Const.authorized['AccessToken']!);
        secureStorage.delete(key: Const.authorized['RefreshToken']!);
        Get.offAllNamed('/login');
      } else {
        handleLogoutError();
      }
    } catch (e) {
      handleLogoutError();
    }
  }

  handleLogoutError() {
    _authService.deleteFromLocalStorage(Const.authorized['Authorized']!);
    secureStorage.delete(key: Const.authorized['AccessToken']!);
    secureStorage.delete(key: Const.authorized['RefreshToken']!);
    Get.offAllNamed('/login');
  }
}
