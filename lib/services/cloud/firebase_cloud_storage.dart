import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/services/cloud/cloud_storage_exceptions.dart';
import 'package:modsport/utilities/types.dart';

class FirebaseCloudStorage {
  final location = FirebaseFirestore.instance.collection(locationCollection);
  final zone = FirebaseFirestore.instance.collection(zoneCollection);
  final userRes =
      FirebaseFirestore.instance.collection(userReservationCollection);
  final res = FirebaseFirestore.instance.collection(reservationCollection);
  final disable = FirebaseFirestore.instance.collection(disableCollection);

  Future<String> getLocation(String locationId) async {
    try {
      DocumentSnapshot documentSnapshot = await location.doc(locationId).get();
      return documentSnapshot[locationNameField];
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<ZoneData> getZone(String zoneId) async {
    try {
      DocumentSnapshot documentSnapshot = await zone.doc(zoneId).get();
      return ZoneData(
          imgUrl: documentSnapshot[imgUrlField],
          locationId: documentSnapshot[locationIdField],
          zoneName: documentSnapshot[zoneNameField]);
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<ReservationData>> getReservation(
      String zoneId, bool isDisableMenu, int selectedDateIndex) async {
    try {
      QuerySnapshot querySnapshot =
          await res.where(zoneIdField, isEqualTo: zoneId).get();

      final DateTime now =
          DateTime.now().add(Duration(days: selectedDateIndex));

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

      List<ReservationData> reservations = [];
      for (var doc in querySnapshot.docs) {
        int capacity = doc[capacityField];
        DateTime startTime = (doc[startTimeField])?.toDate();
        DateTime endTime = (doc[endTimeField])?.toDate();

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
                    ))))) {
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
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<DisableData>> getDisableReservation(String zoneId) async {
    try {
      QuerySnapshot querySnapshot =
          await disable.where(zoneIdField, isEqualTo: zoneId).get();

      List<DisableData> disabledReservations = [];
      for (var doc in querySnapshot.docs) {
        DateTime startDateTime = (doc[startDateTimeField])?.toDate();
        String reason = doc[disableReasonField];
        disabledReservations.add(DisableData(
            disableId: doc.id,
            startDateTime: startDateTime,
            disableReason: reason));
      }

      return disabledReservations;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<UserReservationData>> getAllUserReservation(String zoneId) async {
    try {
      QuerySnapshot querySnapshot =
          await userRes.where(zoneIdField, isEqualTo: zoneId).get();

      List<UserReservationData> userReservations = [];
      for (var doc in querySnapshot.docs) {
        DateTime startDateTime = (doc[startDateTimeField])?.toDate();
        String userId = doc[userIdField] as String;
        userReservations.add(
          UserReservationData(
            startDateTime: startDateTime,
            userId: userId,
          ),
        );
      }

      return userReservations;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<Map<String, dynamic>>> getReservationTime(
    List<String> reservationIds,
    int selectedDateIndex,
  ) async {
    try {
      final List<Map<String, dynamic>> reservationDetails = [];

      final DateTime now =
          DateTime.now().add(Duration(days: selectedDateIndex));

      for (final reservationId in reservationIds) {
        final DocumentSnapshot reservationSnapshot =
            await res.doc(reservationId).get();
        final DateTime startTime =
            (reservationSnapshot[startTimeField] as Timestamp).toDate();
        final DateTime endTime =
            (reservationSnapshot[endTimeField] as Timestamp).toDate();

        reservationDetails.add({
          startTimeField: DateTime(now.year, now.month, now.day, startTime.hour,
              startTime.minute, startTime.second),
          endTimeField: DateTime(now.year, now.month, now.day, endTime.hour,
              endTime.minute, endTime.second),
        });
      }

      return reservationDetails;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<void> createDisableReservation(
    String zoneId,
    String disableReason,
    List<Timestamp> startDateTimeList,
  ) async {
    try {
      for (var startDateTime in startDateTimeList) {
        await disable.add({
          zoneIdField: zoneId,
          disableReasonField: disableReason,
          startDateTimeField: startDateTime,
        });
      }

      
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  Future<void> deleteDisableReservation(List<String> reservationIds) async {
    try {
      for (final id in reservationIds) {
        final reservationRef = disable.doc(id);
        await reservationRef.delete();
      }
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  Future<void> updateDisableReason(
      List<String> disableIds, String disableReason) async {
    try {
      for (String disableId in disableIds) {
        await disable.doc(disableId).update({
          disableReasonField: disableReason,
        });
      }
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  Future<List<String>> getReservationIds(
      List<DateTime?> startTimes, String zoneId) async {
    try {
      final dayFormat = DateFormat('EEEE');

      final reservationIds = <String>[];
      final reservations =
          await res.where(zoneIdField, isEqualTo: zoneId).get();

      DateTime? resStartTime;
      for (final startTime in startTimes) {
        if (startTimes.isNotEmpty) {
          resStartTime = startTime;
          for (final reservation in reservations.docs) {
            final dayName =
                dayFormat.format(reservation[startTimeField].toDate());

            if (dayName == dayFormat.format(resStartTime!) &&
                reservation[startTimeField].toDate().hour ==
                    resStartTime.hour &&
                reservation[startTimeField].toDate().minute ==
                    resStartTime.minute &&
                reservation[startTimeField].toDate().second ==
                    resStartTime.second) {
              reservationIds.add(reservation.id);
            }
          }
        }
      }

      return reservationIds;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<void> createUserReservation(DateTime startDateTime, String userId,
      String zoneId, int capacity) async {
    try {
      List<UserReservationData> userReservation =
          await getAllUserReservation(zoneId);

      bool canCreate = true;

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

      // 1. Check if the zone exists
      final zoneSnapshot = await zone.doc(zoneId).get();
      if (!zoneSnapshot.exists) {
        canCreate = false;
        throw CouldNotCreateException();
      }

      // 2. Check if the user has an existing reservation for the same day
      final querySnapshot = await userRes
          .where(userIdField, isEqualTo: userId)
          .where(zoneIdField, isEqualTo: zoneId)
          .get();

      for (var doc in querySnapshot.docs) {
        DateTime docStartDateTime = doc[startDateTimeField].toDate();
        if (docStartDateTime.year == startDateTime.year &&
            docStartDateTime.month == startDateTime.month &&
            docStartDateTime.day == startDateTime.day &&
            docStartDateTime.hour == startDateTime.hour &&
            docStartDateTime.minute == startDateTime.minute &&
            docStartDateTime.second == startDateTime.second) {
          canCreate = false;
          throw CouldNotCreateException();
        }
      }

      // 3. Check if the requested start time is disabled
      final disabledQuerySnapshot =
          await disable.where(zoneIdField, isEqualTo: zoneId).get();

      for (var doc in disabledQuerySnapshot.docs) {
        DateTime docStartDateTime = doc[startDateTimeField].toDate();
        if (docStartDateTime.year == startDateTime.year &&
            docStartDateTime.month == startDateTime.month &&
            docStartDateTime.day == startDateTime.day &&
            docStartDateTime.hour == startDateTime.hour &&
            docStartDateTime.minute == startDateTime.minute &&
            docStartDateTime.second == startDateTime.second) {
          canCreate = false;
          throw CouldNotCreateException();
        }
      }

      // 4. Check if the number of reservations for the requested startDateTime has not exceeded the capacity
      final numReservations = countNumOfReservation(startDateTime);
      if (numReservations >= capacity) {
        canCreate = false;
        throw CouldNotCreateException();
      }

      // 5. Create a new reservation document
      if (canCreate) {
        await userRes.add(
          {
            'startDateTime': startDateTime,
            'userId': userId,
            'zoneId': zoneId,
            'isSuccessful': true,
            // Add any other fields you want to store in the document
          },
        );
      }
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  Future<bool> getIsUserReserved(
      String userId,
      String zoneId,
      DateTime startDateTime,
      List<ReservationData> reservation,
      int selectedTimeSlot) async {
    try {
      final querySnapshot = await userRes
          .where(userIdField, isEqualTo: userId)
          .where(zoneIdField, isEqualTo: zoneId)
          .get();

      for (var doc in querySnapshot.docs) {
        DateTime docStartDateTime = doc[startDateTimeField].toDate();
        if (docStartDateTime.year == startDateTime.year &&
            docStartDateTime.month == startDateTime.month &&
            docStartDateTime.day == startDateTime.day) {
          if (reservation[selectedTimeSlot].startTime!.hour ==
                  docStartDateTime.hour &&
              reservation[selectedTimeSlot].startTime!.minute ==
                  docStartDateTime.minute &&
              reservation[selectedTimeSlot].startTime!.second ==
                  docStartDateTime.second) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<void> deleteUserReservation(
      String userId, String zoneId, DateTime startDateTime) async {
    try {
      final querySnapshot = await userRes
          .where(userIdField, isEqualTo: userId)
          .where(zoneIdField, isEqualTo: zoneId)
          .where(startDateTimeField, isEqualTo: startDateTime)
          .get();

      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  Future<List<UserReservationData>> getUserReservationDataList(
      String userId, String zoneId) async {
    try {
      final querySnapshot = await userRes
          .where(userIdField, isEqualTo: userId)
          .where(zoneIdField, isEqualTo: zoneId)
          .get();

      final userReservationDataList = querySnapshot.docs
          .map((doc) => UserReservationData(
                startDateTime: doc[startDateTimeField].toDate(),
                userId: doc[userIdField],
              ))
          .toList();

      return userReservationDataList;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<int> getUserReservationIndex(List<ReservationData> reservationDataList,
      String userId, String zoneId) async {
    try {
      List<UserReservationData> userReservationDataList =
          await getUserReservationDataList(userId, zoneId);

      for (int i = 0; i < reservationDataList.length; i++) {
        ReservationData reservationData = reservationDataList[i];

        for (int j = 0; j < userReservationDataList.length; j++) {
          UserReservationData userReservationData = userReservationDataList[j];

          if (reservationData.startTime == userReservationData.startDateTime) {
            return i;
          }
        }
      }

      return 0;
    } catch (e) {
      throw CouldNotGetException();
    }
  }
}
