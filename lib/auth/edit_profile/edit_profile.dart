import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:staff_view_ui/auth/edit_profile/edit_profile_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class EditUser extends StatelessWidget {
  EditUser({super.key});
  final EditUserController controller = Get.put(EditUserController());

  @override
  Widget build(BuildContext context) {
    controller.getUserInfo();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit User'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: controller.formGroup,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Obx(
                () => Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: controller.info.value?.profile?.isNotEmpty == true
                      ? CircleAvatar(
                          child: ClipOval(
                            child: Image.network(
                              controller.info.value!.profile!,
                              fit: BoxFit.cover,
                              height: 84,
                              width: 84,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.8),
                          child: Text(
                            controller.info.value?.fullName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                '',
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
                    controller.info.value?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ReactiveTextField<String>(
                formControlName: 'name',
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required!'.tr,
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Username'.tr,
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.person_alt_circle),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'fullName',
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required!'.tr,
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Full Name'.tr,
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.person),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'phone',
                showErrors: (control) => control.dirty,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required!'.tr,
                  ValidationMessage.pattern: (_) =>
                      'Phone number is not valid!'.tr
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Phone Number'.tr,
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.phone),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'email',
                showErrors: (control) => control.dirty,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Input is required!'.tr,
                  ValidationMessage.email: (_) => 'Email is not valid!'.tr,
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email'.tr,
                  errorStyle: const TextStyle(height: 0.7),
                  prefixIcon: const Icon(CupertinoIcons.mail),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
        ),
        child: Obx(() {
          return MyButton(
            label: 'Save',
            disabled: !controller.formValid.value,
            onPressed: () {
              if (controller.formValid.value) {
                controller.submit();
              }
            },
          );
        }),
      ),
    );
  }
}
