import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/request/operation/request_operation_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class ApproveRequest extends StatelessWidget {
  final RequestOperationController controller =
      Get.put(RequestOperationController());
  final int id;

  ApproveRequest({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    controller.formGroup.patchValue({'id': id});

    controller.isNextApprove.value = false;
    return Obx(() {
      return !controller.isNextApprove.value
          ? _buildApprove()
          : _buildNextApprove();
    });
  }

  Widget _buildApprove() {
    return Column(
      children: [
        ReactiveForm(
          formGroup: controller.formGroup,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'note',
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: '${'Note'.tr} (${'Optional'.tr})',
                ),
              ),
              const SizedBox(height: 16),
              MyButton(
                onPressed: controller.approve,
                loading: controller.loading.value,
                label: 'Approve'.tr,
                color: AppTheme.successColor,
              ),
              const SizedBox(height: 8),
              MyButton(
                onPressed: () {
                  controller.showNextApprover();
                },
                label: 'Send to next approver'.tr,
                color: Colors.grey.shade200,
                textColor: Colors.black87,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextApprove() {
    controller.formGroup.control('nextApproverId').markAsEnabled();
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () {
              controller.hideNextApprover();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ReactiveForm(
          formGroup: controller.formGroup,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'note',
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: '${'Note'.tr} (${'Optional'.tr})',
                ),
              ),
              const SizedBox(height: 16),
              StaffSelect(
                formControlName: 'nextApproverId',
                formGroup: controller.formGroup,
                labelText: 'Next Approver'.tr,
              ),
              const SizedBox(height: 16),
              Obx(() {
                return MyButton(
                  onPressed: controller.nextApprove,
                  disabled: !controller.formValid.value,
                  loading: controller.loading.value,
                  label: 'Submit'.tr,
                  color: AppTheme.primaryColor,
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}
