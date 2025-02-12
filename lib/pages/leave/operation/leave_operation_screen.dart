import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/pages/leave/operation/leave_operation_controller.dart';
import 'package:staff_view_ui/pages/leave_type/leave_type_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';
import 'package:staff_view_ui/utils/widgets/date_range_picker.dart';
import 'package:staff_view_ui/utils/widgets/file_picker.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class LeaveOperationScreen extends StatelessWidget {
  final LeaveOperationController controller =
      Get.put(LeaveOperationController());
  final LeaveTypeController leaveTypeController =
      Get.put(LeaveTypeController());
  final filePickerController = Get.put(FilePickerController());

  LeaveOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
        ),
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
        scrolledUnderElevation: 0,
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
          icon: Icon(
            Platform.isIOS ? CupertinoIcons.chevron_back : Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ReactiveForm(
                  formGroup: controller.formGroup,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLeaveTypeButtons(context),
                        // LeaveTypeSelect(
                        //   leaveTypeId: controller.leaveType.value,
                        // ),
                        const SizedBox(height: 4),
                        _buildLeaveTypeNote(),
                        const SizedBox(height: 8),
                        _buildRequestDetails(),
                        const SizedBox(height: 16),
                        DateRangePicker(
                          formGroup: controller.formGroup,
                          fromDateControlName: 'fromDate',
                          toDateControlName: 'toDate',
                          onDateSelected: (dateRange) {
                            controller.calculateTotalDays();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTotalDaysAndLeaveUnit(),
                        const SizedBox(height: 16),
                        _buildBalanceAndOtherDetails(),
                        const SizedBox(height: 16),
                        FilePickerWidget(formGroup: controller.formGroup),
                      ],
                    ),
                  ),
                ),
              ),
      ),
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
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {},
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
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected = controller.leaveType.value == leaveType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    controller.updateLeaveType(leaveType.id!);
                    leaveTypeController.enableLeaveUnit(
                        controller.leaveType.value,
                        (value) => controller.isAllowHour.value = value);
                    if (!controller.isAllowHour.value) {
                      controller.updateLeaveUnit('1');
                    }
                  },
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
          child: DatePicker(
            label: 'Request Date'.tr,
            formControlName: 'date',
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
          ),
        ),
      ],
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
        Expanded(child: Obx(() {
          return DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: controller.leaveUnit.value.isEmpty
                ? null
                : controller.leaveUnit.value,
            items: LeaveUnit.values
                .map((unit) => DropdownMenuItem(
                      value: unit.value.toString(),
                      child: Text(
                        unit.name.toString().tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: controller.isAllowHour.value
                ? (value) {
                    controller.updateLeaveUnit(value!);
                  }
                : null, // Disable onChanged if not allowed
            decoration: InputDecoration(
              labelText: 'Leave unit'.tr,
              fillColor: Colors.grey.shade200,
              filled: !controller.isAllowHour.value,
              enabled:
                  controller.isAllowHour.value, // Dynamically disable field
            ),
          );
        })),
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
        MyFormField(
          label: 'Reason'.tr,
          controlName: 'reason',
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        StaffSelect(
          formControlName: 'approverId',
          formGroup: controller.formGroup,
          isEdit: controller.id.value != 0,
        ),
      ],
    );
  }
}
