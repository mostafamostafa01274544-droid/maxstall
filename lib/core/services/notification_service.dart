import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> showSuccess(String outputPath) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_done',
        'Conversion Complete',
        channelDescription: 'Notifies when video conversion finishes',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );
    await _plugin.show(
      1,
      '✅ Conversion Done!',
      'Saved to $outputPath',
      details,
    );
  }

  static Future<void> showError(String msg) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'yj_error',
        'Conversion Error',
        channelDescription: 'Notifies when conversion fails',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(2, '❌ Conversion Failed', msg, details);
  }
}
