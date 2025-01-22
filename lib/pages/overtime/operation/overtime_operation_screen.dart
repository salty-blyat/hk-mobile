import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/pages/overtime/operation/overtime_operation_controller.dart';
import 'package:staff_view_ui/pages/overtime_type/overtime_type_controller.dart';
import 'package:staff_view_ui/pages/staff/staff_select.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/custom_slide_button.dart';

class OvertimeOperationScreen extends StatelessWidget {
  final OvertimeOperationController controller =
      Get.put(OvertimeOperationController());
  final OvertimeTypeController overtimeTypeController =
      Get.put(OvertimeTypeController());
  final filePickerController = Get.put(FilePickerController());
  final int id;

  OvertimeOperationScreen({super.key, this.id = 0});

  @override
  Widget build(BuildContext context) {
    if (id != 0) {
      controller.id.value = id;
      controller.find(id);
    }
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return MyButton(
            label: 'Submit',
            disabled: !controller.formValid.value,
            onPressed: () {
              if (controller.formValid.value) {
                controller.submit();
              }
            },
          );
        }),
      ),
      appBar: AppBar(
        title: Text(
          'Overtime Request'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.chevron_back, color: Colors.black),
        ),
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ReactiveForm(
                  formGroup: controller.formGroup,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOvertimeTypeButtons(context),
                        const SizedBox(height: 8),
                        _buildRequestDetails(),
                        const SizedBox(height: 16),
                        _buildDateField(),
                        const SizedBox(height: 16),
                        _buildTimeRangeFields(context),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ReactiveTextField<double>(
                                formControlName: 'overtimeHour',
                                decoration: InputDecoration(
                                  labelText: 'Total (hours)'.tr,
                                  fillColor: Colors.grey.shade200,
                                  filled: !controller.formGroup
                                      .control('overtimeHour')
                                      .enabled,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Spacer(flex: 1),
                          ],
                        ),
                        const SizedBox(height: 16),
                        StaffSelect(
                          formControlName: 'approverId',
                          formGroup: controller.formGroup,
                          isEdit: id != 0,
                        ),
                        const SizedBox(height: 16),
                        ReactiveTextField<String>(
                          formControlName: 'note',
                          maxLines: 2,
                          decoration: InputDecoration(labelText: 'Note'.tr),
                        ),
                        const SizedBox(height: 16),
                        const SlidableWidget(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildOvertimeTypeButtons(BuildContext context) {
    return Obx(() {
      // Filter out the "All" item (id: 0)
      final lists = overtimeTypeController.lists
          .where((item) => item.id != 0)
          .toList(); // Create a new list without the "All" item

      if (lists.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 45,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length, // Use filtered list
          itemBuilder: (context, index) {
            final overtimeType = lists[index]; // Use filtered list
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.overtimeType.value == overtimeType.id;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () =>
                      controller.updateOvertimeType(overtimeType.id!),
                  child: Text(overtimeType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }

  Widget _buildDateField() {
    return ReactiveDatePicker<DateTime>(
      formControlName: 'date',
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (context, picker, child) {
        return GestureDetector(
          onTap: () {
            if (picker.control.enabled) {
              picker.showPicker();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date'.tr,
              suffixIcon: const Icon(CupertinoIcons.calendar),
              fillColor: Colors.grey.shade200,
              filled: !picker.control.enabled,
            ),
            child: Text(
              picker.control.value != null
                  ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
                  : '',
              style: TextStyle(
                color: picker.control.enabled ? null : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestDetails() {
    return Row(
      children: [
        Expanded(
          child: ReactiveTextField<String>(
            formControlName: 'requestNo',
            style: Get.textTheme.bodyLarge,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              labelText: 'Request No'.tr,
              hintText: 'New'.tr,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ReactiveDatePicker<DateTime>(
            formControlName: 'requestedDate',
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
            builder: (context, picker, child) {
              return GestureDetector(
                onTap: () {
                  if (picker.control.enabled) {
                    picker.showPicker();
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Request Date'.tr,
                    suffixIcon: const Icon(CupertinoIcons.calendar),
                    fillColor: Colors.grey.shade200,
                    filled: !picker.control.enabled,
                  ),
                  child: Text(
                    picker.control.value != null
                        ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
                        : '',
                    style: TextStyle(
                      color: picker.control.enabled ? null : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeField(
            context,
            formControlName: 'fromTime',
            label: 'From',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeField(
            context,
            formControlName: 'toTime',
            label: 'To',
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context,
      {required String formControlName, required String label}) {
    return ReactiveTimePicker(
      formControlName: formControlName,
      builder: (context, picker, child) {
        return GestureDetector(
          onTap: () {
            if (picker.control.enabled) {
              picker.showPicker();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label.tr,
              suffixIcon: const Icon(CupertinoIcons.clock),
              fillColor: Colors.grey.shade200,
              filled: !picker.control.enabled,
            ),
            child: Text(
              picker.control.value != null
                  ? picker.control.value!.format(context)
                  : TimeOfDay.now().format(context),
              style: TextStyle(
                color: picker.control.enabled ? null : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SlidableWidget extends StatefulWidget {
  const SlidableWidget({super.key});

  @override
  State<SlidableWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget>
    with SingleTickerProviderStateMixin {
  final filePickerController = Get.put(FilePickerController());
  final controller = Get.put(OvertimeOperationController());
  late final slidableController = SlidableController(this);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Slidable(
        controller: slidableController,
        key: const Key('attachment'),
        enabled: filePickerController.attachments.isNotEmpty,
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            CustomSlideButton(
              onPressed: () {
                if (filePickerController.attachments.isNotEmpty) {
                  controller.formGroup.control('attachments').value = [];
                  filePickerController.attachments.value = [];
                  slidableController.close();
                }
              },
              label: 'Delete'.tr,
              icon: CupertinoIcons.delete_solid,
              color: AppTheme.dangerColor,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (filePickerController.attachments.isNotEmpty) {
              controller.showAttachments();
              return;
            }
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              context: context,
              builder: (context) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Choose an image from'.tr,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Camera'.tr),
                      leading: const Icon(
                        CupertinoIcons.camera_fill,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        final attachment =
                            await filePickerController.pickImageFromCamera();
                        if (attachment != null) {
                          controller.formGroup.control('attachments').value.add(
                            {
                              'uid': attachment.uid,
                              'url': attachment.url,
                              'name': attachment.name,
                            },
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Photo'.tr),
                      leading: const Icon(
                        CupertinoIcons.photo_fill,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        final attachment =
                            await filePickerController.pickImageFromGallery();
                        if (attachment != null) {
                          controller.formGroup.control('attachments').value.add(
                            {
                              'uid': attachment.uid,
                              'url': attachment.url,
                              'name': attachment.name,
                            },
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Attachment'.tr),
                      leading: const Icon(
                        CupertinoIcons.doc_fill,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        final attachment =
                            await filePickerController.pickFile();
                        if (attachment != null) {
                          controller.formGroup.control('attachments').value.add(
                            {
                              'uid': attachment.uid,
                              'url': attachment.url,
                              'name': attachment.name,
                            },
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Cancel'.tr),
                      leading: const Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Obx(() {
                if (filePickerController.attachments.isNotEmpty) {
                  return filePickerController.isImage.value
                      ? Image.network(
                          filePickerController.attachments.first.url)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.doc_fill),
                            Text('Attachment'.tr),
                          ],
                        );
                }
                return Obx(() {
                  if (filePickerController.isUploading.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${'Uploading...'.tr} ${Const.percentageFormat(filePickerController.progress.value)}%',
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                            ),
                          ),
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade200,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                            value: filePickerController.progress.value,
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.cloud_upload),
                      Text('Attachment'.tr),
                    ],
                  );
                });
              }),
            ),
          ),
        ),
      ),
    );
  }
}
