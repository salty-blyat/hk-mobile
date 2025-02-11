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

    ever(controller.loading, (loading) {
      if (!loading) {
        final selected = controller.lists.firstWhere(
          (e) => e.id == controller.selected.value,
          orElse: () => AttendanceCycleModel(),
        );
        onSelected.call(selected);
      }
    });

    return Obx(() {
      return controller.loading.value
          ? const CircularProgressIndicator()
          : PopupMenuButton<int>(
              offset: const Offset(0, 40),
              child: Container(
                width: 130,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              ),
              itemBuilder: (context) {
                return [
                  // Wrap the items in a ListView for scrolling
                  PopupMenuItem<int>(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.lists
                              .map(
                                (e) => PopupMenuItem<int>(
                                  value: e.id,
                                  height: 38,
                                  child: SizedBox(
                                    width: 90,
                                    child: Text(e.name ?? ''),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                final selected =
                    controller.lists.firstWhere((e) => e.id == value);
                controller.selected.value = value;
                onSelected.call(selected);
              },
            );
    });
  }
}
