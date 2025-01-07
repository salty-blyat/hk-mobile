import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/overtime/overtime_type/overtime_type_controller.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class OvertimeScreen extends StatelessWidget {
  OvertimeScreen({super.key});

  final OvertimeTypeController overtimeTypeController =
      Get.put(OvertimeTypeController());
  final selectedValue = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.to(() => LeaveOperationScreen());
        },
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text('Overtime'.tr),
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
                  child: YearSelect(
                    onYearSelected: (year) {},
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (overtimeTypeController.isLoading.value) {
                    return Skeletonizer(
                        child: SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Leave '),
                          ),
                        ),
                        itemCount: 10,
                      ),
                    ));
                  }
                  if (overtimeTypeController.overtimeTypes.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: overtimeTypeController.overtimeTypes.length,
                      itemBuilder: (context, index) {
                        final leaveType =
                            overtimeTypeController.overtimeTypes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Obx(() {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    selectedValue.value == leaveType.id
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                foregroundColor:
                                    selectedValue.value == leaveType.id
                                        ? Colors.white
                                        : Colors.black,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              onPressed: () {
                                // Update the selected overtime type
                                selectedValue.value = leaveType.id!;
                              },
                              child: Text(leaveType.name ?? ''),
                            );
                          }),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
