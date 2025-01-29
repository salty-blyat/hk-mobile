import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/delegate/operation/delegate_operation_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/date_range_picker.dart';

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
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
        ),
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
                        StaffSelect(
                          labelText: 'Delegate staff',
                          formControlName: 'delegateStaffId',
                          formGroup: controller.formGroup,
                          isEdit: id != 0,
                          isDelegate: true,
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
                        const SizedBox(height: 16),
                        ReactiveTextField<int>(
                          formControlName: 'totalDays',
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Total (days)'.tr,
                            fillColor: Colors.grey.shade200,
                            filled: true,
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
}
