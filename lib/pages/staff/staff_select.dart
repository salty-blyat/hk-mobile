import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/staff/staff_controller.dart';

class StaffSelect extends StatelessWidget {
  StaffSelect({super.key});
  final StaffSelectController controller = Get.put(StaffSelectController());

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
      onMenuStateChange: (isOpen) {
        if (isOpen) {
          controller.getStaff();
        }
      },
      isExpanded: true,
      hint: Text(
        'Select Item',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).hintColor,
        ),
      ),
      items: controller.staff
          .map((dynamic item) => DropdownMenuItem(
                value: item.id.toString(),
                child: Text(
                  item.name ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ))
          .toList(),
      // value: controller.selectedStaff,
      onChanged: (String? value) {
        // controller.selectedStaff = value!;
        print(value);
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        width: 140,
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
      ),
    ));
  }
}
