import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: controller.changePasswordForm,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Obx(
                () => Container(
                  height: 84,
                  width: 84,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: controller.auth.value?.profile?.isNotEmpty == true
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(controller.auth.value!.profile!),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.8),
                          child: Text(
                            controller.auth.value?.fullName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                'N',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Center(
                  child: Text(
                    controller.auth.value?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ReactiveTextField<String>(
                formControlName: 'username',
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required'.tr,
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Username'.tr,
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.person),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ReactiveTextField<String>(
                  formControlName: 'oldPassword',
                  obscureText: !controller.isOldPasswordVisible.value,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Input is required'.tr,
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Old Password'.tr,
                    errorStyle: const TextStyle(height: 0.7),
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIcon: IconButton(
                      icon: Icon(controller.isOldPasswordVisible.value
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                      onPressed: () {
                        controller.isOldPasswordVisible.value =
                            !controller.isOldPasswordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ReactiveTextField<String>(
                  formControlName: 'newPassword',
                  obscureText: !controller.isNewPasswordVisible.value,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Input is required'.tr,
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'New Password'.tr,
                    errorStyle: const TextStyle(height: 0.7),
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIcon: IconButton(
                      icon: Icon(controller.isNewPasswordVisible.value
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                      onPressed: () {
                        controller.isNewPasswordVisible.value =
                            !controller.isNewPasswordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ReactiveTextField<String>(
                  formControlName: 'confirmPassword',
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Input is required'.tr,
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password'.tr,
                    errorStyle: const TextStyle(height: 0.7),
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIcon: IconButton(
                      icon: Icon(controller.isConfirmPasswordVisible.value
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                      onPressed: () {
                        controller.isConfirmPasswordVisible.value =
                            !controller.isConfirmPasswordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: MyButton(
          text: 'Save',
          loading: controller.loading.value,
          onPressed: () => {},
        ),
      ),
    );
  }
}
