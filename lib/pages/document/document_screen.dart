import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/document/document_controller.dart';
import 'package:staff_view_ui/utils/widgets/no_data.dart';

class DocumentScreen extends StatelessWidget {
  DocumentScreen({super.key});
  final controller = Get.put(DocumentController());
  String get title => 'Document'.tr;
  bool get isLoading => controller.loading.value;
  bool get isLoadingMore => controller.canLoadMore.value;
  bool get fabButton => false;
  bool get showHeader => false;
  void onFabPressed() {}
  Future<void> onRefresh() async {
    await controller.search();
  }

  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  bool get canLoadMore => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.tr,
          style: context.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.lists.isEmpty) {
          return const NoData();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.lists.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Obx(
                () => DownloadButton(
                  text: controller.lists[index].title ?? '',
                  controller: controller,
                  link: controller.lists[index].attachment?.url ?? '',
                  size: controller.lists[index].size ?? '0 B',
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget headerWidget() => const SizedBox.shrink();
}

class DownloadButton extends StatelessWidget {
  final String text;
  final DocumentController controller;
  final String link;
  final String? size;
  const DownloadButton({
    super.key,
    required this.text,
    required this.controller,
    required this.link,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.download(link, text);
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
                          controller.downloadProgress.value.toStringAsFixed(0),
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
                    text.tr,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    if (controller.loading.value) {
                      return Skeletonizer(
                        enabled: true,
                        child: Text(
                          '0 B',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      );
                    }
                    return Text(
                      size ?? '0 B',
                      style: TextStyle(color: Colors.grey.shade700),
                    );
                  }),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
