import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyFormField<T> extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool disabled;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  final String? controlName;
  final bool enableSuggestions;
  final bool Function(AbstractControl<dynamic> control)? showErrors;
  final void Function(FormControl<T>)? onChanged;

  const MyFormField(
      {super.key,
      required this.label,
      this.icon,
      this.disabled = false,
      this.validator,
      this.controller,
      this.maxLines = 1,
      this.controlName,
      this.enableSuggestions = false,
      this.showErrors,
      this.onChanged,
      obs});

  @override
  Widget build(BuildContext context) {
    return _buildFormField(context, disabled.obs);
  }

  Widget _buildFormField(BuildContext context, RxBool isDisabled) {
    return SizedBox(
      height: 72,
      child: ReactiveTextField<T>(
        keyboardType: TextInputType.visiblePassword,
        textAlignVertical: TextAlignVertical.bottom,
        maxLines: maxLines,
        controller: controller,
        validationMessages: {
          ValidationMessage.required: (_) => 'Input is required!'.tr,
        },
        formControlName: controlName,
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
        ),
      ),
    );
  }
}
