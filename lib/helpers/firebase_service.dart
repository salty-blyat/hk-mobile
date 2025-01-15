import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class NotificationService {
  static final dioClient = DioClient();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.notification?.title}');
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
  }

  handlePassToken() async {
    try {
      await dioClient.post('user-info/firebase',
          data: {'token': await _firebaseMessaging.getToken()});
    } catch (e) {
      print(e);
    }
  }
}
