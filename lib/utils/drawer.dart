import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/helpers/version_server.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/pages/app-info/app_info_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final DrawerGetController drawerController = Get.put(DrawerGetController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: drawerController.auth.value?.profile?.isNotEmpty ==
                              true
                          ? CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  drawerController.auth.value!.profile!,
                                  fit: BoxFit.cover,
                                  height: 64,
                                  width: 64,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor:
                                  AppTheme.primaryColor.withOpacity(0.7),
                              child: Text(
                                drawerController.auth.value?.fullName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 270,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                                drawerController.auth.value?.fullName ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ), 
                          const SizedBox(height: 5),
                          Text(drawerController.auth.value?.phone ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: AppTheme.borderRadius,
                    ),
                    child: const Icon(CupertinoIcons.create,
                        color: Colors.black87),
                  ),
                  title: Text('Edit User'.tr),
                  onTap: () {
                    Get.toNamed('/edit-user'); // Navigate to Home
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: AppTheme.borderRadius,
                    ),
                    child:
                        const Icon(CupertinoIcons.lock, color: Colors.black87),
                  ),
                  title: Text('Change Password'.tr),
                  onTap: () {
                    Get.toNamed('/change-password'); // Navigate to Settings
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: AppTheme.borderRadius,
                    ),
                    child:
                        const Icon(CupertinoIcons.globe, color: Colors.black87),
                  ),
                  title: Text('Language'.tr),
                  onTap: () => Modal.showLanguageDialog(),
                ),
                  const Divider(color: Color.fromARGB(255, 210, 210, 210)),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: AppTheme.borderRadius,
                      ),
                      child: const Icon(CupertinoIcons.arrow_left_square,
                          color: Colors.black87),
                    ),
                    title: Text('Logout'.tr),
                    onTap: () {
                      Navigator.of(context).pop();
                      Modal.showLogoutDialog();
                    },
                  ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              var res = await Modal.showSettingDialog();
              if (res == null) {
                Get.delete<AppInfoController>();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:16),
              child: FutureBuilder(
                future: AppVersion.getAppVersion(),
                builder: (context, snapshot) {
                  print(snapshot);
                  return Text(
                      '${'Version'.tr} ${snapshot.data ?? '...'} (${Const.date})',
                      style: const TextStyle(fontSize: 12));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerGetController extends GetxController {
  final AuthService authService = AuthService();
  Rx<ClientInfo?> auth = Rxn<ClientInfo>();
  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      final authData = await authService
          .readFromLocalStorage(Const.authorized['Authorized']!);
      auth.value = authData != null && authData.isNotEmpty
          ? ClientInfo.fromJson(jsonDecode(authData))
          : ClientInfo();
    } catch (e) {
      print('Error during initialization: $e');
    }
  }
}
