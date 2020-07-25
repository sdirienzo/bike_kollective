import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bike_kollective/app/app_strings.dart';

class DatabaseManager {
  Future<DocumentReference> addUser(String uid, String email) {
    return Firestore.instance
        .collection('${AppStrings.userCollectionKey}')
        .add({
      '${AppStrings.userIdKey}': uid,
      '${AppStrings.userEmailKey}': email,
      '${AppStrings.userActiveRideKey}': null,
      '${AppStrings.userAccountDisabledKey}': false,
    });
  }

  Stream<QuerySnapshot> getAllAvailableBikes() {
    return Firestore.instance
        .collection('${AppStrings.bikeCollectionKey}')
        .where('${AppStrings.bikeCheckedOutKey}', isEqualTo: false)
        .snapshots();
  }

  Future<DocumentSnapshot> getBike(String documentID) async {
    return Firestore.instance
        .document('${AppStrings.bikeCollectionKey}/$documentID')
        .get();
  }
}
