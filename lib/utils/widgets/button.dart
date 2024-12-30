import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disabled;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        textStyle: const TextStyle(fontFamilyFallback: ['Kantumruy', 'Gilroy']),
        backgroundColor: disabled
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.primary,
        foregroundColor: disabled
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.38)
            : Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: Text(text.tr),
    );
  }
}
