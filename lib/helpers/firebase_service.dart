import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/notification_service.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin fln =
      FlutterLocalNotificationsPlugin();
  static final dioClient = DioClient();
  final storage = Storage();
  static Future<void> initialize() async {
    FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
    await fln.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {}
    await _firebaseMessaging.getAPNSToken();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Get.snackbar(
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        backgroundColor: Colors.grey.shade100,
        colorText: Colors.black,
        onTap: (details) {
          _messageClickHandler(message);
        },
      );
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('CLICKED');
      _messageClickHandler(message);
    });
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('BACKGROUND');
    ShowNotificationService.showNotification(
      id: message.notification?.hashCode ?? 0,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      fln: fln,
    );
  }

  static Future<void> _messageClickHandler(RemoteMessage message) async {
    int? requestId = jsonDecode(message.data['Data'])['requestId'];
    Get.to(() => RequestViewScreen(),
        arguments: {'id': requestId, 'reqType': 0});
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
