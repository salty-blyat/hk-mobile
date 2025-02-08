import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class DocumentTypeSelect extends StatelessWidget {
  DocumentTypeSelect({
    super.key,
    this.lookupTypeId = 0,
    required this.selectedId,
    required this.onSelect,
  });
  final LookupController controller = Get.put(LookupController());
  final int lookupTypeId;
  final RxInt selectedId;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    controller.fetchLookups(lookupTypeId);

    return Obx(() {
      if (controller.isLoading.value) {
        return Skeletonizer(
          child: Container(
            height: 45,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadius,
                    ),
                  ),
                  child: Text('All'.tr),
                ),
              ),
            ),
          ),
        );
      }
      if (controller.lookups.isEmpty) {
        return const SizedBox.shrink();
      }

      final List<dynamic> lists =
          controller.lookups.map((lookup) => lookup.toJson()).toList();
      if (lists.isNotEmpty) {
        lists.insert(0, {
          'id': 0,
          'lookupTypeId': 27,
          'name': 'All',
          'nameKh': 'ទាំងអស់',
        });
      }

      return Container(
        height: 45,
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final documentType = lists[index];

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                // Check if this documentType is selected
                final isSelected = selectedId.value == documentType['id'];

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadius,
                    ),
                  ),
                  onPressed: () {
                    onSelect(
                        documentType['id']); // Pass the id of the selected item
                  },
                  child: Text(documentType['nameKh'] ?? ''), // Display 'nameKh'
                );
              }),
            );
          },
        ),
      );
    });
  }
}
