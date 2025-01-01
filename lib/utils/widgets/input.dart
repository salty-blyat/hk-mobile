import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool disabled;
  final bool password;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const MyFormField({
    super.key,
    required this.label,
    this.icon,
    this.disabled = false,
    this.password = false,
    this.validator,
    this.controller,
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
    return TextFormField(
      controller: controller,
      enabled: !disabled,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: password ? !isPasswordVisible.value : false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelStyle: context.textTheme.bodyMedium!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.normal,
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
        labelText: label.tr,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
