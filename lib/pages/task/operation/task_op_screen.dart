import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_controller.dart';
import 'package:staff_view_ui/pages/service_item/service_item_select.dart';
import 'package:staff_view_ui/pages/service_type/service_type_select.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/pages/task/operation/task_op_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/file_picker.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class TaskOpScreen extends StatelessWidget {
  TaskOpScreen({super.key});
  final TaskOPController controller = Get.put(TaskOPController());
  final ServiceItemController serviceItemController =
      Get.put(ServiceItemController());

  final HousekeepingController hkController =
      Get.find<HousekeepingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
                controller.clearForm();
                hkController.selected.value = [];
              },
              icon: const Icon(Icons.arrow_back_rounded)),
          title: Text("Task".tr),
        ),
        body: Column(
          children: [
            _buildContent(context),
            _Footer(controller: controller),
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: controller.formGroup,
            child: Obx(() {
              var selectedRooms = hkController.selected.toList()
                ..sort((a, b) {
                  final aRoom = a.roomNumber ?? '';
                  final bRoom = b.roomNumber ?? '';
                  return aRoom.compareTo(bRoom);
                });
              return Skeletonizer(
                enabled: controller.loading.isTrue,
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
                          child: Wrap(spacing: 4, runSpacing: 4, children: [
                            ...selectedRooms.map((r) => Badge(
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    child: Text(r.roomNumber ?? ''),
                                  ),
                                  backgroundColor: AppTheme.primaryColor,
                                )),
                          ]),
                        )
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ReactiveRadioListTile(
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.all(0),
                            value: RequestTypes.internal.value,
                            formControlName: 'requestType',
                            title: Text("Internal".tr),
                          ),
                        ),
                        Expanded(
                          child: ReactiveRadioListTile(
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.all(0),
                            value: RequestTypes.guest.value,
                            formControlName: 'requestType',
                            title: Text("Guest".tr),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    ServiceTypeSelect(
                      formControlName: 'serviceTypeId',
                      label: "Service Type".tr,
                    ),
                    const SizedBox(height: 12),
                    ServiceItemSelect(
                      serviceTypeId:
                          controller.formGroup.control('serviceTypeId').value,
                      formControlName: 'serviceItemId',
                      label: "Service Item".tr,
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final trackQty =
                          serviceItemController.selected.value.trackQty ??
                              false;

                      return trackQty
                          ? MyFormField(
                              controlName: 'quantity', label: 'Quantity'.tr)
                          : const SizedBox.shrink();
                    }),
                    StaffSelect(
                      label: "Staff".tr,
                      formControlName: 'staffId',
                    ),
                    const SizedBox(height: 12),
                    MyFormField(
                      controlName: 'note',
                      label: 'Note'.tr,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    FilePickerWidget(formGroup: controller.formGroup),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReactiveFormConsumer(
                              builder: (context, formGroup, child) {
                            return _actionButton(
                              context,
                              disabled: !formGroup.valid,
                              label: 'Save'.tr,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              onPressed: () async {
                                await controller.submit();
                              },
                            );
                          })
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
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

class _Footer extends StatelessWidget {
  final TaskOPController controller;

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
          // ReactiveFormConsumer(builder: (context, formGroup, child) {
          //   return _actionButton(
          //     context,
          //     disabled: !formGroup.valid,
          //     label: 'Save'.tr,
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     foregroundColor: Colors.white,
          //     onPressed: () async {
          //       await controller.submit();
          //     },
          //   );
          // })
        ],
      ),
    );
  }
}
