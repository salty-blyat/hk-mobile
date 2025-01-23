import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DatePicker extends StatelessWidget {
  final String formControlName;
  final DateTime firstDate;
  final DateTime lastDate;
  final String dateFormat;
  final String label;
  final Widget Function(
      BuildContext, ReactiveDatePickerDelegate<DateTime>, Widget?)? builder;

  // Static method for the builder to avoid instance method issues

  const DatePicker({
    super.key,
    required this.formControlName,
    required this.firstDate,
    required this.lastDate,
    this.dateFormat = 'dd-MM-yyyy',
    this.builder,
    this.label = 'Date',
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker<DateTime>(
      formControlName: formControlName,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: builder ?? _defaultPicker,
    );
  }

  Widget _defaultPicker(BuildContext context,
      ReactiveDatePickerDelegate<DateTime> picker, Widget? child) {
    return GestureDetector(
      onTap: () {
        if (picker.control.enabled) {
          picker.showPicker();
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label.tr,
          suffixIcon: const Icon(CupertinoIcons.calendar),
          fillColor: Colors.grey.shade200,
          filled: !picker.control.enabled,
        ),
        child: Text(
          picker.control.value != null
              ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
              : 'Select a date'.tr, // Placeholder text
          style: picker.control.enabled
              ? null
              : const TextStyle(color: Colors.grey), // Disabled style
        ),
      ),
    );
  }
}
