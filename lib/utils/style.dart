import 'dart:ui';

import 'package:flutter/widgets.dart';

// import 'package:staff_view_ui/pages/delegate/delegate_screen.dart';
// import 'package:staff_view_ui/pages/leave/leave_controller.dart';
// import 'package:staff_view_ui/utils/theme.dart';

class Style {
  static const double borderRadius = 10;
  static Color getLookupTextColor(String? hexColor) {
    if (hexColor == null) {
      return const Color.fromARGB(255, 8, 8, 8);
    }
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }
 
  static Color getLookupColor(String? hexColor) {
    if (hexColor == null) {
      return const Color.fromARGB(255, 8, 8, 8);
    }

    final base = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    final hsl = HSLColor.fromColor(base);

    return hsl.withLightness((hsl.lightness + 0.35).clamp(0.0, 9.0)).toColor();
  }

   
  // static Color getHousekeepingColor(String? hexColor) {
  //   if (hexColor == null) {
  //     return const Color.fromARGB(255, 8, 8, 8);
  //   }

  //   final base = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  //   final hsl = HSLColor.fromColor(base);

  //   return hsl.withLightness((hsl.lightness + 0.35).clamp(0.0, 9.0)).toColor();
  // }

  
}
