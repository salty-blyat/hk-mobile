import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/attendance_cycle_model.dart';
import 'package:staff_view_ui/pages/attendance_cycle/attendance_cycle_controller.dart';

class AttendanceCycleSelect extends StatelessWidget {
  final Function(AttendanceCycleModel) onSelected;

  const AttendanceCycleSelect({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final AttendanceCycleController controller =
        Get.put(AttendanceCycleController());

    // Use ever to listen for changes in loading state
    ever(controller.loading, (loading) {
      if (!loading) {
        // Data has finished loading
        final selected = controller.lists.firstWhere(
          (e) => e.id == controller.selected.value,
          orElse: () =>
              AttendanceCycleModel(), // Provide a default value if not found
        );
        onSelected.call(selected);
      }
    });

    return Obx(() {
      return controller.loading.value
          ? const CircularProgressIndicator()
          : PopupMenuButton<int>(
              child: Row(
                children: [
                  Text(
                    controller.lists
                            .firstWhere(
                                (e) => e.id == controller.selected.value)
                            .name ??
                        '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.chevron_down, size: 16),
                ],
              ),
              itemBuilder: (context) {
                return controller.lists
                    .map((e) => PopupMenuItem<int>(
                        value: e.id, child: Text(e.name ?? '')))
                    .toList();
              },
              onSelected: (value) {
                print(value);
                final selected =
                    controller.lists.firstWhere((e) => e.id == value);
                controller.selected.value = value;
                onSelected.call(selected);
              },
            );
    });
  }
}
