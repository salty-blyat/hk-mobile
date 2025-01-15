import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/delegate/operation/delegate_operation_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';

class DelegateOperationScreen extends StatelessWidget {
  final DelegatepOperationController controller =
      Get.put(DelegatepOperationController());
  final int id;

  DelegateOperationScreen({super.key, this.id = 0});

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
            label: 'Save',
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
          id == 0 ? 'Add Delegate'.tr : 'Edit Delegate'.tr,
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
                        StaffSelect(
                          labelText: 'Delegate staff',
                          formControlName: 'delegateStaffId',
                          formGroup: controller.formGroup,
                          isEdit: id != 0,
                          isDelegate: true,
                        ),
                        const SizedBox(height: 16),
                        _buildDateRangeFields(context),
                        const SizedBox(height: 16),
                        ReactiveTextField<int>(
                          formControlName: 'totalDays',
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Total (days)'.tr,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<String>(
                          formControlName: 'note',
                          decoration: InputDecoration(
                            labelText: 'Note'.tr,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
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
