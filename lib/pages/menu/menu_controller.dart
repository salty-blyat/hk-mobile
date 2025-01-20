import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/menu/menu_service.dart';

class MenusController extends GetxController {
  final menuService = MenuService();
  var totalRequest = 0.obs;
  var menuItems = [
    {
      'title': 'My Profile',
      'icon': CupertinoIcons.person,
      'route': '/profile',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Scan Attendance',
      'icon': CupertinoIcons.qrcode_viewfinder,
      'route': '/scan-attendance',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Worksheet',
      'icon': CupertinoIcons.calendar,
      'route': '/working',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Leave',
      'icon': CupertinoIcons.calendar_circle,
      'route': '/leave',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Overtime',
      'icon': CupertinoIcons.clock,
      'route': '/overtime',
      'badge': 0,
      'isShow': false,
    },
    {
      'title': 'Absent Exception Request',
      'icon': CupertinoIcons.refresh_circled,
      'route': '/absent_exception',
      'badge': 0,
      'isShow': false,
    },
    {
      'title': 'Exception',
      'icon': CupertinoIcons.refresh_circled,
      'route': '/exception',
      'badge': 0,
      'isShow': false,
    },
    {
      'title': 'Request/Approve',
      'icon': CupertinoIcons.doc_plaintext,
      'route': '/request-approval',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Delegate',
      'icon': CupertinoIcons.person_2,
      'route': '/delegate',
      'badge': 0,
      'isShow': true,
    },
    {
      'title': 'Document',
      'icon': CupertinoIcons.doc_plaintext,
      'route': '/document',
      'badge': 0,
      'isShow': false,
    },
  ].obs;
  @override
  void onInit() async {
    super.onInit();
    menuItems.value =
        menuItems.where((element) => element['isShow'] == true).toList();
    totalRequest.value = await menuService.getTotal();
    menuItems.firstWhere(
            (element) => element['route'] == '/request-approval')['badge'] =
        totalRequest.value;
    menuItems.refresh();
  }
}
