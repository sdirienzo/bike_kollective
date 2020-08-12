import 'package:workmanager/workmanager.dart';

class BackgroundManager {
  // static void callbackDispatcher() {
  //   Workmanager.executeTask((taskName, inputData) async {
  //     switch (taskName) {
  //       case 'registerPeriodicNotification':
  //         print('$taskName was executed with inputData: $inputData');
  //         Workmanager.cancelAll();
  //     }
  //     return Future.value(true);
  //   });
  // }

  Future<void> registerPeriodicNotifcation(rideId) async {
    Workmanager.registerPeriodicTask(rideId, 'periodicNotification',
        // initialDelay: Duration(minutes: 0),
        frequency: Duration(minutes: 15),
        inputData: <String, dynamic>{'rideId': rideId});
    return;
  }
}
