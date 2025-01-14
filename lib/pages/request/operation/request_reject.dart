import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/request/operation/request_operation_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class RejectRequest extends StatelessWidget {
  final RequestOperationController controller =
      Get.put(RequestOperationController());
  final int id;

  RejectRequest({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: controller.formGroup,
      child: Column(
        children: [
          ReactiveTextField<String>(
            formControlName: 'note',
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Note'.tr,
            ),
          ),
          SizedBox(height: 16),
          MyButton(
            onPressed: controller.reject,
            label: 'Reject'.tr,
            color: AppTheme.dangerColor,
          ),
        ],
      ),
    );
  }
}
