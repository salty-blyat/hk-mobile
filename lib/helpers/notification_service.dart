import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class ShowNotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'default',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
      const iosPlatformChannelSpecifics = DarwinNotificationDetails();
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );
      await fln.show(id, title, body, platformChannelSpecifics);
    } catch (e) {
      print(e);
    }
  }

  static Future getNotification(String title, String message, onTap) async {
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            border: Border.all(color: Colors.green, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                spreadRadius: 2.0,
                blurRadius: 8.0,
                offset: Offset(2, 4),
              )
            ],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.green),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(message, style: TextStyle(color: Colors.green)),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () => debugPrint("Undid"), child: Text("Undo"))
            ],
          )),
    );
  }
}
