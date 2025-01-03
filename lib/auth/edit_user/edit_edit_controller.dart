import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/client_info_model.dart';

class EditUserController extends GetxController {
  final _authService = AuthService();
  final loading = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final FormGroup editUserForm = fb.group({
    'username':
        FormControl<String>(validators: [Validators.required], disabled: true),
    'fullName': FormControl<String>(validators: [Validators.required]),
    'phone': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(validators: [Validators.required]),
  });

  Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    loading.value = true;
    try {
      final authData = await _authService
          .readFromLocalStorage(Const.authorized['Authorized']!);
      auth.value = authData != null && authData.isNotEmpty
          ? ClientInfo.fromJson(jsonDecode(authData))
          : ClientInfo();
      editUserForm.control('username').value = auth.value?.name;
      editUserForm.control('fullName').value = auth.value?.fullName;
      editUserForm.control('phone').value = auth.value?.phone;
      editUserForm.control('email').value = auth.value?.email;
    } catch (e) {
      print('Error reading from local storage: $e');
    } finally {
      loading.value = false;
    }
  }
}
