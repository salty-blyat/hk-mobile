import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/custom_slide_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key, required this.formGroup});
  final FormGroup formGroup;

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget>
    with SingleTickerProviderStateMixin {
  final filePickerController = Get.put(FilePickerController());
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
                  widget.formGroup.control('attachments').value = [];
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
              launchUrl(Uri.parse(filePickerController.attachments.first.url));
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
                          widget.formGroup.control('attachments').value.add(
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
                      title: Text('Gallery'.tr),
                      leading: const Icon(
                        CupertinoIcons.photo_fill,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        final attachment =
                            await filePickerController.pickImageFromGallery();
                        if (attachment != null) {
                          widget.formGroup.control('attachments').value.add(
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
                          widget.formGroup.control('attachments').value.add(
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
