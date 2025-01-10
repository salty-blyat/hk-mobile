import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/leave/operation/leave_operation_controller.dart';
import 'package:staff_view_ui/pages/leave_type/leave_type_controller.dart';
import 'package:staff_view_ui/pages/profile/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';

class LeaveOperationScreen extends StatelessWidget {
  final LeaveOperationController controller =
      Get.put(LeaveOperationController());
  final LeaveTypeController leaveTypeController =
      Get.put(LeaveTypeController());
  final int id;

  LeaveOperationScreen({super.key, this.id = 0});

  @override
  Widget build(BuildContext context) {
    if (id != 0) {
      controller.id.value = id;
      controller.find(id);
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return MyButton(
            label: 'Submit',
            disabled: !controller.formValid.value,
            onPressed: () {
              if (controller.formValid.value) {
                controller.submit();
              }
            },
          );
        }),
      ),
      appBar: AppBar(
        title: Text(
          'Leave Request'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.black),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ReactiveForm(
            formGroup: controller.formGroup,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLeaveTypeButtons(context),
                  const SizedBox(height: 4),
                  _buildLeaveTypeNote(),
                  const SizedBox(height: 8),
                  _buildRequestDetails(),
                  const SizedBox(height: 16),
                  _buildDateRangeFields(context),
                  const SizedBox(height: 16),
                  _buildTotalDaysAndLeaveUnit(),
                  const SizedBox(height: 16),
                  _buildBalanceAndOtherDetails(),
                  const SizedBox(height: 16),
                  _buildAttachmentUploader(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLeaveTypeButtons(BuildContext context) {
    return Obx(() {
      if (leaveTypeController.isLoading.value) {
        return Skeletonizer(
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    controller.calculateTotalDays();
                  },
                  child: const Text('Leave'),
                ),
              ),
            ),
          ),
        );
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
              child: Obx(() {
                final isSelected = controller.leaveType.value == leaveType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () => controller.updateLeaveType(leaveType.id!),
                  child: Text(leaveType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }

  Widget _buildLeaveTypeNote() {
    return Obx(() {
      final leaveType = leaveTypeController.leaveTypes
          .firstWhereOrNull((type) => type.id == controller.leaveType.value);
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 35,
          child: Text(
            leaveType?.note ?? '',
            style: Get.textTheme.bodySmall,
          ),
        ),
      );
    });
  }

  Widget _buildRequestDetails() {
    return Row(
      children: [
        Expanded(
          child: ReactiveTextField<String>(
            formControlName: 'requestNo',
            style: Get.textTheme.bodyLarge,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              labelText: 'Request No'.tr,
              hintText: 'New'.tr,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ReactiveDatePicker<DateTime>(
            formControlName: 'date',
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
            builder: (context, picker, child) {
              return DatePicker(
                label: 'Request Date'.tr,
                icon: Icons.calendar_month,
                enabled: false,
                controller: TextEditingController(
                  text: DateFormat('dd-MM-yyyy').format(picker.control.value!),
                ),
                onTap: () => dateRangePicker(context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            context,
            formControlName: 'fromDate',
            label: 'From date',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            context,
            formControlName: 'toDate',
            label: 'To date',
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context,
      {required String formControlName, required String label}) {
    return ReactiveDatePicker<DateTime>(
      formControlName: formControlName,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (context, picker, child) {
        return DatePicker(
          label: label.tr,
          icon: Icons.date_range,
          onTap: () => dateRangePicker(context),
          controller: TextEditingController(
            text: DateFormat('dd-MM-yyyy').format(picker.control.value!),
          ),
        );
      },
    );
  }

  Widget _buildTotalDaysAndLeaveUnit() {
    return Row(
      children: [
        Obx(() {
          final label = controller.leaveUnit.value == '1' ? 'days' : 'hours';

          return Expanded(
            child: ReactiveTextField<double>(
              formControlName: 'totalDays',
              onChanged: (value) => controller.updateBalance(),
              decoration: InputDecoration(
                labelText: 'Total ($label)'.tr,
                fillColor: Colors.grey.shade200,
                filled: controller.leaveUnit.value == '1',
              ),
            ),
          );
        }),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() {
            return DropdownButtonFormField<String>(
              value: controller.leaveUnit.value.isEmpty
                  ? null
                  : controller.leaveUnit.value,
              items: leaveTypeController.leaveUnits
                  .map((unit) => DropdownMenuItem(
                        value: unit['id'],
                        child: Text(
                          unit['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                          ),
                        ),
                        
                      ))
                  .toList(),
              onChanged: (value) => controller.updateLeaveUnit(value!),
              decoration: InputDecoration(labelText: 'Leave unit'.tr),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBalanceAndOtherDetails() {
    return Column(
      children: [
        ReactiveTextField<String>(
          formControlName: 'showBalance',
          decoration: InputDecoration(labelText: 'Balance'.tr),
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'reason',
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Reason'.tr,
          ),
        ),
        const SizedBox(height: 16),
        StaffSelect(
          formControlName: 'approverId',
          formGroup: controller.formGroup,
          isEdit: id != 0,
        ),
      ],
    );
  }

  Widget _buildAttachmentUploader() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.cloud_upload),
              Text('Attachment'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dateRangePicker(BuildContext context) async {
    final selectedDates = await showDateRangePicker(
      context: context,
      locale: Get.locale,
      initialDateRange: DateTimeRange(
        start: controller.formGroup.control('fromDate').value ?? DateTime.now(),
        end: controller.formGroup.control('toDate').value ?? DateTime.now(),
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (selectedDates != null) {
      controller.formGroup.control('fromDate').value = selectedDates.start;
      controller.formGroup.control('toDate').value = selectedDates.end;
      controller.calculateTotalDays();
    }
  }
}
