import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/change_password/change_password_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';
import 'package:staff_view_ui/utils/widgets/password_input.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Change Password'.tr),
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ReactiveForm(
                  formGroup: controller.formGroup,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Obx(
                        () => Container(
                          height: 94,
                          width: 94,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: controller.info.value?.profile?.isNotEmpty ==
                                  true
                              ? CircleAvatar(
                                  child: ClipOval(
                                    child: Image.network(
                                      controller.info.value!.profile!,
                                      fit: BoxFit.cover,
                                      height: 94,
                                      width: 94,
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
                      const SizedBox(
                        height: 32,
                      ),
                      MyFormField<String>(
                        controlName: 'name',
                        label: 'Username'.tr,
                        icon: CupertinoIcons.person_alt_circle,
                        disabled: controller.formGroup.control('name').disabled,
                      ),
                      PasswordField(
                        formControlName: 'oldPassword',
                        label: 'Old Password'.tr,
                        textInputAction: TextInputAction.next,
                      ),
                      PasswordField(
                        formControlName: 'newPassword',
                        label: 'New Password'.tr,
                        textInputAction: TextInputAction.next,
                      ),
                      PasswordField(
                        formControlName: 'confirmPassword',
                        label: 'Confirm Password'.tr,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
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
