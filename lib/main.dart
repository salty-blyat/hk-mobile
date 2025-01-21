import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:staff_view_ui/auth/change_password/change_password.dart';
import 'package:staff_view_ui/auth/edit_profile/edit_profile.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/firebase_service.dart';
import 'package:staff_view_ui/helpers/notification_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/pages/absent_exception/absent_exception_screen.dart';
import 'package:staff_view_ui/pages/delegate/delegate_screen.dart';
import 'package:staff_view_ui/pages/document/document_screen.dart';
import 'package:staff_view_ui/pages/exception/exception_screen.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/pages/menu/menu_screen.dart';
import 'package:staff_view_ui/pages/notification/notification_screen.dart';
import 'package:staff_view_ui/pages/overtime/overtime_screen.dart';
import 'package:staff_view_ui/pages/privacy_policy/privacy_policy_screen.dart';
import 'package:staff_view_ui/pages/request/history/request_history_screen.dart';
import 'package:staff_view_ui/pages/request/request_screen.dart';
import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';
import 'package:staff_view_ui/pages/scan/scan-check/scan_check_screen.dart';
import 'package:staff_view_ui/pages/scan/scan_screen.dart';
import 'package:staff_view_ui/pages/working/working_screen.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/translation.dart';
import 'package:staff_view_ui/auth/login.dart';
import 'package:staff_view_ui/pages/profile/profile_screen.dart';
import 'package:staff_view_ui/app_setting.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ShowNotificationService.initialize();
  await GetStorage.init();
  final Translate translationService = Translate();
  await translationService.loadTranslations();
  NotificationService.initialize();
  await AppSetting().initSetting();
  var initialRoute = '/login';

  try {
    var storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');
    initialRoute = token != null ? '/menu' : '/login';
  } catch (e) {
    if (kDebugMode) {
      print('Error reading token: $e');
    }
  }

  runApp(MyApp(
      translationService: translationService, initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Translate translationService;
  final String initialRoute;
  const MyApp(
      {super.key,
      required this.translationService,
      required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    var box = Storage();
    var lang = 'km';
    try {
      lang = box.read(Const.authorized['Lang'] ?? 'km')!;
    } catch (e) {
      lang = 'km';
    }
    var pickLang = const Locale("km", "KH");
    if (lang == 'km') {
      pickLang = const Locale("km", "KH");
    } else {
      pickLang = const Locale("en", "US");
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              initialRoute: initialRoute,
              supportedLocales: const [
                Locale("en", "US"), // English (United States)
                Locale("km", "KH"), // Khmer (Cambodia)
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: pickLang, // Default locale set to Khmer
              translations: translationService, // Custom translation class
              fallbackLocale: const Locale("en", "US"), // Fallback to English
              theme: AppTheme.lightTheme, // Custom app theme
              getPages: [
                GetPage(name: '/menu', page: () => MenuScreen()),
                GetPage(name: '/login', page: () => LoginScreen()),
                GetPage(name: '/profile', page: () => ProfileScreen()),
                GetPage(name: '/delegate', page: () => DelegateScreen()),
                GetPage(
                    name: '/absent_exception',
                    page: () => const AbsentExceptionScreen()),
                GetPage(name: '/document', page: () => const DocumentScreen()),
                GetPage(
                    name: '/exception', page: () => const ExceptionScreen()),
                GetPage(name: '/leave', page: () => LeaveScreen()),
                GetPage(name: '/overtime', page: () => OvertimeScreen()),
                GetPage(name: '/working', page: () => WorkingScreen()),
                GetPage(name: '/scan-attendance', page: () => ScanScreen()),
                GetPage(name: '/check', page: () => ScanCheckScreen()),
                GetPage(
                    name: '/privacy-policy', page: () => PrivacyPolicyScreen()),
                GetPage(name: '/change-password', page: () => ChangePassword()),
                GetPage(
                    name: '/request-approval',
                    page: () => RequestApproveScreen()),
                GetPage(name: '/edit-user', page: () => EditUser()),
                GetPage(
                    name: '/request-history',
                    page: () => RequestHistoryScreen()),
                GetPage(name: '/request-view', page: () => RequestViewScreen()),
                GetPage(
                    name: '/notification', page: () => NotificationScreen()),
              ],
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler:
                        const TextScaler.linear(1.0), // Fix text scale factor
                  ),
                  child: child!,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
