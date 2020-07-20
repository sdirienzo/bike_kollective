import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseManager {
  Stream<QuerySnapshot> getAllAvailableBikes() {
    return Firestore.instance
        .collection('bikes')
        .where('checkedOut', isEqualTo: false)
        .snapshots();
  }

  Future<DocumentSnapshot> getBike(String documentID) async {
    return Firestore.instance.document('bikes/$documentID').get();
  }
}
