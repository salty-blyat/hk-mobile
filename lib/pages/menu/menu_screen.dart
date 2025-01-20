import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/menu/menu_controller.dart';
import 'package:staff_view_ui/pages/profile/profile_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/drawer.dart';

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
}
