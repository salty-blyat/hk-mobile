import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';

class Modal {
  static successDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(message.tr),
                  ],
                ),
                MyButton(
                  label: 'Ok'.tr,
                  onPressed: () {
                    Navigator.of(Get.context!).pop();
                  },
                ),
              ],
            ),
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
        child: SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }

  static loadingDialog() {
    Get.dialog(
      Dialog.fullscreen(
        backgroundColor: Colors.white.withOpacity(0.1),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
