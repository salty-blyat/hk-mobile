import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/staff/staff_controller.dart';

class StaffSelect extends StatelessWidget {
  StaffSelect({
    super.key,
    this.label = '',
    this.formControlName = '',
  });
  final StaffController controller = Get.put(StaffController());
  final String label;
  final String formControlName;

  @override
  Widget build(BuildContext context) { 
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.search();
      controller.list.insert(0, Staff(id: 0, name: '-'));
    });
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
        onChanged: (value) {},
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
} 