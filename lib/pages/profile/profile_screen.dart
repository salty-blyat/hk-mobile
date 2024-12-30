import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/profile/profile_controller.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    const placeHolder = '--------------------------------';
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'.tr),
      ),
      body: Obx(
        () => (controller.loading.value != true &&
                controller.user.value.id == null)
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_circle,
                        size: 42, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('No Data'),
                  ],
                ),
              )
            : Skeletonizer(
                enabled: controller.loading.value,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: controller.user.value.photo?.isNotEmpty ??
                                      false
                                  ? Image.network(
                                      controller.user.value.photo ?? '',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/man.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.user.value.name ?? placeHolder,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.user.value.latinName ?? placeHolder,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.user.value.phone ??
                                    controller.user.value.email ??
                                    placeHolder,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Description(
                        icon: CupertinoIcons.location_solid,
                        value: controller.user.value.address ?? placeHolder),
                    const SizedBox(height: 8),
                    Description(
                        icon: CupertinoIcons.arrow_branch,
                        value: controller.user.value.branchName ?? placeHolder),
                    const SizedBox(height: 8),
                    Description(
                        icon: CupertinoIcons.building_2_fill,
                        value: controller.user.value.pathName ?? placeHolder),
                    const SizedBox(height: 8),
                    Description(
                        icon: CupertinoIcons.location_fill,
                        value:
                            controller.user.value.positionName ?? placeHolder),
                    const SizedBox(height: 8),
                    Description(
                        icon: Icons.calendar_month,
                        value:
                            '${convertToKhmerDate(controller.user.value.joinDate ?? DateTime.now())} (${convertToKhmerTimeAgo(controller.user.value.joinDate ?? DateTime.now(), Get.locale?.languageCode ?? 'kh')})'),
                    const SizedBox(height: 24),
                    Text(
                      'Download'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DownloadButton(
                        text: 'Staff Profile',
                        reportName: 'StaffProfileReport',
                        controller: controller),
                    const SizedBox(height: 8),
                    DownloadButton(
                        text: 'Staff Work Declaration',
                        reportName: 'StaffWorkDeclarationReport',
                        controller: controller),
                    const SizedBox(height: 8),
                    DownloadButton(
                      text: 'Staff Work Certificate',
                      reportName: 'StaffWorkCertificateReport',
                      controller: controller,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  final String text;
  final String reportName;
  final ProfileController controller;
  const DownloadButton({
    super.key,
    required this.text,
    required this.reportName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.downloadReport(reportName, text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.isDownloading.value &&
                  controller.downloading.value == text)
                Container(
                  height: 32,
                  width: 32,
                  padding: const EdgeInsets.all(4),
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        value: controller.downloadProgress.value,
                      ),
                      Center(
                        child: Text(
                          '${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Icon(
                  CupertinoIcons.arrow_down_circle,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Download'.tr,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text.tr,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class Description extends StatelessWidget {
  final IconData icon;
  final String value;
  const Description({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(width: 8),
        Flexible(child: Text(value)),
      ],
    );
  }
}
