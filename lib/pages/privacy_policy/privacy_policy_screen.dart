import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/privacy_policy/privacy_policy_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'.tr),
      ),
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
