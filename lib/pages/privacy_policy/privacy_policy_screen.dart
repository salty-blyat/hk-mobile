import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String privacyUrl = AppSetting.setting['PRIVACY_URL']!;

  late final WebViewController controller;
  PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()..loadRequest(Uri.parse(privacyUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
