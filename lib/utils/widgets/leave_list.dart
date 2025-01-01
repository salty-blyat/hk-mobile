import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calender_box.dart';

class LeaveList extends StatelessWidget {
  const LeaveList({super.key});

  @override
  Widget build(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const CalenderBox(),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('ប្រចាំឆ្នាំ'),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                '5 ម៉ោង',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamilyFallback: [
                                    'NotoSansKhmer',
                                    'Gilroy'
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('សុំច្បាប់'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('1109'),
                        const SizedBox(height: 10),
                        Text('Pending'.tr),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
      ],
    );
  }
}
