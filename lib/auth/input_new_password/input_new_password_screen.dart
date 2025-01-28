import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/input_new_password/input_new_password_controller.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class InputNewPasswordScreen extends StatelessWidget {
  InputNewPasswordScreen({super.key});
  final InputNewPasswordController controller =
      Get.put(InputNewPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reset password'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'At latest 6 characters, with uppercase lowercase number and symbol'
                  .tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 24),
            ReactiveForm(
              formGroup: controller.formGroup,
              child: Column(
                children: [
                  MyFormField(
                    icon: CupertinoIcons.lock,
                    label: 'Password'.tr,
                    controlName: 'password',
                    showErrors: (control) => control.invalid && control.dirty,
                    password: true,
                  ),
                  MyFormField(
                    icon: CupertinoIcons.lock,
                    label: 'Confirm Password'.tr,
                    controlName: 'confirmPassword',
                    password: true,
                    showErrors: (control) => control.invalid && control.dirty,
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => MyButton(
                      disabled: !controller.formValid.value,
                      label: 'Submit',
                      onPressed: controller.submit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
