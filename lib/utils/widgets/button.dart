import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;
  final bool disabled;
  final Color? color;
  final Color? textColor;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.icon,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        textStyle: const TextStyle(fontFamilyFallback: ['Gilroy', 'Kantumruy']),
        backgroundColor: disabled
            ? Theme.of(context).disabledColor
            : color ?? Theme.of(context).colorScheme.primary,
        foregroundColor: disabled
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.38)
            : textColor ?? Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledBackgroundColor:
            (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.38),
        disabledForegroundColor: Colors.white,
      ),
      onPressed: disabled ? null : onPressed,
      child: Text(label.tr),
    );
  }
}
