import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/firebase_service.dart';
import 'package:staff_view_ui/models/notification_model.dart';
import 'package:staff_view_ui/pages/notification/notification_service.dart';

class NotificationController extends GetxController {
  RxBool loading = false.obs;

  RxList<NotificationModel> list = <NotificationModel>[].obs;
  final service = NotificationService();

  int currentPage = 1;
  final int pageSize = 20;
  final RxBool hasMore = true.obs;
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

  Future<void> search() async {
    loading.value = true;
    list.value = [];
    var filter = [];
    String? firebaseToken = await FirebaseService.fbService.getToken();
    if (firebaseToken != null) {
      filter
          .add({'field': 'deviceId', 'operator': 'eq', 'value': firebaseToken});
    }
    try {
      var response = await service.search(queryParameters: {
        'pageIndex': currentPage,
        'pageSize': pageSize,
        'filters': jsonEncode(filter)
      });

      if (response.isNotEmpty) {
        list.addAll(response);
        print(list);
        hasMore.value = response.length == pageSize;
      } else {
        hasMore.value = false;
      }
      loading.value = false;
    } catch (e) {
      print(e);
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> markRead(int id) async {
    try {
      await service.markRead(id);
      await search();
    } catch (e) {
      print(e);
    }
  }

  Future<void> markAllRead() async {
    await service.markAllRead();
    await search();
  }
}
