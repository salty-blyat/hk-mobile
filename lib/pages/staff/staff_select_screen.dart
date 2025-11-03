import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/staff/staff_select_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class StaffSelectScreen extends StatelessWidget {
  StaffSelectScreen({super.key});
  final StaffSelectController controller = Get.put(StaffSelectController());
  Timer? _debounce;

  void dispose() {
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    controller.searchText.value = '';
    controller.getStaff();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(result: controller.selectedStaff.value)),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: AppTheme.borderRadius,
          ),
          child: SearchBar(
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                fontSize: 14,
              ),
            ),
            hintText: 'Search'.tr,
            hintStyle: WidgetStateProperty.all(
              const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamilyFallback: ['Gilroy', 'Kantumruy']),
            ),
            leading: const Icon(Icons.search, size: 18),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                controller.searchText.value = value;
                controller.staff.clear();
                controller.currentPage = 1;

                controller.getStaff();
              });
            },
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.isTrue && controller.staff.isEmpty) {
          return Skeletonizer(
            enabled: controller.loading.isTrue,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('__________________________'),
                      Text('_________________________',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels >=
                    scrollNotification.metrics.maxScrollExtent &&
                !controller.loadingMore.isTrue) {
              controller.loadMoreStaff();
            }
            return false;
          },
          child: ListView.builder(
            itemCount:
                controller.staff.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.staff.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.staff[index].name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(controller.staff[index].positionNameEn ?? '',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                trailing: controller.selectedStaff.value.id ==
                            controller.staff[index].id &&
                        controller.selectedStaff.value.id != 0
                    ? const Icon(Icons.check)
                    : const SizedBox.shrink(),
                onTap: () {
                  controller.selectedStaff.value = controller.staff[index];
                  Get.back(result: controller.staff[index]);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
