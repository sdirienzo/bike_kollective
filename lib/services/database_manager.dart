import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bike_kollective/app/app_strings.dart';

class DatabaseManager {
  Future<void> addUser(String uid, String email) {
    return Firestore.instance
        .collection('${AppStrings.userCollectionKey}')
        .document(uid)
        .setData({
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

  Future<void> checkOutBike(String documentID) async {
    return Firestore.instance
        .document('${AppStrings.bikeCollectionKey}/$documentID')
        .updateData({'${AppStrings.bikeCheckedOutKey}': true});
  }

  Future<void> checkInBike(String documentID) async {
    return Firestore.instance
        .document('${AppStrings.bikeCollectionKey}/$documentID')
        .updateData({'${AppStrings.bikeCheckedOutKey}': false});
  }

  Future<DocumentReference> startActiveRide(
      String uid, String bikeId, DateTime startTime) {
    return Firestore.instance
        .collection('${AppStrings.rideCollectionKey}')
        .add({
      '${AppStrings.rideUserIdKey}': uid,
      '${AppStrings.rideBikeIdKey}': bikeId,
      '${AppStrings.rideStartTimeKey}': startTime,
      '${AppStrings.rideEndTimeKey}': null,
    });
  }

  Future<void> endActiveRide(String documentID, DateTime endTime) async {
    return Firestore.instance
        .document('${AppStrings.rideCollectionKey}/$documentID')
        .updateData({'${AppStrings.rideEndTimeKey}': endTime});
  }

  Future<void> addUserActiveRide(String documentID, String activeRideId) {
    return Firestore.instance
        .document('${AppStrings.userCollectionKey}/$documentID')
        .updateData({'${AppStrings.userActiveRideKey}': activeRideId});
  }

  Future<void> removeUserActiveRide(String documentID) {
    return Firestore.instance
        .document('${AppStrings.userCollectionKey}/$documentID')
        .updateData({'${AppStrings.userActiveRideKey}': null});
  }
}
