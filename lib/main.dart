import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:staff_view_ui/auth/change_password.dart';
import 'package:staff_view_ui/pages/absent_exception/absent_exception_screen.dart';
import 'package:staff_view_ui/pages/delegate/delegate_screen.dart';
import 'package:staff_view_ui/pages/document/document_screen.dart';
import 'package:staff_view_ui/pages/exception/exception_screen.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/pages/menu/menu_screen.dart';
import 'package:staff_view_ui/pages/overtime/overtime_screen.dart';
import 'package:staff_view_ui/pages/privacy_policy/privacy_policy_screen.dart';
import 'package:staff_view_ui/pages/scan/scan-check/scan_check_screen.dart';
import 'package:staff_view_ui/pages/scan/scan_screen.dart';
import 'package:staff_view_ui/pages/working/working_screen.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/translation.dart';
import 'package:staff_view_ui/auth/login.dart';
import 'package:staff_view_ui/pages/profile/profile_screen.dart';
import 'package:staff_view_ui/app_setting.dart';

Future<void> main() async {
  await GetStorage.init();
  await AppSetting().initSetting();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/menu',
      supportedLocales: const [
        Locale("en", "US"),
        Locale("km", "KH"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale("kh", "KH"),
      translations: Translate(),
      fallbackLocale: const Locale("en", "US"),
      theme: AppTheme.lightTheme,
      getPages: [
        GetPage(name: '/menu', page: () => const MenuScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/delegate', page: () => DelegateScreen()),
        GetPage(name: '/absent_exception', page: () => AbsentExceptionScreen()),
        GetPage(name: '/document', page: () => DocumentScreen()),
        GetPage(name: '/exception', page: () => ExceptionScreen()),
        GetPage(name: '/leave', page: () => LeaveScreen()),
        GetPage(name: '/overtime', page: () => OvertimeScreen()),
        GetPage(name: '/working', page: () => WorkingScreen()),
        GetPage(name: '/scan-attendance', page: () => ScanScreen()),
        GetPage(name: '/check', page: () => ScanCheckScreen()),
        GetPage(name: '/privacy-policy', page: () => PrivacyPolicyScreen()),
        GetPage(name: '/change-password', page: () => ChangePassword()),
      ],
    ),
  );
}
