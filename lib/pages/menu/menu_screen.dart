import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/version_server.dart';
import 'package:staff_view_ui/pages/menu/menu_controller.dart';
import 'package:staff_view_ui/pages/profile/profile_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  final profileController = Get.put(ProfileController());
  final menuController = Get.put(MenusController());
  @override
  Widget build(BuildContext context) {
    var menuItems = menuController.menuItems;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the drawer menu icon
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/notification');
            },
            icon: const Icon(CupertinoIcons.bell, color: Colors.white),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [
                  AppTheme.menuColor,
                  Colors.white,
                ],
                center: Alignment.center,
                radius: 0.7,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Apply border radius
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Obx(
                    () => GridView.builder(
                      shrinkWrap: true, // Make GridView height flexible
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 1.5, // Control width-to-height ratio
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(menuItems[index]['route'] as String);
                          },
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Icon(
                                        menuItems[index]['icon'] as IconData,
                                        color: AppTheme.menuColor,
                                        size: 48,
                                      ),
                                      if (menuItems[index]['badge'] != 0)
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: AppTheme.dangerColor,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: FittedBox(
                                              child: Obx(
                                                () => Text(
                                                  menuItems[index]['badge']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    textAlign: TextAlign.center,
                                    (menuItems[index]['title'] as String).tr,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamilyFallback: [
                                          'Gilroy',
                                          'Kantumruy'
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static Route<void> modalBuilder(BuildContext context, Object? arguments) {
    final controller = Get.put(MenusController());
    return CupertinoModalPopupRoute<void>(
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('Update Available'.tr,
                style: const TextStyle(
                    fontFamilyFallback: ['Gilroy', 'Kantumruy'], fontSize: 16)),
          ),
          message: FutureBuilder<String?>(
            future: AppVersion.getAppVersion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Text('Error retrieving version');
              }
              switch (defaultTargetPlatform) {
                case TargetPlatform.android:
                  return Obx(
                    () => Text(
                      '${'NewVersion'.tr} ${controller.androidVersion.value} ${'is available in'.tr} Play Store${'.'.tr}',
                      style: const TextStyle(
                        fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                      ),
                    ),
                  );
                case TargetPlatform.iOS:
                  return Obx(
                    () => Text(
                      '${'NewVersion'.tr} ${controller.iosVersion.value} ${'is available in'.tr} App Store${'.'.tr}',
                      style: const TextStyle(
                        fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                      ),
                    ),
                  );
                default:
                  return Text('${'New Version'.tr}: ${snapshot.data}');
              }
            },
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: Text('Later'.tr,
                  style: const TextStyle(
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'])),
              onPressed: () {
                Get.back();
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Update Now'.tr,
                  style: const TextStyle(
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'])),
              onPressed: () {
                switch (defaultTargetPlatform) {
                  case TargetPlatform.android:
                    launchUrl(Uri.parse(controller.androidLink.value));
                  case TargetPlatform.iOS:
                    launchUrl(Uri.parse(controller.iosLink.value));
                  default:
                    launchUrl(Uri.parse(controller.androidLink.value));
                }
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
