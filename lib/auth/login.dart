import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

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
          text: 'Login',
          onPressed: () => controller.formKey.currentState?.validate() ?? false
              ? controller.login()
              : null,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
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
              MyFormField(
                label: 'Username',
                icon: CupertinoIcons.person,
                controller: controller.username,
                validator: (value) => CommonValidators.required(value ?? ''),
              ),
              const SizedBox(height: 16),
              MyFormField(
                label: 'Password',
                icon: CupertinoIcons.lock,
                controller: controller.password,
                password: true,
                validator: (value) => CommonValidators.required(value ?? ''),
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
                        fontFamilyFallback: ['Kantumruy', 'Gilroy']),
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
