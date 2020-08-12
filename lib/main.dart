import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:bike_kollective/services/database_manager.dart';
import 'package:bike_kollective/services/authentication_manager.dart';
import 'app/app.dart';

void callbackDispatcher() {
  DatabaseManager _db = DatabaseManager();
  AuthenticationManager _auth = AuthenticationManager();

  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'periodicNotification':
        print('$taskName was executed with inputData: $inputData');
        var ride = await _db.getActiveRide(inputData['rideId']);
        var userId = ride['userId'];
        var startTime = ride['startTime'].toDate();
        var endTime = ride['endTime'] == null ? null : ride['endTime'].toDate();
        var timeCheckedOut = DateTime.now().difference(startTime).inMinutes;
        print(userId);
        print(startTime);
        print(endTime);
        print(timeCheckedOut);
        if (endTime == null) {
          if (timeCheckedOut >= 0) {
            print('LOCKOUT');
            var endTime = DateTime.now();
            await _db.endActiveRide(ride.documentID, endTime);
            await _db.removeUserActiveRide(userId);
            await _db.lockoutUser(userId);
            await _auth.signOut();
            Workmanager.cancelAll();
          } else {
            print('NOTIFICATION');
          }
        } else {
          print('CHECKED IN');
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

  runApp(MyApp());
}
