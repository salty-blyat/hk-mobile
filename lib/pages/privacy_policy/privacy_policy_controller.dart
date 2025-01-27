import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyController extends GetxController {
  late final WebViewController webViewController;
  final String privacyUrl = AppSetting.setting['PRIVACY_URL']!;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
      ))
      ..loadRequest(Uri.parse(privacyUrl));
  }
}
