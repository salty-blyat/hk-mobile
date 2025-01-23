import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/attendance_terminal/attendance_terminal_controller.dart';

class AttendanceTerminalSelect extends StatelessWidget {
  AttendanceTerminalSelect(
      {super.key, this.label = '', this.formControlName = ''});
  final AttendanceTerminalController controller =
      Get.put(AttendanceTerminalController());
  final String label;
  final String formControlName;

  @override
  Widget build(BuildContext context) {
    controller.search();
    return Obx(
      () => ReactiveDropdownField<int>(
        isExpanded: true,
        menuMaxHeight: 300,
        dropdownColor: Colors.white,
        formControlName: formControlName,
        items: controller.lists
            .map((item) => DropdownMenuItem(
                  key: ValueKey(item.id),
                  value: item.id,
                  child: Text(
                    item.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) => {},
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
