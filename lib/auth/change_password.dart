import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

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
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Image.asset('assets/images/logo.jpg', height: 100),
              const SizedBox(height: 16),
              MyFormField(
                label: 'Username'.tr,
                icon: Icons.person,
                disabled: true,
              ),
              const SizedBox(height: 16),
              MyFormField(
                label: 'Old Password'.tr,
                icon: Icons.lock,
                password: true,
              ),
              const SizedBox(height: 16),
              MyFormField(
                label: 'New Password'.tr,
                icon: Icons.lock,
                password: true,
              ),
              const SizedBox(height: 16),
              MyFormField(
                label: 'Confirm Password'.tr,
                icon: Icons.lock,
                password: true,
              ),
              const SizedBox(height: 16),
              MyButton(
                text: 'Change Password'.tr,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
