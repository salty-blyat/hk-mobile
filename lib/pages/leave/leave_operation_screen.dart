import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_type/leave_type_controller.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class LeaveOperationScreen extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  final LeaveTypeController leaveTypeController =
      Get.put(LeaveTypeController());
  LeaveOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave Request'.tr,
          style: context.textTheme.titleLarge!.copyWith(
              color: Colors.black,
              fontFamilyFallback: ['NotoSansKhmer', 'Gilroy']),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Leave Type Buttons
                Obx(() {
                  if (leaveTypeController.isLoading.value) {
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
                  if (leaveTypeController.leaveTypes.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: leaveTypeController.leaveTypes.length,
                      itemBuilder: (context, index) {
                        final leaveType = leaveTypeController.leaveTypes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.leaveType.value ==
                                      leaveTypeController.leaveTypes[index].id
                                          .toString()
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              foregroundColor: controller.leaveType.value ==
                                      leaveTypeController.leaveTypes[index].id
                                          .toString()
                                  ? Colors.white
                                  : Colors.black,
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () {
                              controller.updateLeaveType(leaveTypeController
                                  .leaveTypes[index].id
                                  .toString());
                            },
                            child: Text(leaveType.name ?? ''),
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                // Request No and Request Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MyFormField(
                        label: 'Request No'.tr,
                        disabled: true,
                        controller: controller.leaveNoController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DatePicker(
                        label: 'Request Date'.tr,
                        icon: Icons.calendar_month,
                        enabled: false,
                        onTap: () {},
                        controller: controller.dateController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // From Date and To Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DatePicker(
                        label: 'From date'.tr,
                        icon: Icons.date_range,
                        onTap: () async {
                          await dateRangePicker(context);
                        },
                        controller: controller.fromDateController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DatePicker(
                        label: 'To date'.tr,
                        icon: Icons.date_range,
                        onTap: () async {
                          await dateRangePicker(context);
                        },
                        controller: controller.toDateController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Days and Leave Type
                Row(
                  children: [
                    Obx(() {
                      if (controller.leaveUnit.value == '1') {
                        return Expanded(
                            child: MyFormField(
                          label: 'Total (days)'.tr,
                          controller: controller.totalDaysController,
                          disabled: true,
                        ));
                      }
                      return Expanded(
                          child: MyFormField(
                        label: 'Total (hours)'.tr,
                        controller: controller.totalHoursController,
                        disabled: true,
                      ));
                    }),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.leaveUnit.value.isEmpty
                              ? null
                              : controller.leaveUnit.value,
                          items: leaveTypeController.leaveUnits
                              .map((unit) => DropdownMenuItem(
                                    value: unit['id'],
                                    child: Text(unit['name']!,
                                        style: context.textTheme.bodyMedium),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateLeaveType(value);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Leave unit'.tr,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dateRangePicker(BuildContext context) async {
    DateTime startDate = controller.fromDateController.text.isNotEmpty
        ? DateTime.parse(controller.fromDateController.text)
        : DateTime.now();
    DateTime endDate = controller.toDateController.text.isNotEmpty
        ? DateTime.parse(controller.toDateController.text)
        : DateTime.now();

    DateTimeRange? selectedDate = await showDateRangePicker(
      locale: const Locale('km', 'KH'),
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 150)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      controller.fromDateController.text = selectedDate.start
          .toIso8601String()
          .split('T')[0]; // Format as YYYY-MM-DD
      controller.toDateController.text = selectedDate.end
          .toIso8601String()
          .split('T')[0]; // Format as YYYY-MM-DD
    }
  }
}
