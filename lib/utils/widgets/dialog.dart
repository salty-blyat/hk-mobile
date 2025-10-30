import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/pages/app-info/app_info_operation_screen.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class Modal {
  static successDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Icon(CupertinoIcons.checkmark_circle,
                      size: 70, color: AppTheme.successColor),
                  const SizedBox(height: 10),
                  Text(
                    title.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(message.tr, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                ],
              ),
              MyButton(
                label: 'OK'.tr,
                onPressed: () {
                  Navigator.of(Get.context!).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static errorDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Icon(CupertinoIcons.clear_circled,
                      size: 70, color: AppTheme.dangerColor),
                  const SizedBox(height: 10),
                  Text(
                    title.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(message.tr, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                ],
              ),
              MyButton(
                label: 'Ok'.tr,
                onPressed: () => Navigator.of(Get.context!).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static loadingDialog() {
    Get.dialog(
      Dialog.fullscreen(
        backgroundColor: Colors.white.withOpacity(0.1),
        child: WillPopScope(
          onWillPop: () async {
            // Returning false prevents back navigation
            return false;
          },
          child: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )),
        ),
      ),
      barrierDismissible: false,
      name: 'loadingDialog',
    );
  }

  static showSettingDialog() {
    return Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.borderRadius,
      ),
      child: SizedBox(
        height: 370,
        width: double.infinity,
        child: AppInfoOperationScreen(),
      ),
    ));
  }

  static showFormDialog(Widget child, {double height = 370}) {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: child,
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showLanguageDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: Column(
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.clear,
                      color: Colors.transparent,
                    ),
                  ),
                  Text(
                    'Choose Language'.tr,
                    style: Theme.of(Get.context!).textTheme.titleMedium,
                  ),
                  IconButton(
                    iconSize: 16,
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  padding: const EdgeInsets.all(16),
                  itemCount: Const.languages.length,
                  itemBuilder: (context, index) {
                    final language = Const.languages[index];
                    final isSelected =
                        Get.locale?.languageCode == language['code'];
                    return ListTile(
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadius,
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      trailing: Icon(CupertinoIcons.checkmark_circle,
                          size: 20,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent),
                      title: Text(language['label'] ?? 'Unknown'),
                      leading: Image.asset(
                        language['image'] ?? 'assets/default.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Get.back();
                        if (language['key'] != null) {
                          var box = Storage();
                          box.write(
                              Const.authorized['Lang']!, language['code']);
                          Get.updateLocale(language['key']);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        child: SizedBox(
          height: 160,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: IconButton(
                      iconSize: 16,
                      onPressed: () {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        CupertinoIcons.clear,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Text(
                    'Logout'.tr,
                    style: Theme.of(Get.context!).textTheme.titleMedium,
                  ),
                  IconButton(
                    iconSize: 16,
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Text('Are you sure to logout?'.tr),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              label: 'Cancel'.tr.toUpperCase(),
                              color: AppTheme.secondaryColor,
                              textColor: Colors.black,
                              onPressed: Get.back, // Closes the dialog
                            ),
                          ),
                          const SizedBox(width: 24), // Space between buttons
                          Expanded(
                            child: MyButton(
                              label: 'Ok'.tr.toUpperCase(),
                              color: AppTheme.dangerColor,
                              onPressed: () {
                                Get.back(); // Close the dialog
                                loadingDialog();
                                AuthController().logout();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
