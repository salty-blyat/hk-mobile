import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/firebase_service.dart';
import 'package:staff_view_ui/helpers/notification_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/translation.dart';
import 'package:staff_view_ui/app_setting.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await AppSetting().initSetting();
  await Firebase.initializeApp();
  await ShowNotificationService.initialize();
  final Translate translationService = Translate();
  await translationService.loadTranslations();
  NotificationService.initialize();
  var initialRoute = '/login';

  try {
    var storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');
    initialRoute = token != null ? RouteName.menu : RouteName.login;
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
              getPages: Routes.pages,
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
