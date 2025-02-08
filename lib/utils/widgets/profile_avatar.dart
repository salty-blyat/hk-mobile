import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/image_picker_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class ProfileAvatar extends StatefulWidget {
  String? profileImageUrl;
  final String? fullName;
  final double size;
  final bool isEdit;
  final FormGroup? formGroup;

  ProfileAvatar({
    super.key,
    this.profileImageUrl,
    this.fullName,
    this.size = 94,
    this.isEdit = false,
    this.formGroup,
    // Default primary color
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final filePickerController = Get.put(FilePickerController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: widget.profileImageUrl?.isNotEmpty == true
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      widget.profileImageUrl!,
                      fit: BoxFit.cover,
                      height: widget.size,
                      width: widget.size,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.6),
                  child: Text(
                    widget.fullName?.substring(0, 1).toUpperCase() ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        if (widget.isEdit)
          Positioned(
            right: 5,
            bottom: 3,
            child: GestureDetector(
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
                            final attachment = await filePickerController
                                .pickImageFromCamera();
                            if (attachment != null) {
                              widget.formGroup?.control('profile').value =
                                  attachment.url;
                              setState(() {
                                widget.profileImageUrl = attachment.url;
                              });
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
                            final attachment = await filePickerController
                                .pickImageFromGallery();
                            if (attachment != null) {
                              widget.formGroup?.control('profile').value =
                                  attachment.url;
                              setState(() {
                                widget.profileImageUrl = attachment.url;
                              });
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: AppTheme.borderRadius,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
