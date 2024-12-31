import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class LeaveOperationScreen extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  LeaveOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'.tr,
            style: context.textTheme.titleLarge!.copyWith(
              color: Colors.black,
            )),
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
          child: ListView(
            children: [
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
                  const SizedBox(width: 16), // Add spacing between fields
                  Expanded(
                    child: DatePicker(
                      label: 'Request Date'.tr,
                      icon: Icons.calendar_month,
                      enabled: false,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 150)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (selectedDate != null) {
                          controller.dateController.text = selectedDate
                              .toIso8601String()
                              .split('T')[0]; // Format as YYYY-MM-DD
                        }
                      },
                      controller: controller.dateController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                  const SizedBox(width: 16), // Add spacing between fields
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
              Row(
                children: [
                  Expanded(
                      child: Obx(
                    () => MyFormField(
                      label:
                          'Total ${controller.leaveTypeController.text} (days)'
                              .tr,
                      controller: controller.totalDaysController,
                      disabled: true,
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      items: [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('1'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('2'),
                        ),
                      ],
                      onChanged: (value) {
                        controller.leaveTypeController.text = value.toString();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dateRangePicker(BuildContext context) async {
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.parse(controller.fromDateController.text),
        end: DateTime.parse(controller.toDateController.text),
      ),
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
