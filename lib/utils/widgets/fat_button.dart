import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/theme.dart';

class FatButton extends StatelessWidget {
  final int leaveDays;
  final int leaveTotal;
  final String titleLeave;
  final bool isSelected;
  final VoidCallback onTap;

  const FatButton({
    super.key,
    required this.leaveDays,
    required this.leaveTotal,
    required this.titleLeave,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 72,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '$leaveDays',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const TextSpan(
                      text: '/',
                      style: TextStyle(fontSize: 12, letterSpacing: 1),
                    ),
                    TextSpan(
                      text: '$leaveTotal',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                titleLeave.tr,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
