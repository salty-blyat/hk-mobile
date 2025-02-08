import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyFormField<T> extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool disabled;
  final bool password;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  final String? controlName;
  final bool enableSuggestions;
  final bool Function(AbstractControl<dynamic> control)? showErrors;
  final void Function(FormControl<T>)? onChanged;

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
    this.showErrors,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!password) {
      return _buildFormField(context, false.obs, disabled.obs);
    }
    final isPasswordVisible = false.obs;
    return Obx(() => _buildFormField(context, isPasswordVisible, disabled.obs));
  }

  Widget _buildFormField(
      BuildContext context, RxBool isPasswordVisible, RxBool isDisabled) {
    return SizedBox(
      height: 72,
      child: ReactiveTextField<T>(
        textAlignVertical: TextAlignVertical.bottom,
        maxLines: password ? 1 : maxLines,
        controller: controller,
        validationMessages: {
          ValidationMessage.required: (_) => 'Input is required!'.tr,
        },
        formControlName: controlName,
        obscureText: password ? !isPasswordVisible.value : false,
        enableSuggestions: enableSuggestions,
        autocorrect: false,
        showErrors: showErrors,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 48,
            maxHeight: 48,
          ),
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Icon(icon,
                      size: 18,
                      color:
                          isDisabled.value ? Colors.grey[600] : Colors.black87),
                )
              : null,
          labelText: label.tr,
          labelStyle: context.textTheme.bodyMedium!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          filled: isDisabled.value,
          helperStyle: const TextStyle(height: 0.8),
          errorStyle: const TextStyle(height: 0.8),

          fillColor: isDisabled.value ? Colors.grey[200] : null,
          // prefixIconColor: isDisabled.value ? Colors.grey[600] : null,
          suffixIcon: password
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                )
              : null,
        ),
      ),
    );
  }
}
