import 'package:get/get.dart';
import 'package:staff_view_ui/auth/forgot_password/forgot_password_screen.dart';
import 'package:staff_view_ui/auth/input_new_password/input_new_password_screen.dart';
import 'package:staff_view_ui/auth/login.dart';
import 'package:staff_view_ui/auth/verify-mfa/verify_mfa_screen.dart';
import 'package:staff_view_ui/auth/verify_otp/verify_otp_screen.dart';
import 'package:staff_view_ui/pages/change_password/change_password.dart';
import 'package:staff_view_ui/pages/edit_profile/edit_profile.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_screen.dart'; 
import 'package:staff_view_ui/pages/notification/notification_screen.dart'; 
import 'package:staff_view_ui/pages/privacy_policy/privacy_policy_screen.dart';
import 'package:staff_view_ui/pages/request_log/request_log_screen.dart'; 
import 'package:staff_view_ui/pages/task/task_screen.dart'; 

class Routes {
  static final List<GetPage> pages = [
    GetPage(name: RouteName.houseKeeping, page: () => HousekeepingScreen()),
    GetPage(name: RouteName.task, page: () => TaskScreen()),
    GetPage(name: RouteName.requestLog, page: () => RequestLogScreen()),  
    GetPage(name: RouteName.login, page: () => LoginScreen()), 
    GetPage(name: RouteName.privacyPolicy, page: () => PrivacyPolicyScreen()),
    GetPage(name: RouteName.changePassword, page: () => ChangePassword()),
    GetPage(name: RouteName.editUser, page: () => EditUser()),
    GetPage(name: RouteName.notification, page: () => NotificationScreen()),
    GetPage(name: RouteName.forgetPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: RouteName.verifyOtp, page: () => VerifyOtpScreen()),
    GetPage(name: RouteName.verifyMfa, page: () => VerifyMfaScreen()),
    GetPage(name: RouteName.inputNewPassword, page: () => InputNewPasswordScreen()),
 
  ];
}
class RouteName {
  static const String menu = '/menu';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String task = '/task';
  static const String absentException = '/absent_exception';
  static const String privacyPolicy = '/privacy-policy';
  static const String changePassword = '/change-password';
  static const String editUser = '/edit-user';
  static const String notification = '/notification';
  static const String forgetPassword = '/forget-password';
  static const String verifyOtp = '/verify-otp';
  static const String verifyMfa = '/verify-mfa';
  static const String inputNewPassword = '/input-new-password';
  static const String houseKeeping = '/house-keeping';
  static const String requestLog = '/request-log'; 


}
