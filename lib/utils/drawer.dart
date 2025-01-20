import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/helpers/version_server.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final DrawerController drawerController = Get.put(DrawerController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(drawerController.auth.value?.fullName ?? '',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(drawerController.auth.value?.phone ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
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
                      borderRadius: BorderRadius.circular(4),
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
                      borderRadius: BorderRadius.circular(4),
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(CupertinoIcons.textformat,
                        color: Colors.black87),
                  ),
                  title: Text('Language'.tr),
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: Column(
                            children: [
                              // Header Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    iconSize: 16,
                                    onPressed: () {},
                                    icon: const Icon(
                                      CupertinoIcons.clear,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    'Choose Language'.tr,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  IconButton(
                                    iconSize: 16,
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                    },
                                    icon: const Icon(CupertinoIcons.clear),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Scrollable ListView
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  padding: const EdgeInsets.all(16),
                                  itemCount: Const
                                      .languages.length, // Handle null safely
                                  itemBuilder: (context, index) {
                                    final language = Const.languages[index];
                                    final isSelected =
                                        Get.locale?.languageCode ==
                                            language['code'];
                                    return ListTile(
                                      selected: isSelected,
                                      selectedColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      trailing: Icon(
                                          CupertinoIcons.checkmark_circle,
                                          size: 20,
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : Colors.transparent),
                                      title: Text(language['label'] ??
                                          'Unknown'), // Handle null safely
                                      leading: Image.asset(
                                        language['image'] ??
                                            'assets/default.png', // Fallback image
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.cover,
                                      ),
                                      onTap: () async {
                                        // Handle language selection
                                        if (language['key'] != null) {
                                          var box = Storage();
                                          box.write(Const.authorized['Lang']!,
                                              language['code']);
                                          Get.updateLocale(language['key']);
                                          Get.back();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(CupertinoIcons.checkmark_shield,
                        color: Colors.black87),
                  ),
                  title: Text('Privacy Policy'.tr),
                  onTap: () {
                    Get.toNamed('/privacy-policy'); // Navigate to Profile
                  },
                ),
                const Divider(color: Color.fromARGB(255, 210, 210, 210)),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(CupertinoIcons.arrow_left_square,
                        color: Colors.black87),
                  ),
                  title: Text('Logout'.tr),
                  onTap: () {
                    authController.logout();
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              Modal.showSettingDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: AppVersion.getAppVersion(),
                builder: (context, snapshot) {
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

class DrawerController extends GetxController {
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
      // Replace with default constructor or handle null case
    } catch (e) {
      print('Error during initialization: $e');
    }
  }
}
