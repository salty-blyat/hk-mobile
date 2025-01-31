import 'package:get/get.dart';
import 'package:staff_view_ui/auth/forgot_password/forgot_password_screen.dart';
import 'package:staff_view_ui/auth/input_new_password/input_new_password_screen.dart';
import 'package:staff_view_ui/auth/login.dart';
import 'package:staff_view_ui/auth/verify-mfa/verify_mfa_screen.dart';
import 'package:staff_view_ui/auth/verify_otp/verify_otp_screen.dart';
import 'package:staff_view_ui/pages/change_password/change_password.dart';
import 'package:staff_view_ui/pages/edit_profile/edit_profile.dart';
import 'package:staff_view_ui/pages/exception/operation/exception_operation_screen.dart';
import 'package:staff_view_ui/pages/menu/menu_screen.dart';
import 'package:staff_view_ui/pages/notification/notification_screen.dart';
import 'package:staff_view_ui/pages/profile/profile_screen.dart';
import 'package:staff_view_ui/pages/delegate/delegate_screen.dart';
import 'package:staff_view_ui/pages/absent_exception/absent_exception_screen.dart';
import 'package:staff_view_ui/pages/document/document_screen.dart';
import 'package:staff_view_ui/pages/exception/exception_screen.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/pages/overtime/overtime_screen.dart';
import 'package:staff_view_ui/pages/request/history/request_history_screen.dart';
import 'package:staff_view_ui/pages/request/request_screen.dart';
import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';
import 'package:staff_view_ui/pages/scan/scan-check/scan_check_screen.dart';
import 'package:staff_view_ui/pages/worksheet/history/history_screen.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_screen.dart';
import 'package:staff_view_ui/pages/scan/scan_screen.dart';
import 'package:staff_view_ui/pages/privacy_policy/privacy_policy_screen.dart';

class Routes {
  static final List<GetPage> pages = [
    GetPage(name: '/menu', page: () => MenuScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
    GetPage(name: '/delegate', page: () => DelegateScreen()),
    GetPage(
        name: '/absent_exception', page: () => const AbsentExceptionScreen()),
    GetPage(name: '/document', page: () => DocumentScreen()),
    GetPage(name: '/exception', page: () => ExceptionScreen()),
    GetPage(name: '/leave', page: () => LeaveScreen()),
    GetPage(name: '/overtime', page: () => OvertimeScreen()),
    GetPage(name: '/working', page: () => WorkingScreen()),
    GetPage(name: '/scan-attendance', page: () => ScanScreen()),
    GetPage(name: '/check', page: () => ScanCheckScreen()),
    GetPage(name: '/privacy-policy', page: () => PrivacyPolicyScreen()),
    GetPage(name: '/change-password', page: () => ChangePassword()),
    GetPage(name: '/request-approval', page: () => RequestApproveScreen()),
    GetPage(name: '/edit-user', page: () => EditUser()),
    GetPage(name: '/request-history', page: () => RequestHistoryScreen()),
    GetPage(name: '/request-view', page: () => RequestViewScreen()),
    GetPage(name: '/notification', page: () => NotificationScreen()),
    GetPage(
        name: '/exception-operation', page: () => ExceptionOperationScreen()),
    GetPage(name: '/attendance-record', page: () => HistoryScreen()),
    GetPage(name: '/forget-password', page: () => ForgotPasswordScreen()),
    GetPage(name: '/verify-otp', page: () => VerifyOtpScreen()),
    GetPage(name: '/verify-mfa', page: () => VerifyMfaScreen()),
    GetPage(name: '/input-new-password', page: () => InputNewPasswordScreen()),
  ];
}
