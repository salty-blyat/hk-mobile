import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/forgot_password/forgot_password_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Forgot Password'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your email or phone for the verification process'
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyFormField(
                    icon: Icons.send,
                    label: 'Email or Phone'.tr,
                    controlName: 'sendTo',
                    onChanged: (value) {
                      controller.error.value = '';
                    },
                  ),
                  Obx(() => controller.error.value.isNotEmpty
                      ? Text(
                          controller.error.value,
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.dangerColor,
                                  ),
                        )
                      : const SizedBox.shrink()),
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
