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
  final bool enableSuggestions;
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
    this.enableSuggestions = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!password) {
      // Non-password fields don't need reactive state.
      return _buildFormField(context, false.obs, disabled.obs);
    }
    // For password fields, create reactive state.
    final isPasswordVisible = false.obs;
    return Obx(() => _buildFormField(context, isPasswordVisible, disabled.obs));
  }

  Widget _buildFormField(
      BuildContext context, RxBool isPasswordVisible, RxBool isDisabled) {
    return ReactiveTextField<String>(
      maxLines: password ? 1 : maxLines,
      controller: controller,
      validationMessages: {
        ValidationMessage.required: (_) => 'Input is required!'.tr,
      },
      formControlName: controlName,
      obscureText: password ? !isPasswordVisible.value : false,
      enableSuggestions: enableSuggestions,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: label.tr,
        labelStyle: context.textTheme.bodyMedium!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        filled: isDisabled.value,
        fillColor: isDisabled.value ? Colors.grey[200] : null,
        prefixIconColor: isDisabled.value ? Colors.grey[600] : null,
        suffixIcon: password
            ? IconButton(
                icon: Icon(isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                iconSize: 18,
              )
            : null,
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      ),
    );
  }
}
