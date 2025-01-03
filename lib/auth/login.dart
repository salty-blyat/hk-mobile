import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: MyButton(
          label: 'Login',
          onPressed: () =>
              controller.formGroup.valid ? controller.login() : null,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: controller.formGroup,
          child: ListView(
            children: [
              const SizedBox(height: 100),
              Image.asset('assets/images/logo.jpg', height: 100),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Login into your account'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              ReactiveTextField<String>(
                formControlName: 'username',
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required'.tr,
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Username'.tr,
                  helperText: '',
                  helperStyle: const TextStyle(height: 0.7),
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(
                () => ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: !controller.isPasswordVisible.value,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Input is required'.tr,
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password'.tr,
                    helperText: '',
                    helperStyle: const TextStyle(height: 0.7),
                    errorStyle: const TextStyle(height: 0.7),
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye),
                      onPressed: () {
                        controller.isPasswordVisible.value =
                            !controller.isPasswordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => controller.error.value.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.error.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink()),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Get.toNamed('/forget-password');
                  },
                  child: Text(
                    '${'Forgot Password'.tr}?',
                    style: const TextStyle(
                        fontFamilyFallback: ['NotoSansKhmer', 'Gilroy']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
