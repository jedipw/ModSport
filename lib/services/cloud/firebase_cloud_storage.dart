import 'dart:developer' show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modsport/utilities/types.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getLocation(String locationId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('location').doc(locationId).get();
    return documentSnapshot['locationName'];
  }

  Future<ZoneData> getZone(String zoneId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('zone').doc(zoneId).get();
    return ZoneData(
        imgUrl: documentSnapshot['imgUrl'],
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
            reservationId: doc.id,
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
      disabledReservations.add(DisableData(
          disableId: doc.id,
          startDateTime: startDateTime,
          disableReason: reason));
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

  Future<List<Map<String, dynamic>>> getReservationTime(
      List<String> reservationIds, int selectedDateIndex) async {
    final List<Map<String, dynamic>> reservationDetails = [];

    final DateTime now = DateTime.now().add(Duration(days: selectedDateIndex));

    for (final reservationId in reservationIds) {
      final DocumentSnapshot reservationSnapshot =
          await _firestore.collection('reservation').doc(reservationId).get();
      final DateTime startTime =
          (reservationSnapshot['startTime'] as Timestamp).toDate();
      final DateTime endTime =
          (reservationSnapshot['endTime'] as Timestamp).toDate();

      reservationDetails.add({
        'startTime': DateTime(now.year, now.month, now.day, startTime.hour,
            startTime.minute, startTime.second),
        'endTime': DateTime(now.year, now.month, now.day, endTime.hour,
            endTime.minute, endTime.second),
      });
    }

    return reservationDetails;
  }

  Future<void> createDisableReservation(
    String zoneId,
    String disableReason,
    List<Timestamp> startDateTimeList,
  ) async {
    try {
      for (var startDateTime in startDateTimeList) {
        await _firestore.collection('disable').add({
          'zoneId': zoneId,
          'disableReason': disableReason,
          'startDateTime': startDateTime,
        });
      }
    } catch (e) {
      log('Error creating disabled reservation: $e');
    }
  }

  Future<void> deleteDisableReservation(List<String> reservationIds) async {
    final disableReservationRef =
        FirebaseFirestore.instance.collection('disable');

    for (final id in reservationIds) {
      final reservationRef = disableReservationRef.doc(id);
      await reservationRef.delete();
    }
  }

  Future<void> updateDisableReason(
      List<String> disableIds, String disableReason) async {
    final CollectionReference disableReservationRef =
        FirebaseFirestore.instance.collection('disable');

    for (String disableId in disableIds) {
      await disableReservationRef.doc(disableId).update({
        'disableReason': disableReason,
      });
    }
  }

  Future<List<String>> getReservationIdsFromDisableIds(
      List<DateTime> startTimes, String zoneId) async {
    // Create a list to hold the reservation IDs
    List<String> reservationIds = [];

    // Get a reference to the Firestore collection for reservations
    final CollectionReference reservationRef =
        FirebaseFirestore.instance.collection('reservations');

    // Create a query to get all the reservations with the given start times and zone ID
    Query reservationQuery = reservationRef
        .where('startTime', whereIn: startTimes)
        .where('zoneId', isEqualTo: zoneId);

    // Execute the query and get the snapshot
    QuerySnapshot reservationSnapshot = await reservationQuery.get();

    // Loop through the snapshot documents and add the reservation IDs to the list
    for (QueryDocumentSnapshot reservationDoc in reservationSnapshot.docs) {
      reservationIds.add(reservationDoc.id);
    }

    return reservationIds;
  }

  Future<List<String>> getReservationIds(
      List<DateTime?> startTimes, String zoneId) async {
    final dayFormat = DateFormat('EEEE');

    final reservationIds = <String>[];
    final reservations = await FirebaseFirestore.instance
        .collection('reservation')
        .where('zoneId', isEqualTo: zoneId)
        .get();

    DateTime? resStartTime;
    for (final startTime in startTimes) {
      if (startTimes.isNotEmpty) {
        resStartTime = startTime;
        for (final reservation in reservations.docs) {
          final dayName = dayFormat.format(reservation['startTime'].toDate());

          if (dayName == dayFormat.format(resStartTime!) &&
              reservation['startTime'].toDate().hour == resStartTime.hour &&
              reservation['startTime'].toDate().minute == resStartTime.minute &&
              reservation['startTime'].toDate().second == resStartTime.second) {
            reservationIds.add(reservation.id);
          }
        }
      }
    }

    return reservationIds;
  }
}
