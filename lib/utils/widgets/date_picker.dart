import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final TextEditingController controller;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: label.tr,
        labelStyle: context.textTheme.bodyMedium!.copyWith(
          color: Colors.black,
        ),
        suffixIcon: const Icon(CupertinoIcons.calendar),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
