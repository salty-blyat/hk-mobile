// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/edit_profile/edit_profile_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class EditUserController extends GetxController {
  final _editProfileService = EditProfileService();
  final loading = false.obs;
  final formValid = false.obs;
  final formKey = GlobalKey<FormState>();

  // Edit Profile Form Group
  final FormGroup formGroup = fb.group(
    {
      'name': FormControl<String>(
        value: null,
        validators: [Validators.delegate(CommonValidators.required)],
        disabled: true,
      ),
      'fullName': FormControl<String>(
        value: null,
        validators: [Validators.delegate(CommonValidators.required)],
      ),
      'phone': FormControl<String>(
        value: null,
        validators: [
          Validators.delegate(CommonValidators.required),
          Validators.delegate(CommonValidators.multiplePhoneValidator),
        ],
      ),
      'email': FormControl<String>(
        value: null,
        validators: [
          Validators.delegate(CommonValidators.required),
          Validators.delegate(CommonValidators.multipleEmailValidator),
        ],
      ),
      'isEnabled2FA': FormControl<bool>(value: false),
      'verifyMethod2FA': FormControl<int>(
        value: null,
        validators: [Validators.required],
      ),
      'profile': FormControl<String>(value: ''),
    },
  );

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
    try {
      Modal.loadingDialog();
      final response =
          await _editProfileService.editProfile(formGroup.rawValue);

      if (response.statusCode == 200) {
        await _editProfileService.saveToLocalStorage(
            Const.authorized['Authorized']!, jsonEncode(formGroup.rawValue));
        Get.snackbar(
          "Success".tr,
          "Edit profile successfully".tr,
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
    }
  }

  void updateRequiredFields() {
    final phoneControl = formGroup.control('phone') as FormControl<String>?;
    final emailControl = formGroup.control('email') as FormControl<String>?;

    if (phoneControl == null || emailControl == null) {
      return; // Exit if controls are missing to prevent crashes
    }

    bool isPhoneEmpty =
        phoneControl.value == null || phoneControl.value!.isEmpty;
    bool isEmailEmpty =
        emailControl.value == null || emailControl.value!.isEmpty;

    // Define validators with the correct type
    List<Validator<dynamic>> emailValidators = [
      Validators.delegate(CommonValidators.multipleEmailValidator)
    ];
    List<Validator<dynamic>> phoneValidators = [
      Validators.delegate(CommonValidators.multiplePhoneValidator)
    ];

    // Conditionally add 'required' validator
    if (isPhoneEmpty) {
      emailValidators.insert(0, Validators.delegate(CommonValidators.required));
    }
    if (isEmailEmpty) {
      phoneValidators.insert(0, Validators.delegate(CommonValidators.required));
    }
    // Set validators only if they have changed
    if (emailControl.validators.toString() != emailValidators.toString()) {
      emailControl.setValidators(emailValidators);
      emailControl.updateValueAndValidity();
    }

    if (phoneControl.validators.toString() != phoneValidators.toString()) {
      phoneControl.setValidators(phoneValidators);
      phoneControl.updateValueAndValidity();
    }

    emailControl.markAsDirty();
    phoneControl.markAsDirty();
  }

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
      var response = await _editProfileService.getUserInfo();

      var userInfo = ClientInfo.fromJson(response.data);
      setFormValue(userInfo);
      updateRequiredFields();

      info.value = userInfo;
    } catch (e) {
      print('Error fetching user info: $e');
    } finally {
      loading.value = false;
    }
  }
}
