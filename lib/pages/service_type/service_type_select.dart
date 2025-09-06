import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/service_type/service_type_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';

class ServiceTypeSelect extends StatelessWidget {
  ServiceTypeSelect({super.key, this.label = '', this.formControlName = ''});
  final ServiceTypeController controller = Get.put(ServiceTypeController());
  final String label;
  final String formControlName;
  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());

  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    controller.search();
    return Obx(
      () => ReactiveDropdownField<int>(
        menuMaxHeight: 300,
        isExpanded: true,
        dropdownColor: Colors.white,
        formControlName: formControlName,
        items: controller.list
            .map((data) => DropdownMenuItem(
                  key: ValueKey(data.id),
                  value: data.id,
                  child: Text(
                    data.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                    ),
                  ),
                ))
            .toList(),
        onChanged: (data) {
          serviceItemController.list.value = [];
          serviceItemController.selected.value = ServiceItem();
          serviceItemController.serviceTypeId.value = data.value as int;
          serviceItemController.search();
          // if (taskController.formGroup.control('serviceItemId').value != 0) {
          //   taskController.formGroup.control('serviceItemId').enabled;
          // } else {
          //   taskController.formGroup.control('serviceItemId').disabled;
          // }
        },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
