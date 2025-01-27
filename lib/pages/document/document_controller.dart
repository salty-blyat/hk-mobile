import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/file_service.dart';
import 'package:staff_view_ui/models/document_model.dart';
import 'package:staff_view_ui/pages/document/document_service.dart';

class DocumentController extends GetxController {
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final service = DocumentService();
  final formValid = false.obs;
  final lists = <DocumentModel>[].obs;
  final canLoadMore = false.obs;
  final isDownloading = false.obs;
  final downloading = ''.obs;
  final downloadProgress = 0.0.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: '',
    filters: '[]',
  ).obs;
  @override
  void onInit() {
    search();
    super.onInit();
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value) return;

    isLoadingMore.value = true;
    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      final response = await service.search(queryParameters.value);
      lists.addAll(response.results as Iterable<DocumentModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search() async {
    loading.value = true;
    try {
      final response = await service.search(queryParameters.value);
      lists.assignAll(response.results as Iterable<DocumentModel>);
      lists.forEach((e) async {
        e.size = await getContentLength(e.attachment?.url ?? '');
        lists.refresh();
      });
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      if (kDebugMode) {
        print("Error during search: $e");
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> download(String link, String text) async {
    isDownloading.value = true;
    downloading.value = text;
    await downloadAndOpenFile(link, text, (value) {
      downloadProgress.value = value;
    });
    downloading.value = '';
    isDownloading.value = false;
  }

  Future<String> getContentLength(String url) async {
    final response = await service.getContentLength(url);
    return formatBytes(response);
  }

  String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }
}
