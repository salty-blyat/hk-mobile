import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Tag extends StatelessWidget {
  const Tag({
    super.key,
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 22,
        padding:
            const EdgeInsets.symmetric(horizontal: 6), // Auto width padding
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          text.tr,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamilyFallback: const ['Gilroy', 'Kantumruy'],
          ),
        ),
      ),
    );
  }
}
