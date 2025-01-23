import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/pages/overtime/operation/overtime_operation_controller.dart';
import 'package:staff_view_ui/pages/overtime_type/overtime_type_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/file_picker.dart';

class OvertimeOperationScreen extends StatelessWidget {
  final OvertimeOperationController controller =
      Get.put(OvertimeOperationController());
  final OvertimeTypeController overtimeTypeController =
      Get.put(OvertimeTypeController());
  final filePickerController = Get.put(FilePickerController());
  final int id;

  OvertimeOperationScreen({super.key, this.id = 0});

  @override
  Widget build(BuildContext context) {
    if (id != 0) {
      controller.id.value = id;
      controller.find(id);
    }
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
        title: Text(
          'Overtime Request'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.black),
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
                        _buildOvertimeTypeButtons(context),
                        const SizedBox(height: 8),
                        _buildRequestDetails(),
                        const SizedBox(height: 16),
                        _buildDateField(),
                        const SizedBox(height: 16),
                        _buildTimeRangeFields(context),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ReactiveTextField<double>(
                                formControlName: 'overtimeHour',
                                decoration: InputDecoration(
                                  labelText: 'Total (hours)'.tr,
                                  fillColor: Colors.grey.shade200,
                                  filled: !controller.formGroup
                                      .control('overtimeHour')
                                      .enabled,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Spacer(flex: 1),
                          ],
                        ),
                        const SizedBox(height: 16),
                        StaffSelect(
                          formControlName: 'approverId',
                          formGroup: controller.formGroup,
                          isEdit: id != 0,
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<String>(
                          formControlName: 'note',
                          maxLines: 2,
                          decoration: InputDecoration(labelText: 'Note'.tr),
                        ),
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

  Widget _buildOvertimeTypeButtons(BuildContext context) {
    return Obx(() {
      // Filter out the "All" item (id: 0)
      final lists = overtimeTypeController.lists
          .where((item) => item.id != 0)
          .toList(); // Create a new list without the "All" item

      if (lists.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 45,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length, // Use filtered list
          itemBuilder: (context, index) {
            final overtimeType = lists[index]; // Use filtered list
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.overtimeType.value == overtimeType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () =>
                      controller.updateOvertimeType(overtimeType.id!),
                  child: Text(overtimeType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }

  Widget _buildDateField() {
    return ReactiveDatePicker<DateTime>(
      formControlName: 'date',
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (context, picker, child) {
        return GestureDetector(
          onTap: () {
            if (picker.control.enabled) {
              picker.showPicker();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date'.tr,
              suffixIcon: const Icon(CupertinoIcons.calendar),
              fillColor: Colors.grey.shade200,
              filled: !picker.control.enabled,
            ),
            child: Text(
              picker.control.value != null
                  ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
                  : '',
              style: TextStyle(
                color: picker.control.enabled ? null : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
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
            formControlName: 'requestedDate',
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
            builder: (context, picker, child) {
              return GestureDetector(
                onTap: () {
                  if (picker.control.enabled) {
                    picker.showPicker();
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Request Date'.tr,
                    suffixIcon: const Icon(CupertinoIcons.calendar),
                    fillColor: Colors.grey.shade200,
                    filled: !picker.control.enabled,
                  ),
                  child: Text(
                    picker.control.value != null
                        ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
                        : '',
                    style: TextStyle(
                      color: picker.control.enabled ? null : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeField(
            context,
            formControlName: 'fromTime',
            label: 'From',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeField(
            context,
            formControlName: 'toTime',
            label: 'To',
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context,
      {required String formControlName, required String label}) {
    return ReactiveTimePicker(
      formControlName: formControlName,
      builder: (context, picker, child) {
        return GestureDetector(
          onTap: () {
            if (picker.control.enabled) {
              picker.showPicker();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label.tr,
              suffixIcon: const Icon(CupertinoIcons.clock),
              fillColor: Colors.grey.shade200,
              filled: !picker.control.enabled,
            ),
            child: Text(
              picker.control.value != null
                  ? picker.control.value!.format(context)
                  : TimeOfDay.now().format(context),
              style: TextStyle(
                color: picker.control.enabled ? null : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
