import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/attendance_cycle_model.dart';
import 'package:staff_view_ui/pages/attendance_cycle/attendance_cycle_controller.dart';

class AttendanceCycleSelect extends StatefulWidget {
  final Function(AttendanceCycleModel) onSelected;

  AttendanceCycleSelect({super.key, required this.onSelected});

  @override
  _AttendanceCycleSelectState createState() => _AttendanceCycleSelectState();
}

class _AttendanceCycleSelectState extends State<AttendanceCycleSelect> {
  final AttendanceCycleController controller =
      Get.put(AttendanceCycleController());
  Worker? _worker; // Worker to manage the reactive listener

  @override
  void initState() {
    super.initState();
    // Set up the listener for when data finishes loading
    _worker = ever(controller.loading, (loading) {
      if (!loading) {
        // Data has finished loading
        final selected = controller.lists.firstWhere(
          (e) => e.id == controller.selected.value,
          orElse: () =>
              AttendanceCycleModel(), // Provide a default value if not found
        );
        widget.onSelected.call(selected);
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the worker when the widget is removed from the tree
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.onSelected.call(selected);
              },
            );
    });
  }
}
