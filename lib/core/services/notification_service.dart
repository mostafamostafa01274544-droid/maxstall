import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    
    // تم استخدام settings: settings بناء على أخطاء الـ IDE عندك
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {},
    );
  }

  static Future<void> showSuccess(String outputPath) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_done',
        'Conversion Complete',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _plugin.show(
      id: 1,
      title: 'Done!',
      body: 'Saved to $outputPath',
      notificationDetails: details,
    );
  }

  static Future<void> showError(String msg) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_error',
        'Conversion Error',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id: 2,
      title: 'Error',
      body: msg,
      notificationDetails: details,
    );
  }
}
