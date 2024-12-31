import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/profile/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService = ProfileService();
  final Rx<Staff> user = Staff().obs;
  final RxBool loading = false.obs;
  final RxString filePath = ''.obs;
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  var downloading = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<Staff> getUser() async {
    loading.value = true;
    try {
      var response = await profileService.getUser();
      user.value = response;
      loading.value = false;
      return response;
    } catch (e) {
      return Staff();
    }
  }

  Future<void> downloadReport(String reportName, String name) async {
    final dio = Dio();
    final response = await profileService.downloadReport(reportName);
    final directory = await getApplicationDocumentsDirectory();
    final path =
        "${directory.path}/${reportName}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    if (response.isNotEmpty) {
      isDownloading.value = true;
      downloading.value = name;
      await dio.download(response, path, onReceiveProgress: (received, total) {
        downloadProgress.value = received / total;
      });
      downloading.value = '';
      isDownloading.value = false;
      Get.to(
        () => Scaffold(
          appBar: AppBar(
            title: Text(name.tr),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: PDFView(filePath: path),
        ),
      );
    }
  }
}
