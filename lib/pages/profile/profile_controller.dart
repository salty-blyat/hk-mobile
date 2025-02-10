import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/profile/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService = ProfileService();
  final Rx<Staff> user = Staff().obs;
  final RxBool loading = false.obs;
  final RxString filePath = ''.obs;
  final storage = Storage();
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  var downloading = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  void getUser() async {
    loading.value = true;
    try {
      user.value = await profileService.getUser();
      storage.write(Const.staffId, '${user.value.id}');
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> downloadReport(String reportName, String name) async {
    try {
      final dio = Dio();
      final response = await profileService.downloadReport(reportName);
      Directory? directory;

      if (Platform.isAndroid) {
        // if (await _requestStoragePermission()) {
        var tmp = await getExternalStorageDirectory();
        directory = Directory('${tmp?.path.split('/Android').first}/Download');
        // } else {
        //   throw Exception("Storage permission denied");
        // }
      } else if (Platform.isIOS) {
        directory = Directory(
            '${(await getApplicationDocumentsDirectory()).path}/StaffView');
      }

      if (directory == null) {
        throw Exception("Could not find a valid directory");
      }

      final path =
          "${directory.path}/$reportName-${DateTime.now().toString().split(' ').first}.pdf";
      if (response.isNotEmpty) {
        isDownloading.value = true;
        downloading.value = name;
        await dio.download(response, path,
            onReceiveProgress: (received, total) {
          downloadProgress.value = received / total;
        });
        downloading.value = '';
        isDownloading.value = false;
        Get.to(
          () => Scaffold(
            appBar: AppBar(
              title: Text(name.tr),
              actions: [
                IconButton(
                  onPressed: () async {
                    await Share.shareXFiles([XFile(path)]);
                  },
                  icon: const Icon(CupertinoIcons.share),
                ),
              ],
            ),
            body: PDFView(filePath: path),
          ),
        );
      }
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     final status = await Permission.manageExternalStorage.request();
  //     return status.isGranted;
  //   }
  //   return true; // iOS doesn't need permission
  // }
}
