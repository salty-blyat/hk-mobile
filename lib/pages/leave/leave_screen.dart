import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_operation_screen.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';
import 'package:staff_view_ui/utils/theme.dart';

class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveTypeController leaveTypeController =
      Get.put(LeaveTypeController());

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
        title: Text('Leave'.tr),
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
                // SizedBox(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Obx(
                //       () => Row(
                //         spacing: 10,
                //         children:
                //             List.generate(leaveDetailData.length, (index) {
                //           return FatButton(
                //             leaveDays: leaveDetailData[index].leaveDays,
                //             leaveTotal: leaveDetailData[index].leaveTotal,
                //             titleLeave: leaveDetailData[index].title,
                //             isSelected: activeButtonIndex.value == index,
                //             onTap: () {
                //               activeButtonIndex.value = index;
                //             },
                //           );
                //         }),
                //       ),
                //     ),
                //   ),
                // ),
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
        ],
      ),
    );
  }
}
