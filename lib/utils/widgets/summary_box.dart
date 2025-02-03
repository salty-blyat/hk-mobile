import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/utils/theme.dart';

class SummaryBox extends StatelessWidget {
  final Widget child;
  final String label;
  final double height;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const SummaryBox({
    super.key,
    required this.child,
    required this.label,
    this.height = 60,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child,
          Text(
            label.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class RichTextWidget extends StatelessWidget {
  final String value;
  final String unit;
  final double fontSize;

  const RichTextWidget({
    super.key,
    required this.value,
    required this.unit,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: Const.numberFormat(double.parse(value)),
            style: TextStyle(
              fontSize: fontSize,
              fontFamilyFallback: const ['Gilroy', 'Kantumruy'],
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: unit.tr,
            style: TextStyle(
              fontSize: fontSize - 2,
              fontFamilyFallback: const ['Gilroy', 'Kantumruy'],
            ),
          ),
        ],
      ),
    );
  }
}
