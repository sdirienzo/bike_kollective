import 'package:workmanager/workmanager.dart';

class BackgroundManager {
  Future<void> registerPeriodicNotifcation(rideId) async {
    Workmanager.registerPeriodicTask(rideId, 'periodicNotification',
        initialDelay: Duration(hours: 24),
        frequency: Duration(hours: 1),
        inputData: <String, dynamic>{'rideId': rideId});
    return;
  }
}
