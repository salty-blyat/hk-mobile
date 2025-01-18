import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool disabled;
  final bool password;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  final String? controlName;
  const MyFormField({
    super.key,
    required this.label,
    this.icon,
    this.disabled = false,
    this.password = false,
    this.validator,
    this.controller,
    this.maxLines = 1,
    this.controlName,
  });

  @override
  Widget build(BuildContext context) {
    if (!password) {
      // Non-password fields don't need reactive state.
      return _buildFormField(context, false.obs);
    }
    // For password fields, create reactive state.
    final isPasswordVisible = false.obs;
    return Obx(() => _buildFormField(context, isPasswordVisible));
  }

  Widget _buildFormField(BuildContext context, RxBool isPasswordVisible) {
    return ReactiveTextField<String>(
      maxLines: password ? 1 : maxLines,
      controller: controller,
      validationMessages: {
        ValidationMessage.required: (_) => 'Input is required!'.tr,
      },
      formControlName: controlName,
      obscureText: password ? !isPasswordVisible.value : false,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: label.tr,
        labelStyle: context.textTheme.bodyMedium!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          height: 0,
        ),
        prefixIconColor: disabled ? Colors.grey[500] : null,
        suffixIcon: password
            ? IconButton(
                icon: Icon(isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              )
            : null,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
