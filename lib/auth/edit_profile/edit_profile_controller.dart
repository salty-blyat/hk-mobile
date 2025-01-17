// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/edit_profile/edit_profile_service.dart';
import 'package:staff_view_ui/models/client_info_model.dart';

class EditUserController extends GetxController {
  final editProfileService = EditProfileService();
  final loading = false.obs;
  final formValid = false.obs;
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();

  // Edit Profile Form Group
  final FormGroup formGroup = fb.group({
    'name': FormControl<String>(
      validators: [Validators.required],
      disabled: true,
    ),
    'fullName': FormControl<String>(
      validators: [Validators.required],
    ),
    'phone': FormControl<String>(
      validators: [
        Validators.required,
        Validators.pattern(r'^\+?[0-9]{10,15}$'),
      ],
    ),
    'email': FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'isEnabled2FA': FormControl<bool>(),
    'verifyMethod2FA': FormControl<int>(),
    'profile': FormControl<String>(value: ''),
  });

  Rx<ClientInfo?> info = Rxn<ClientInfo>();

  @override
  void onInit() {
    super.onInit();
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
  }

  Future<void> submit() async {}
  void setFormValue(ClientInfo info) {
    formGroup.patchValue({
      'name': info.name,
      'fullName': info.fullName,
      'phone': info.phone,
      'email': info.email,
      'isEnabled2FA': info.isEnabled2FA,
      'verifyMethod2FA': info.verifyMethod2FA,
      'profile': info.profile,
    });
  }

  Future<void> getUserInfo() async {
    loading.value = true;
    try {
      var response = await editProfileService.getUserInfo();

      var userInfo = ClientInfo.fromJson(response.data);
      setFormValue(userInfo);
      info.value = userInfo;
    } catch (e) {
      print('Error: $e');
    } finally {
      loading.value = false;
    }
  }
}
