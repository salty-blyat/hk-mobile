import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;
  final bool disabled;
  final Color? color;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Widget? child;
  final EdgeInsets? padding;
  final double? width;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.child,
    this.disabled = false,
    this.loading = false,
    this.icon,
    this.padding,
    this.color,
    this.textColor,
    this.borderRadius,
    this.borderSide
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? double.infinity, 40),
           padding: padding,
          textStyle:
              const TextStyle(fontFamilyFallback: ['Gilroy', 'Kantumruy']),
          backgroundColor: disabled
              ? Theme.of(context).disabledColor
              : color ?? Theme.of(context).colorScheme.primary,
          foregroundColor: disabled
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.38)
              : textColor ?? Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppTheme.borderRadius,
            side: borderSide ?? BorderSide.none,
          ),
          disabledBackgroundColor:
              (color ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.38),
          disabledForegroundColor: Colors.white,
        ),
        onPressed: disabled ? null : onPressed,
        child: child ?? Text(label.tr));
  }
}
