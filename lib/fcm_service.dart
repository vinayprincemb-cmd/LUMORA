// fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 🔔 Request permission (important for Android 13+)
    await _messaging.requestPermission();

    // 🔥 GET FCM TOKEN
    String? token = await _messaging.getToken();
    print("FCM TOKEN: $token");

    // 📲 Initialize local notifications (for foreground messages)
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _local.initialize(
      const InitializationSettings(android: android),
    );

    // 📥 Handle messages when app is OPEN (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Message";
      final body = message.notification?.body ?? "";

      _local.show(
        999,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fcm_channel',
            'FCM Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}