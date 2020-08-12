import 'package:bike_kollective/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  void displayReminderNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'bike_kollective_channel_id',
        'bike_kollective_channel_name',
        'bike_kollective_channel_description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Check-in Bike',
      'It\'s time to end your ride. Failure to do so will result in your account being locked!',
      platformChannelSpecifics,
    );
  }
}
