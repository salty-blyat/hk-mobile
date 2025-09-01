import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_select.dart';
import 'package:staff_view_ui/pages/service_type/service_type_select.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class TaskOpScreen extends StatelessWidget {
  TaskOpScreen({super.key});
  final TaskController controller = Get.put(TaskController());
  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());
  final HousekeepingController hkController =
      Get.find<HousekeepingController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        _buildContent(context),
        _Footer(controller: controller),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    var selectedRooms = hkController.selected.toList()
      ..sort((a, b) {
        final aRoom = a.roomNumber ?? '';
        final bRoom = b.roomNumber ?? '';
        return aRoom.compareTo(bRoom);
      });
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: controller.formGroup,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rooms".tr),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Wrap(children: [
                        ...selectedRooms.map((r) => Badge(
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                child: Text(r.roomNumber ?? ''),
                              ),
                              backgroundColor: AppTheme.primaryColor,
                            )),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Expanded(
                      child: ReactiveRadioListTile(
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.all(0),
                        value: TaskFromEnum.internal.value,
                        formControlName: 'taskFrom',
                        title: Text("Internal".tr),
                      ),
                    ),
                    Expanded(
                      child: ReactiveRadioListTile(
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.all(0),
                        value: TaskFromEnum.guest.value,
                        formControlName: 'taskFrom',
                        title: Text("Guest".tr),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                StaffSelect(
                  formControlName: 'staffId',
                  formGroup: controller.formGroup,
                ),
                const SizedBox(height: 12),
                ServiceTypeSelect(
                  formControlName: 'serviceTypeId',
                  label: "Service Type".tr,
                ),
                const SizedBox(height: 12),
                ServiceItemSelect(
                  serviceTypeId: controller.serviceTypeId.value,
                  formControlName: 'serviceItemId',
                  label: "Service Item".tr,
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final trackQty =
                      serviceItemController.selected.value.trackQty ?? false;
                  return trackQty
                      ? MyFormField(
                          controlName: 'quantity',
                          label: 'Quantity'.tr,
                        )
                      : const SizedBox.shrink();
                }),
                MyFormField(
                  controlName: 'note',
                  label: 'Note'.tr,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 16,
            onPressed: () {},
            icon: const Icon(CupertinoIcons.clear, color: Colors.transparent),
          ),
          Center(
            child: Text(
              'Task'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          IconButton(
            iconSize: 16,
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final TaskController controller;

  const _Footer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionButton(
            context,
            label: 'Save'.tr,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              controller.submit();
            },
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
    bool disabled = false,
    bool loading = false,
  }) {
    return Expanded(
        child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: disabled ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    ));
  }
}
