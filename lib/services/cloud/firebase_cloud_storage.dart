import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getAllLocations() async {
    QuerySnapshot querySnapshot = await _firestore.collection('location').get();
    return querySnapshot.docs;
  }

  Future<DocumentSnapshot> getLocation(String locationId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('location').doc(locationId).get();
    return documentSnapshot;
  }

  Future<List<DocumentSnapshot>> getAllZones() async {
    QuerySnapshot querySnapshot = await _firestore.collection('zone').get();
    return querySnapshot.docs;
  }

  Future<DocumentSnapshot> getZone(String zoneId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('zone').doc(zoneId).get();
    return documentSnapshot;
  }

  Future<List<DocumentSnapshot>> getReservation(String zoneId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('reservation')
        .where('zoneId', isEqualTo: zoneId)
        .get();
    return querySnapshot.docs;
  }
}
