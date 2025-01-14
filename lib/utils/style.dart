import 'dart:ui';

import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/utils/theme.dart';

class Style {
  static const double borderRadius = 10;
  static Color getStatusColor(int status) {
    if (LeaveStatus.approved.value == status) {
      return AppTheme.successColor;
    } else if (LeaveStatus.rejected.value == status) {
      return AppTheme.dangerColor;
    } else if (LeaveStatus.processing.value == status) {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.warningColor;
    }
  }
}
