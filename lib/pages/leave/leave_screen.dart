import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_operation_screen.dart';
import 'package:staff_view_ui/utils/widgets/calender_box.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';
import 'package:staff_view_ui/utils/theme.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => LeaveOperationScreen());
        },
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text('Leave'.tr,
            style: context.textTheme.titleLarge!.copyWith(
              color: Colors.white,
            )),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year Selection
                SizedBox(
                  height: 20,
                  child: YearSelect(),
                ),
                const SizedBox(height: 10),
                // Fat button Selection
              ],
            ),
          ),
          // Label monthly
          Container(
            color: AppTheme.secondaryColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Text(
                'December'.tr,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                  Text('ប្រចាំឆ្នាំ'),
                                  SizedBox(width: 5),
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
                              Text('សុំច្បាប់'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('1109'),
                              const SizedBox(height: 10),
                              Text('រង់ចាំអនុម័ត'),
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
          )
        ],
      ),
    );
  }
}
