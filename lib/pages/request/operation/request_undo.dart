import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/request/operation/request_operation_controller.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class UndoRequest extends StatelessWidget {
  final RequestOperationController controller =
      Get.put(RequestOperationController());
  final int id;

  UndoRequest({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    controller.formGroup.patchValue({'id': id});
    return ReactiveForm(
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
            label: 'Undo'.tr,
            onPressed: controller.undo,
            color: Colors.black87,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
