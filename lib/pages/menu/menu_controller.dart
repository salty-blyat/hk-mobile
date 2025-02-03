import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      'isShow': true,
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
    menuItems.value =
        menuItems.where((element) => element['isShow'] == true).toList();
    totalRequest.value = await menuService.getTotal();
    menuItems.firstWhere(
            (element) => element['route'] == '/request-approval')['badge'] =
        totalRequest.value;
    menuItems.refresh();
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
    getSetting();
  }

  Future<void> getSetting() async {
    final setting = await menuService.getSetting();
    for (var element in setting) {
      this.setting.add(element);
    }
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
