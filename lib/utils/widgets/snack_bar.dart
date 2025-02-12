import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:staff_view_ui/utils/theme.dart';

successSnackbar(String title, String message) {
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: Colors.black,
    icon: const Icon(
      CupertinoIcons.checkmark_circle,
      color: AppTheme.successColor,
      size: 40,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
    overlayColor: Colors.transparent,
    isDismissible: true,
  );
}

errorSnackbar(String title, String message) {
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: Colors.black,
    icon: const Icon(
      CupertinoIcons.exclamationmark_triangle,
      color: AppTheme.dangerColor,
      size: 40,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
    overlayColor: Colors.transparent,
    isDismissible: true,
  );
}

warningSnackbar(String title, String message) {
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: Colors.black,
    icon: const Icon(
      CupertinoIcons.exclamationmark_circle,
      color: AppTheme.warningColor,
      size: 40,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
    overlayColor: Colors.transparent,
    isDismissible: true,
  );
}
