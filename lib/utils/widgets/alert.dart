import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:staff_view_ui/utils/theme.dart';

class Alert {
  static void errorAlert(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppTheme.dangerColor.withOpacity(0.7),
        colorText: Colors.white);
  }

  static void successAlert(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppTheme.successColor.withOpacity(0.7),
        colorText: Colors.white);
  }

  static void warningAlert(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppTheme.warningColor.withOpacity(0.7),
        colorText: Colors.white);
  }
}
