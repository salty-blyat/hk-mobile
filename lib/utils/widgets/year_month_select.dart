import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/theme.dart';

class YearMonthSelect extends StatelessWidget {
  final selectedYear = DateTime.now().year.obs;
  final selectedMonth = DateTime.now().month.obs;
  final Function(int, int) onYearMonthSelected;

  YearMonthSelect({super.key, required this.onYearMonthSelected});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopupMenuButton<String>(
        splashRadius: 0,
        tooltip: '',
        onSelected: (String value) {
          final parts = value.split('-');
          selectedYear.value = int.parse(parts[0]);
          selectedMonth.value = int.parse(parts[1]);
          onYearMonthSelected(selectedYear.value, selectedMonth.value);
        },
        itemBuilder: (BuildContext context) {
          return _generateYearMonthList().map((date) {
            final value = '${date.year}-${date.month}';
            final isSelected = date.year == selectedYear.value &&
                date.month == selectedMonth.value;
            return PopupMenuItem<String>(
              value: value,
              height: 0,
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 16, right: 120),
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Text(
                      '${date.year}-${getMonth(date)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        offset: const Offset(-20, 40),
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                '${selectedYear.value}-${getMonth(DateTime(selectedYear.value, selectedMonth.value))}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                CupertinoIcons.chevron_down,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime> _generateYearMonthList() {
    final List<DateTime> yearMonthList = [];
    final DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month);

    for (int i = 0; i < 6; i++) {
      yearMonthList.add(currentDate);
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    }

    return yearMonthList;
  }
}
