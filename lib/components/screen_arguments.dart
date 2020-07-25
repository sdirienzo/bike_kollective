import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenArguments {
  final String userEmail;
  final DocumentSnapshot bikeDB;
  final String documentID;

  ScreenArguments({this.userEmail, this.bikeDB, this.documentID});
}
