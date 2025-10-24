import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/pages/notification/notification_service.dart';
import 'package:staff_view_ui/route.dart';

class FirebaseService {
  static final fbService = FirebaseMessaging.instance;
  static final dioClient = DioClient();
  static final storage = Storage();
  static final notificationService = NotificationService();

  Future<void> handlerNotification(RemoteMessage msg) async {
    print('title ${msg.notification?.title}');
    print('body ${msg.notification?.body}');
  }

  static Future<void> initFCM() async {
    await fbService.requestPermission();
    var token = await fbService.getToken();
    print(token);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('onMessage ${jsonEncode(message.data['requestId'])}');
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: ${jsonEncode(message.data)}");
      int requestId = int.parse(message.data['requestId']);
      if (int.parse(message.data['requestId']) != 0) {
        await notificationService.markRead(requestId);
        Get.toNamed(RouteName.requestLog, arguments: {'id': requestId});
      } else {
        Get.toNamed(RouteName.notification);
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(
            "App opened from terminated notification: ${jsonEncode(message.data)}");
      }
    });
  }

  handlePassToken() async {
    try {
      await dioClient.post('staffuserdevice',
          data: {'deviceId': await fbService.getToken()});
    } catch (e) {
      print(e);
    }
  }

  handleRemoveToken() async {
    StaffUserModel staffUser = StaffUserModel.fromJson(
        jsonDecode(storage.read(StorageKeys.staffUser) ?? ''));
    try {
      await dioClient.delete(
          'staffuserdevice/${staffUser.staffId}/public', {'deviceId': await fbService.getToken()});
    } catch (e) {
      print(e);
    }
  }
}
