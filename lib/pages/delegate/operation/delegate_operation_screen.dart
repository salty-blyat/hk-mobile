import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/delegate/operation/delegate_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class DelegateOperationScreen extends StatelessWidget {
  final DelegatepOperationController controller =
      Get.put(DelegatepOperationController());
  final int? id;

  DelegateOperationScreen({super.key, this.id = 0});

  @override
  Widget build(BuildContext context) {
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
                          formControlName: 'delegateStaffId',
                          formGroup: controller.formGroup,
                          isEdit: id != 0,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveDatePicker<DateTime>(
                                formControlName: 'fromDate',
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, picker, child) {
                                  return ReactiveTextField<DateTime>(
                                    formControlName: 'fromDate',
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'From Date'.tr,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: picker.showPicker,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ReactiveDatePicker<DateTime>(
                                formControlName: 'toDate',
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, picker, child) {
                                  return ReactiveTextField<DateTime>(
                                    formControlName: 'toDate',
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'To Date'.tr,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: picker.showPicker,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<int>(
                          formControlName: 'totalDays',
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
}
