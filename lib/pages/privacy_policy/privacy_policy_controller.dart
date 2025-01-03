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
    webViewController = WebViewController()..loadRequest(Uri.parse(privacyUrl));
  }
}
