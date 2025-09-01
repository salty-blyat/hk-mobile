import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/service_item_model.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';

class ServiceItemSelect extends StatelessWidget {
  ServiceItemSelect(
      {super.key,
      this.label = '',
      this.formControlName = '',
      this.serviceTypeId});
  final ServiceItemController controller = Get.put(ServiceItemController());
  final String label;
  final String formControlName;
  final int? serviceTypeId;

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
        onChanged: (value) {
          ServiceItem selected = controller.list
              .firstWhere((ServiceItem data) => data.id == value.value);
          controller.selected.value = selected;
          print(controller.selected.value);
        },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
