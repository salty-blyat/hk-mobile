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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.tr,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontFamilyFallback: const ['Kantumruy', 'Gilroy'],
        ),
      ),
    );
  }
}
