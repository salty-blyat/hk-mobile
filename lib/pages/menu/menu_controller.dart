import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/version_server.dart';
import 'package:staff_view_ui/models/setting_model.dart';
import 'package:staff_view_ui/pages/menu/menu_screen.dart';
import 'package:staff_view_ui/pages/menu/menu_service.dart';

class MenusController extends GetxController {
  final menuService = MenuService();
  var totalRequest = 0.obs;
  var setting = <SettingModel>[].obs;
  var iosLink = ''.obs;
  var androidLink = ''.obs;
  var iosVersion = '...'.obs;
  var androidVersion = '...'.obs;
  var showLogout = false.obs;
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
      'isShow': true,
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
      'isShow': true,
    },
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    Future.wait([
      getVersion(),
      getSetting(),
    ]);
  }

  Future<void> getVersion() async {
    androidLink.value = (await menuService
                .getSettingPrivate(Const.SETTING_KEY()['AppAndroidUrl'] ?? ''))
            .value ??
        '';
    iosLink.value = (await menuService
                .getSettingPrivate(Const.SETTING_KEY()['AppIosUrl'] ?? ''))
            .value ??
        '';
    iosVersion.value = (await menuService
                .getSettingPrivate(Const.SETTING_KEY()['AppIosVersion'] ?? ''))
            .value ??
        '';
    androidVersion.value = (await menuService.getSettingPrivate(
                Const.SETTING_KEY()['AppAndroidVersion'] ?? ''))
            .value ??
        '';
  }

  Future<void> getSetting() async {
    final setting = await menuService.getSetting();
    final Map<String, int> visibilityMap = {
      Const.SETTING_KEY()['LeaveVisibility']!: 3,
      Const.SETTING_KEY()['OvertimeVisibility']!: 4,
      Const.SETTING_KEY()['AbsentExceptionVisibility']!: 5,
      Const.SETTING_KEY()['ExceptionVisibility']!: 6,
      Const.SETTING_KEY()['ApproveVisibility']!: 7,
      Const.SETTING_KEY()['DelegateVisibility']!: 8,
    };

    for (var element in setting) {
      if (visibilityMap.containsKey(element.key)) {
        final index = visibilityMap[element.key];
        if (index! < menuItems.length) {
          menuItems[index] = {
            ...menuItems[index],
            'isShow': element.value == 'true',
          };
        }
      }
      if (element.key == Const.SETTING_KEY()['LogoutVisibility']) {
        showLogout.value = element.value == 'true';
      }

      this.setting.add(element);
    }
    menuItems.value =
        menuItems.where((element) => element['isShow'] == true).toList();

    totalRequest.value = await menuService.getTotal();
    menuItems.firstWhere(
            (element) => element['route'] == '/request-approval')['badge'] =
        totalRequest.value;
    menuItems.refresh();
  }

  @override
  void onReady() async {
    var version = await AppVersion.getAppVersion();

    super.onReady();
    if (Platform.isAndroid) {
      androidVersion.listen((value) {
        if (value != '...' &&
            double.parse(value) > double.parse(version ?? '0')) {
          Navigator.of(Get.context!).restorablePush(
            MenuScreen.modalBuilder,
          );
        }
      });
    }
    if (Platform.isIOS) {
      iosVersion.listen((value) {
        if (value != '...' &&
            double.parse(value) > double.parse(version ?? '0')) {
          Navigator.of(Get.context!).restorablePush(
            MenuScreen.modalBuilder,
          );
        }
      });
    }
  }
}
