import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenArguments {
  final String userID, documentID, rideID;
  final DocumentSnapshot bikeDB;

  ScreenArguments({this.userID, this.bikeDB, this.documentID, this.rideID});
}
