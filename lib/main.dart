import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bike_kollective/services/database_manager.dart';
import 'package:bike_kollective/services/authentication_manager.dart';
import 'package:bike_kollective/services/notification_manager.dart';
import 'package:bike_kollective/app/app_strings.dart';
import 'app/app.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  DatabaseManager _db = DatabaseManager();
  AuthenticationManager _auth = AuthenticationManager();
  NotificationManager _notif = NotificationManager();

  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'periodicNotification':
        var ride = await _db.getActiveRide(inputData['rideId']);
        var userId = ride['${AppStrings.rideUserIdKey}'];
        var startTime = ride['${AppStrings.rideStartTimeKey}'].toDate();
        var endTime = ride['${AppStrings.rideEndTimeKey}'] == null
            ? null
            : ride['${AppStrings.rideEndTimeKey}'].toDate();
        var timeCheckedOut = DateTime.now().difference(startTime).inHours;
        if (endTime == null) {
          if (timeCheckedOut >= 48) {
            var endTime = DateTime.now();
            await _db.endActiveRide(ride.documentID, endTime);
            await _db.removeUserActiveRide(userId);
            await _db.lockoutUser(userId);
            await _auth.signOut();
            Workmanager.cancelAll();
            exit(0);
          } else {
            _notif.displayReminderNotification();
          }
        } else {
          Workmanager.cancelAll();
        }
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = IOSInitializationSettings(
  //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings =
      InitializationSettings(initializationSettingsAndroid, null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}
