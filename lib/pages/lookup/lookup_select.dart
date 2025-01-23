import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';

class LookupSelect extends StatelessWidget {
  LookupSelect(
      {super.key,
      this.lookupTypeId = 0,
      this.label = '',
      this.formControlName = ''});
  final LookupController controller = Get.put(LookupController());
  final int lookupTypeId;
  final String label;
  final String formControlName;

  @override
  Widget build(BuildContext context) {
    controller.fetchLookups(lookupTypeId);
    return Obx(
      () => ReactiveDropdownField<int>(
        menuMaxHeight: 300,
        isExpanded: true,
        dropdownColor: Colors.white,
        formControlName: formControlName,
        items: controller.lookups
            .map((lookup) => DropdownMenuItem(
                  key: ValueKey(lookup.id),
                  value: lookup.id,
                  child: Text(
                    lookup.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) => {},
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
