import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController controller = Get.put(AuthController());
  final MenuController menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              24, // Dynamic padding above keyboard
          left: 16,
          right: 16,
        ),
        child: Obx(() {
          return MyButton(
            label: 'Login',
            disabled: !controller.formValid.value,
            onPressed: () {
              if (controller.formValid.value) {
                controller.login();
              }
            },
          );
        }),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Modal.showLanguageDialog();
            },
            icon: const Icon(CupertinoIcons.globe, color: Colors.black87),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReactiveForm(
              formGroup: controller.formGroup,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child:
                          Image.asset('assets/images/logo.jpg', height: 100)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onDoubleTap: () {
                      Modal.showSettingDialog();
                    },
                    child: Center(
                      child: Text(
                        'Login into your account'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MyFormField(
                    icon: CupertinoIcons.person,
                    label: 'Username',
                    controlName: 'username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      controller.error.value = '';
                    },
                  ),
                  const SizedBox(height: 8),
                  MyFormField(
                    icon: CupertinoIcons.lock,
                    password: true,
                    label: 'Password',
                    controlName: 'password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      controller.error.value = '';
                    },
                  ),
                  // const SizedBox(height: 16),
                  Obx(() => controller.error.value.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              controller.error.value.tr,
                              style: const TextStyle(
                                color: AppTheme.dangerColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        )
                      : const SizedBox.shrink()),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     style: TextButton.styleFrom(
                  //       foregroundColor: Theme.of(context).colorScheme.primary,
                  //     ),
                  //     onPressed: () {
                  //       Get.toNamed('/forget-password');
                  //     },
                  //     child: Text(
                  //       '${'Forgot Password'.tr}?',
                  //       style: const TextStyle(
                  //         fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
