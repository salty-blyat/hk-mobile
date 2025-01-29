import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/pages/attendance_terminal/attendance_terminal_select.dart';
import 'package:staff_view_ui/pages/exception/operation/exception_operation_controller.dart';
import 'package:staff_view_ui/pages/exception_type/exception_type_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_select.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';
import 'package:staff_view_ui/utils/widgets/date_range_picker.dart';
import 'package:staff_view_ui/utils/widgets/date_time_picker.dart';
import 'package:staff_view_ui/utils/widgets/file_picker.dart';

class ExceptionOperationScreen extends StatelessWidget {
  final ExceptionOperationController controller =
      Get.put(ExceptionOperationController());
  final ExceptionTypeController exceptionTypeController =
      Get.put(ExceptionTypeController());
  final filePickerController = Get.put(FilePickerController());

  ExceptionOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Exception Request'.tr,
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
                        _buildExceptionTypeButtons(context),
                        const SizedBox(height: 16),
                        _buildRequestDetails(),
                        const SizedBox(height: 16),
                        if (controller.exceptionTypeId.value ==
                            EXCEPTION_TYPE.ABSENT_EXCEPTION.value)
                          _buildAbsentException(),
                        if (controller.exceptionTypeId.value ==
                            EXCEPTION_TYPE.MISS_SCAN.value)
                          _buildScanException(),
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

  Widget _buildExceptionTypeButtons(BuildContext context) {
    return Obx(() {
      final lists = exceptionTypeController.exceptionTypes
          .where((item) => item.id != 0)
          .toList();
      if (exceptionTypeController.isLoading.value) {
        return Skeletonizer(
          ignoreContainers: true,
          enabled: true,
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Exception'),
                ),
              ),
            ),
          ),
        );
      }

      if (lists.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final exceptionType = lists[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.exceptionTypeId.value == exceptionType.id;

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
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onPressed: () =>
                      controller.updateExceptionType(exceptionType.id!),
                  child: Text(exceptionType.name ?? ''),
                );
              }),
            );
          },
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
            formControlName: 'requestedDate',
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceAndOtherDetails() {
    return Column(
      children: [
        ReactiveTextField<String>(
          formControlName: 'note',
          maxLines: 2,
          decoration: InputDecoration(
            labelText: '${'Note'.tr} (${'Optional'.tr})',
          ),
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

  Widget _buildScanException() {
    return Column(
      children: [
        DateTimePicker(
          controlName: 'scanTime',
          label: 'Scan time'.tr,
          firstDate: DateTime(1900),
          lastDate: DateTime(2200),
          onDateTimeSelected: (date, time) {
            controller.updateScanTime(date, time);
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AttendanceTerminalSelect(
                formControlName: 'terminalId',
                label: 'Terminal'.tr,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LookupSelect(
                lookupTypeId: LookupTypeEnum.checkInOutType.value,
                formControlName: 'scanType',
                label: 'Scan type'.tr,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbsentException() {
    return Column(
      children: [
        LookupSelect(
          lookupTypeId: LookupTypeEnum.absentException.value,
          formControlName: 'absentType',
          label: 'Absent type'.tr,
        ),
        const SizedBox(height: 16),
        DateRangePicker(
          formGroup: controller.formGroup,
          fromDateControlName: 'fromDate',
          toDateControlName: 'toDate',
          onDateSelected: (dateRange) {
            controller.calculateTotalDays();
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Obx(() {
              final label = controller.unit.value == '1' ? 'days' : 'hours';

              return Expanded(
                child: Obx(() {
                  final isEnabled = controller.unit.value == '1';
                  return ReactiveTextField<double>(
                    formControlName: 'totalDays',
                    onChanged: (value) => {},
                    decoration: InputDecoration(
                      labelText: 'Total ($label)'.tr,
                      fillColor: Colors.grey.shade200,
                      filled: isEnabled,
                    ),
                  );
                }),
              );
            }),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: controller.unit.value.isEmpty
                      ? null
                      : controller.unit.value,
                  items: Unit.values
                      .map((unit) => DropdownMenuItem(
                            value: unit.value.toString(),
                            child: Text(
                              unit.name.toString().tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => controller.updateUnit(value!),
                  decoration:
                      InputDecoration(labelText: 'Absent exception unit'.tr),
                );
              }),
            ),
          ],
        )
      ],
    );
  }
}
