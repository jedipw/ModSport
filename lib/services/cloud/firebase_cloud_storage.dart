import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

    bool isTheSameDay(DateTime day) {
      if (DateFormat('EEE').format(day).substring(0, 3) ==
          DateFormat('EEE').format(now).substring(0, 3)) return true;
      return false;
    }

    bool isTimeSlotExpired(DateTime endTime) {
      final DateTime now = DateTime.now();
      return now.isAfter(endTime);
    }

    final List<DisableData> disabledReservation =
        await getDisableReservation(zoneId);

    final List<UserReservationData> userReservation =
        await getAllUserReservation(zoneId);

    bool isDisable(DateTime? startTime) {
      for (int i = 0; i < disabledReservation.length; i++) {
        if (disabledReservation[i].startDateTime.year == startTime!.year &&
            disabledReservation[i].startDateTime.month == startTime.month &&
            disabledReservation[i].startDateTime.day == startTime.day &&
            disabledReservation[i].startDateTime.hour == startTime.hour &&
            disabledReservation[i].startDateTime.minute == startTime.minute &&
            disabledReservation[i].startDateTime.second == startTime.second) {
          return true;
        }
      }
      return false;
    }

    int countNumOfReservation(DateTime? startTime) {
      int num = 0;
      for (int i = 0; i < userReservation.length; i++) {
        if (startTime!.year == userReservation[i].startDateTime.year &&
            startTime.month == userReservation[i].startDateTime.month &&
            startTime.day == userReservation[i].startDateTime.day &&
            startTime.hour == userReservation[i].startDateTime.hour &&
            startTime.minute == userReservation[i].startDateTime.minute &&
            startTime.second == userReservation[i].startDateTime.second) {
          num++;
        }
      }
      return num;
    }

    List<ReservationData> reservations = [];
    for (var doc in querySnapshot.docs) {
      int capacity = doc['capacity'];
      DateTime startTime = (doc['startTime'])?.toDate();
      DateTime endTime = (doc['endTime'])?.toDate();

      if (!isTimeSlotExpired(DateTime(now.year, now.month, now.day,
              endTime.hour, endTime.minute, endTime.second)) &&
          isTheSameDay(startTime) &&
          (isDisableMenu ||
              (!isDisableMenu &&
                  !isDisable(DateTime(
                    now.year,
                    now.month,
                    now.day,
                    startTime.hour,
                    startTime.minute,
                    startTime.second,
                  )) &&
                  countNumOfReservation(DateTime(
                        now.year,
                        now.month,
                        now.day,
                        startTime.hour,
                        startTime.minute,
                        startTime.second,
                      )) !=
                      capacity))) {
        reservations.add(ReservationData(
            capacity: capacity,
            startTime: DateTime(
              now.year,
              now.month,
              now.day,
              startTime.hour,
              startTime.minute,
              startTime.second,
            ),
            endTime: DateTime(
              now.year,
              now.month,
              now.day,
              endTime.hour,
              endTime.minute,
              endTime.second,
            )));
      }
    }
    reservations.sort((a, b) => a.startTime!.compareTo(b.startTime!));
    return reservations;
  }

  Future<List<DisableData>> getDisableReservation(String zoneId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('disable')
        .where('zoneId', isEqualTo: zoneId)
        .get();

    List<DisableData> disabledReservations = [];
    for (var doc in querySnapshot.docs) {
      DateTime startDateTime = (doc['startDateTime'])?.toDate();
      String reason = doc['disableReason'];
      disabledReservations.add(
          DisableData(startDateTime: startDateTime, disableReason: reason));
    }

    return disabledReservations;
  }

  Future<List<UserReservationData>> getAllUserReservation(String zoneId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('userreservation')
        .where('zoneId', isEqualTo: zoneId)
        .get();

    List<UserReservationData> userReservations = [];
    for (var doc in querySnapshot.docs) {
      DateTime startDateTime = (doc['startDateTime'])?.toDate();
      String userId = doc['userId'] as String;
      userReservations.add(UserReservationData(
        startDateTime: startDateTime,
        userId: userId,
      ));
    }

    return userReservations;
  }
}
