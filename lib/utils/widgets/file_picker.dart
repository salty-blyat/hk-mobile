import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/utils/theme.dart';

class FilePickerWidget extends StatelessWidget {
  FilePickerWidget(
      {super.key, required this.formGroup, this.controlName = 'attachments'});
  final FormGroup formGroup;
  final String controlName;
  final filePickerController = Get.put(FilePickerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() {
          if (filePickerController.attachments.isEmpty) {
            return const SizedBox.shrink();
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var attachment in filePickerController.attachments)
                GestureDetector(
                  onTap: () async {
                    var filePath =
                        '${(await getTemporaryDirectory()).path}/StaffView/${attachment.name}_${DateTime.now().millisecondsSinceEpoch}.${attachment.url.split('.').last}';
                    var res = await DioClient()
                        .dio
                        .download(attachment.url, filePath);
                    if (res.statusCode == 200) {
                      OpenFile.open(filePath);
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: AppTheme.borderRadius,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: filePickerController.isImageUrl(attachment.url)
                            ? SizedBox(
                                height: 64,
                                width: 64,
                                child: Image.network(
                                  attachment.url,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(CupertinoIcons.doc_fill),
                      ),
                      Positioned(
                        right: -22,
                        top: -22,
                        child: IconButton(
                          onPressed: () {
                            filePickerController.attachments.remove(attachment);
                            formGroup.control(controlName).value =
                                filePickerController.attachments.map((e) {
                              return {
                                'uid': e.uid,
                                'url': e.url,
                                'name': e.name,
                              };
                            }).toList();
                          },
                          icon: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              CupertinoIcons.clear_thick_circled,
                              color: AppTheme.dangerColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
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
                          formGroup.control(controlName).value.add(
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
                          formGroup.control(controlName).value.add(
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
                          for (var attachment in attachment) {
                            formGroup.control(controlName).value.add(
                              {
                                'uid': attachment.uid,
                                'url': attachment.url,
                                'name': attachment.name,
                              },
                            );
                          }
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
            height: 64,
            decoration: BoxDecoration(
              borderRadius: AppTheme.borderRadius,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.cloud_upload),
                  Text('Attachment'.tr),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
