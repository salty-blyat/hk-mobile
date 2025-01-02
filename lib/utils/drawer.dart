import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/const.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final DrawerController drawerController = Get.put(DrawerController());

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
                      child: CircleAvatar(
                        backgroundImage:
                            drawerController.auth.value?.profile?.isNotEmpty ==
                                    true
                                ? NetworkImage(
                                    drawerController.auth.value!.profile ?? '')
                                : AssetImage('assets/images/man.png')
                                    as ImageProvider,
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
                    Get.toNamed('/profile'); // Navigate to Profile
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
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${'Version'.tr} ${Const.version} (${Const.date})',
                style: const TextStyle(fontSize: 12)),
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
          : ClientInfo(); // Replace with default constructor or handle null case
    } catch (e) {
      print('Error during initialization: $e');
    }
  }
}
