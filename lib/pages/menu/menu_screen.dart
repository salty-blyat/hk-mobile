import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/profile/profile_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/drawer.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const menuItems = [
      {
        'title': 'My Profile',
        'icon': CupertinoIcons.person,
        'route': '/profile',
      },
      {
        'title': 'Scan Attendance',
        'icon': CupertinoIcons.qrcode_viewfinder,
        'route': '/scan-attendance',
      },
      {
        'title': 'Working',
        'icon': CupertinoIcons.calendar,
        'route': '/working',
      },
      {
        'title': 'Leave Request',
        'icon': CupertinoIcons.calendar_circle,
        'route': '/leave',
      },
      {
        'title': 'Overtime Request',
        'icon': CupertinoIcons.clock,
        'route': '/overtime',
      },
      {
        'title': 'Absent Exception Request',
        'icon': CupertinoIcons.refresh_circled,
        'route': '/absent_exception',
      },
      {
        'title': 'Exception',
        'icon': CupertinoIcons.refresh_circled,
        'route': '/exception',
      },
      {
        'title': 'Request/Approve',
        'icon': CupertinoIcons.doc_plaintext,
        'route': '/request-approval',
      },
      {
        'title': 'Delegate',
        'icon': CupertinoIcons.person_2,
        'route': '/delegate',
      },
      {
        'title': 'Document',
        'icon': CupertinoIcons.doc_plaintext,
        'route': '/document',
      },
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the drawer menu icon
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {},
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
                  return GridView.builder(
                    shrinkWrap: true, // Make GridView height flexible
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.5, // Control width-to-height ratio
                    ),
                    itemCount: 10,
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
                                Icon(
                                  menuItems[index]['icon'] as IconData,
                                  color: AppTheme.menuColor,
                                  size: 48,
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
