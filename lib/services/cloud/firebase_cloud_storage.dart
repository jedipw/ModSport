import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modsport/utilities/types.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LocationData> getLocation(String locationId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('location').doc(locationId).get();
    return LocationData(
      imgUrl: documentSnapshot['imgUrl'],
      locationName: documentSnapshot['locationName'],
    );
  }

  Future<ZoneData> getZone(String zoneId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('zone').doc(zoneId).get();
    return ZoneData(
        locationId: documentSnapshot['locationId'],
        zoneName: documentSnapshot['zoneName']);
  }

  Future<List<ReservationData>> getReservation(
      String zoneId, bool isDisableMenu, int selectedDateIndex) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('reservation')
        .where('zoneId', isEqualTo: zoneId)
        .get();

    final DateTime now = DateTime.now().add(Duration(days: selectedDateIndex));

    bool isTimeSlotExpired(DateTime endTime) {
      final DateTime now = DateTime.now();
      return now.isAfter(endTime);
    }

    List<ReservationData> reservations = [];
    for (var doc in querySnapshot.docs) {
      int capacity = doc['capacity'];
      DateTime startTime = (doc['startTime'])?.toDate();
      DateTime endTime = (doc['endTime'])?.toDate();

      if (!isTimeSlotExpired(DateTime(now.year, now.month, now.day,
          endTime.hour, endTime.minute, endTime.second))) {
        reservations.add(ReservationData(
            capacity: capacity, startTime: startTime, endTime: endTime));
      }
    }

    return reservations;
  }
}
