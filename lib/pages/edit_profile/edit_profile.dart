import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:staff_view_ui/pages/edit_profile/edit_profile_controller.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';
import 'package:staff_view_ui/utils/widgets/profile_avatar.dart';

class EditUser extends StatelessWidget {
  EditUser({super.key});
  final EditUserController controller = Get.put(EditUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit User'.tr),
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
                        () => ProfileAvatar(
                          isEdit: true,
                          profileImageUrl: controller.info.value?.profile,
                          fullName: controller.info.value?.fullName,
                          formGroup: controller.formGroup,
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
                      MyFormField<String>(
                        controlName: 'name',
                        label: 'Username'.tr,
                        icon: CupertinoIcons.person_alt_circle,
                        disabled: controller.formGroup.control('name').disabled,
                      ),
                      MyFormField<String>(
                        controlName: 'fullName',
                        label: 'Full Name'.tr,
                        icon: CupertinoIcons.person,
                        disabled:
                            controller.formGroup.control('fullName').disabled,
                      ),
                      MyFormField<String>(
                        controlName: 'phone',
                        label: 'Phone Number'.tr,
                        icon: CupertinoIcons.phone,
                        disabled:
                            controller.formGroup.control('phone').disabled,
                        showErrors: (control) =>
                            control.invalid && control.dirty,
                      ),
                      MyFormField<String>(
                        controlName: 'email',
                        label: 'Email'.tr,
                        icon: CupertinoIcons.mail,
                        disabled:
                            controller.formGroup.control('email').disabled,
                        showErrors: (control) =>
                            control.invalid && control.dirty,
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
