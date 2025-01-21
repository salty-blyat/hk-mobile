import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/notification_model.dart';
import 'package:staff_view_ui/pages/notification/notification_service.dart';

class NotificationController extends GetxController {
  final scrollController = ScrollController();
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final service = NotificationService();
  final formValid = false.obs;
  final lists = <NotificationModel>[].obs;
  final year = DateTime.now().year.obs;
  final canLoadMore = false.obs;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'createdDate-',
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
      final response = await service.search(
          queryParameters.value, NotificationModel.fromJson);
      lists.addAll(response.results as Iterable<NotificationModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search() async {
    loading.value = true;

    // queryParameters.update((params) {
    //   final rangeDate = '${year.value}-01-01~${year.value}-12-31';
    //   params?.filters = jsonEncode([
    //     {'field': 'createdDate', 'operator': 'contains', 'value': rangeDate},
    //   ]);
    // });

    try {
      final response = await service.search(
          queryParameters.value, NotificationModel.fromJson);
      lists.assignAll(response.results as Iterable<NotificationModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }

  viewNotification(NotificationModel item) async {
    try {
      var model = {
        'id': item.id,
        'isView': true,
        'createdDate': item.createdDate!.toIso8601String(),
        'message': item.message,
        'title': item.title,
        'requestId': item.requestId,
        'staffId': item.staffId,
        'viewDate': DateTime.now().toIso8601String(),
      };
      queryParameters.update((params) {
        params?.pageIndex = 1;
      });
      await service.edit(
          NotificationModel.fromJson(model), NotificationModel.fromJson);
      Get.toNamed('/request-view', arguments: {
        'id': item.requestId,
        'reqType': 0,
      });
    } catch (e) {
      print("Error during viewNotification: $e");
    } finally {
      search();
    }
  }
}
