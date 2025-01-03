import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;
  final bool disabled;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.loading = false,
    this.icon,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            ),
          const SizedBox(width: 8),
          Text(label.tr),
        ],
      ),
    );
  }
}
