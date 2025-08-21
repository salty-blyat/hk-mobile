import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/notification_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
// import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin fln =
      FlutterLocalNotificationsPlugin();
  static final dioClient = DioClient();
  final storage = Storage();
  static Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {}

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          jsonDecode(message.data['Data'])['requestId'].toString());
    });

    // Handle background messages
    // FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _messageClickHandler(message);
    });
  }

  // static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  //   await showNotification(
  //       message.notification?.title ?? '',
  //       message.notification?.body ?? '',
  //       jsonDecode(message.data['Data'])['requestId'].toString());
  // }

  static showNotification(String title, String body, String payload) {
    ShowNotificationService.showInstantNotification(title, body, payload);
  }

  static Future<void> _messageClickHandler(RemoteMessage message) async {
    // int? requestId = jsonDecode(message.data['Data'])['requestId'];
    // Get.to(() => RequestViewScreen(),
    //     arguments: {'id': requestId, 'reqType': 0});
  }

  handlePassToken() async {
    try {
      await dioClient.post('user-info/firebase',
          data: {'token': await _firebaseMessaging.getToken()});
    } catch (e) {
      print(e);
    }
  }

  handleRemoveToken() async {
    try {
      return await dioClient.delete('user-info/firebase', {
        'token': await _firebaseMessaging.getToken(),
        'id': storage.read(Const.staffId),
      });
    } catch (e) {
      print(e);
    }
  }
}
