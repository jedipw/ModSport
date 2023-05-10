import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/services/cloud/cloud_storage_exceptions.dart';
import 'package:modsport/utilities/types.dart';
import 'package:modsport/views/reservation_view.dart';

class FirebaseCloudStorage {
  final user = FirebaseFirestore.instance.collection(userCollection);
  final location = FirebaseFirestore.instance.collection(locationCollection);
  final zone = FirebaseFirestore.instance.collection(zoneCollection);
  final userRes =
      FirebaseFirestore.instance.collection(userReservationCollection);
  final res = FirebaseFirestore.instance.collection(reservationCollection);
  final disable = FirebaseFirestore.instance.collection(disableCollection);
  final device = FirebaseFirestore.instance.collection(deviceCollection);
  final pin = FirebaseFirestore.instance.collection(pinCollection);
  final category = FirebaseFirestore.instance.collection(categoryCollection);

  Future<bool> getUserHasRole(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await user.doc(userId).get();
      return documentSnapshot[hasRoleField];
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<String> getLocation(String locationId) async {
    try {
      DocumentSnapshot documentSnapshot = await location.doc(locationId).get();
      return documentSnapshot[locationNameField];
    } catch (e) {
      throw CouldNotGetException();
    }
  }

Future<List<Booking>> getBookings() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot userResSnapshot =
        await userRes.where(userIdField, isEqualTo: userId).get();
    List<Booking> bookingsList =
        await Future.wait(userResSnapshot.docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      final startDateTime = DateTime.fromMillisecondsSinceEpoch(
          data[startDateTimeField].millisecondsSinceEpoch);
      final formattedDate =
          DateFormat('d MMM y').format(startDateTime); // Example date format
      final formattedTime =
          DateFormat('HH:mm').format(startDateTime); // Example time format

      // Fetch the corresponding zone document to get the zone name
      final zoneDoc = await zone.doc(data[zoneIdField]).get();
      final zoneData = zoneDoc.data() as Map<String, dynamic>;
      final zoneName = zoneData[zoneNameField];

      // Fetch the corresponding reservation document to get the end time
      final resSnapshot = await res.where(zoneIdField, isEqualTo: data[zoneIdField]).get();
      final startTimes = <DateTime>[];
      final reservationIds = <String>[];
      for (final reservation in resSnapshot.docs) {
        final resData = reservation.data();
        final startTime = DateTime.fromMillisecondsSinceEpoch(
            resData[startTimeField].millisecondsSinceEpoch);

        if (startDateTime.second == startTime.second &&
            startDateTime.minute == startTime.minute &&
            startDateTime.hour == startTime.hour &&
            DateFormat('EEEE', 'en_US').format(startDateTime) ==
                DateFormat('EEEE', 'en_US').format(startTime)) {
          startTimes.add(startTime);
          reservationIds.add(reservation.id);
        }
      }

      startTimes.sort((a, b) => a.compareTo(b));
      final reservationId = reservationIds.first;
      final resDoc = await res.doc(reservationId).get();
      final resData = resDoc.data() as Map<String, dynamic>;
      final endDateTime = DateTime.fromMillisecondsSinceEpoch(
          resData[endTimeField].millisecondsSinceEpoch);
      final formattedEndTime =
          DateFormat('HH:mm').format(endDateTime);

      return Booking(
        zoneId: data[zoneIdField],
        zoneName: zoneName,
        date: formattedDate,
        time: formattedTime,
        dateTime: startDateTime,
        endTime: formattedEndTime,
        isSuccessful: data[isSuccessfulField],
      );
    }).toList());

    // Sort the bookings list by date
    bookingsList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return bookingsList;
  } catch (e) {
    throw CouldNotGetException();
  }
}


  Future<List<ZoneData>> getAllZones() async {
    try {
      QuerySnapshot snapshot = await zone.get();
      log(snapshot.toString());
      return snapshot.docs
          .map((document) => ZoneData(
              zoneId: document.id,
              imgUrl: document.get(imgUrlField),
              locationId: document.get(locationIdField),
              zoneName: document.get(zoneNameField)))
          .toList();
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<String>> getAllCategories() async {
  try {
    List<String> categories = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(categoryCollection)
        .get();
        log(snapshot.toString());
    for (var document in snapshot.docs) {
      categories.add(document.get(
        categoryNameField));
    }
    return categories;
  } catch (e) {
    throw CouldNotGetException();
  }
}

Future<List<CategoryData>> getAllCategorie() async {
  
    try {
      QuerySnapshot snapshot = await category.get();
      log(snapshot.toString());
      return snapshot.docs
          .map((document) => CategoryData(  
              categoryId: document.id,
              categoryName: document.get(categoryNameField)))
          .toList();
    } catch (e) {
      throw CouldNotGetException();
    }
  }



Future<List<DocumentSnapshot>> getAllZoneToCategory() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(zoneToCategoryCollection)
        .get();
    return snapshot.docs;
  } catch (e) {
    throw CouldNotGetException();
  }
}

Future<void> pinZone(String zoneId) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await pin.add({
      zoneIdField: zoneId,
      userIdField : userId
    });
  } catch (e) {
    throw CouldNotCreateException();
  }
}

Future<void> unpinZone(String zoneId) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await pin
        .where(zoneIdField, isEqualTo: zoneId)
        .where(userIdField, isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await Future.wait(querySnapshot.docs.map((doc) async {
        return doc.reference.delete();
      }));
    }
  } catch (e) {
    throw CouldNotDeleteException();
  }
}
Future<String> getPin(String zoneId) async {
 
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await pin
        .where(zoneIdField, isEqualTo: zoneId)
        .where(userIdField, isEqualTo: userId)
        .get();
    String pinId = querySnapshot.docs.isNotEmpty ? querySnapshot.docs[0].id : "";
    print("getPin result: $pinId");
    return pinId;
  } catch (e) {
    throw CouldNotGetException();
  }
}

Future<List<String>> getPinnedZones() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  try {
    final querySnapshot = await pin
        .where(userIdField, isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()[zoneIdField] as String).toList();
  } catch (e) {
    throw CouldNotGetException();
  }
}
Future<List<ZoneData>> getZonesByCategoryId(String categoryId) async {
  List<String> zoneIds = [];
  List<ZoneData> zones = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection(zoneToCategoryCollection)
    .where(categoryIdField, isEqualTo: categoryId)
    .get();
log('Number of documents: ${snapshot.size}');
for (var document in snapshot.docs) {
  log(document.get(zoneIdField));
  zoneIds.add(document.get(zoneIdField));
} 
    for (String id in zoneIds) {
  
    ZoneData zone = await FirebaseCloudStorage().getZone(id);
    zones.add(zone);
  
}
    return zones;
  } catch (e) {
    throw CouldNotGetException();
  }
 
}

  Future<ZoneData> getZone(String zoneId) async {
    try {
      DocumentSnapshot documentSnapshot = await zone.doc(zoneId).get();
      return ZoneData(
          zoneId: documentSnapshot.id,
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
          await getDisableReservation(zoneId, selectedDateIndex);

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

  Future<List<DisableData>> getDisableReservation(
      String zoneId, int selectedDateIndex) async {
    try {
      final DateTime now =
          DateTime.now().add(Duration(days: selectedDateIndex));

      QuerySnapshot querySnapshot =
          await disable.where(zoneIdField, isEqualTo: zoneId).get();

      List<DisableData> disabledReservations = [];
      for (var doc in querySnapshot.docs) {
        if (doc[startDateTimeField]?.toDate().year == now.year &&
            doc[startDateTimeField]?.toDate().month == now.month &&
            doc[startDateTimeField]?.toDate().day == now.day) {
          DateTime startDateTime = (doc[startDateTimeField])?.toDate();
          String reason = doc[disableReasonField];
          disabledReservations.add(DisableData(
              disableId: doc.id,
              startDateTime: startDateTime,
              disableReason: reason));
        }
      }
      disabledReservations
          .sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

      return disabledReservations;
    } catch (e) {
      throw CouldNotGetException();
    }
  }

  Future<List<UserReservationData>> getAllUserReservation(String zoneId) async {
    try {
      QuerySnapshot querySnapshot = await userRes
          .where(zoneIdField, isEqualTo: zoneId)
          .where(isSuccessfulField, isEqualTo: true)
          .get();

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
      final userIds = <String>[];
      for (var startDateTime in startDateTimeList) {
        // Check if a disable reservation already exists for the given zoneId and startDateTime
        final existingDocs = await disable
            .where(zoneIdField, isEqualTo: zoneId)
            .where(startDateTimeField,
                isEqualTo: Timestamp.fromDate(startDateTime.toDate()))
            .get();

        if (existingDocs.docs.isNotEmpty) {
          // A disable reservation already exists for the given zoneId and startDateTime
          // Skip adding a new one and continue with the next startDateTime in the list
          continue;
        }

        // Add the disable reservation to the disable collection
        await disable.add({
          zoneIdField: zoneId,
          disableReasonField: disableReason,
          startDateTimeField: startDateTime,
        });

        // Update userReservation to set isSuccessful to false
        final querySnapshot =
            await userRes.where(zoneIdField, isEqualTo: zoneId).get();

        if (querySnapshot.docs.isNotEmpty) {
          await Future.wait(
            querySnapshot.docs.map(
              (doc) async {
                if (startDateTime.toDate().year ==
                        doc[startDateTimeField].toDate().year &&
                    startDateTime.toDate().month ==
                        doc[startDateTimeField].toDate().month &&
                    startDateTime.toDate().day ==
                        doc[startDateTimeField].toDate().day &&
                    startDateTime.toDate().hour ==
                        doc[startDateTimeField].toDate().hour &&
                    startDateTime.toDate().minute ==
                        doc[startDateTimeField].toDate().minute &&
                    startDateTime.toDate().second ==
                        doc[startDateTimeField].toDate().second) {
                  if (doc[isSuccessfulField] == true) {
                    userIds.add(doc[userIdField]);
                  }

                  return doc.reference.update({
                    'isSuccessful': false,
                  });
                }
              },
            ),
          );

          Future<List<String>> getDeviceTokens(List<String> userIds) async {
            final querySnapshot =
                await device.where(userIdField, whereIn: userIds).get();
            return querySnapshot.docs.map((doc) => doc.id).toList();
          }

          List<String> deviceTokens = [];
          if (userIds.isNotEmpty) {
            deviceTokens = await getDeviceTokens(userIds);
          }

          for (String deviceToken in deviceTokens) {
            String constructFCMPayload(String? token) {
              return jsonEncode({
                'to': token,
                'data': {
                  'via': 'FlutterFire Cloud Messaging!!!',
                },
                'notification': {
                  'title': 'Reservation Canceled',
                  'body':
                      'Your reservation has been canceled. Please check the app for more information.',
                },
              });
            }

            await http.post(
              Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                "Authorization":
                    "key=AAAAoUHQOTI:APA91bEtJeZRt2Gs88M9LZ5WbbnVEyB4ATEAP4rYIRiZj-ZLZAOUjRJny5a441spMa6gZ6x2zWUlg6DC5qu1QeETT7NJNjsNWc6-i6VwJiC4nj2W9arXFCQew1Z3-ywt8WTyEFUHPUPE",
              },
              body: constructFCMPayload(deviceToken),
            );
          }
        }
      }
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  Future<void> deleteDisableReservation(
    List<String> reservationIds,
    String zoneId,
    List<Timestamp> startDateTimeList,
  ) async {
    try {
      for (final id in reservationIds) {
        final reservationRef = disable.doc(id);
        await reservationRef.delete();
      }
      // Update userReservation to set isSuccessful to false
      final querySnapshot =
          await userRes.where(zoneIdField, isEqualTo: zoneId).get();

      final userIds = <String>[];

      for (var startDateTime in startDateTimeList) {
        if (querySnapshot.docs.isNotEmpty) {
          await Future.wait(
            querySnapshot.docs.map(
              (doc) async {
                if (startDateTime.toDate().year ==
                        doc[startDateTimeField].toDate().year &&
                    startDateTime.toDate().month ==
                        doc[startDateTimeField].toDate().month &&
                    startDateTime.toDate().day ==
                        doc[startDateTimeField].toDate().day &&
                    startDateTime.toDate().hour ==
                        doc[startDateTimeField].toDate().hour &&
                    startDateTime.toDate().minute ==
                        doc[startDateTimeField].toDate().minute &&
                    startDateTime.toDate().second ==
                        doc[startDateTimeField].toDate().second) {
                  if (doc[isSuccessfulField] == false) {
                    userIds.add(doc[userIdField]);
                  }
                }
              },
            ),
          );

          Future<List<String>> getDeviceTokens(List<String> userIds) async {
            final querySnapshot =
                await device.where(userIdField, whereIn: userIds).get();
            return querySnapshot.docs.map((doc) => doc.id).toList();
          }

          List<String> deviceTokens = [];
          if (userIds.isNotEmpty) {
            deviceTokens = await getDeviceTokens(userIds);
          }

          for (String deviceToken in deviceTokens) {
            String constructFCMPayload(String? token) {
              return jsonEncode({
                'to': token,
                'data': {
                  'via': 'FlutterFire Cloud Messaging!!!',
                },
                'notification': {
                  'title': 'Reservation Available',
                  'body':
                      'Your canceled reservation is now available again. Please check the app for more information.',
                },
              });
            }

            await http.post(
              Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                "Authorization":
                    "key=AAAAoUHQOTI:APA91bEtJeZRt2Gs88M9LZ5WbbnVEyB4ATEAP4rYIRiZj-ZLZAOUjRJny5a441spMa6gZ6x2zWUlg6DC5qu1QeETT7NJNjsNWc6-i6VwJiC4nj2W9arXFCQew1Z3-ywt8WTyEFUHPUPE",
              },
              body: constructFCMPayload(deviceToken),
            );
          }
        }
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
      bool needToUpdate = false;

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
            docStartDateTime.second == startDateTime.second &&
            doc[isSuccessfulField] == true) {
          canCreate = false;
          throw CouldNotCreateException();
        } else if (docStartDateTime.year == startDateTime.year &&
            docStartDateTime.month == startDateTime.month &&
            docStartDateTime.day == startDateTime.day &&
            docStartDateTime.hour == startDateTime.hour &&
            docStartDateTime.minute == startDateTime.minute &&
            docStartDateTime.second == startDateTime.second &&
            doc[isSuccessfulField] == false) {
          needToUpdate = true;
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
      if (canCreate && !needToUpdate) {
        await userRes.add(
          {
            startDateTimeField: startDateTime,
            userIdField: userId,
            zoneIdField: zoneId,
            isSuccessfulField: true,
            // Add any other fields you want to store in the document
          },
        );
      } else if (canCreate && needToUpdate) {
        final querySnapshot = await userRes
            .where(userIdField, isEqualTo: userId)
            .where(zoneIdField, isEqualTo: zoneId)
            .where(startDateTimeField, isEqualTo: startDateTime)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          final docRef = querySnapshot.docs.first.reference;
          await docRef.update({isSuccessfulField: true});
        } else {
          throw CouldNotCreateException();
        }
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
          .where(isSuccessfulField, isEqualTo: true)
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
          .where(isSuccessfulField, isEqualTo: true)
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

  Future<List<ReservationData>> getEditReservation(
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
          await getDisableReservation(zoneId, selectedDateIndex);

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
            isDisable(DateTime(
              now.year,
              now.month,
              now.day,
              startTime.hour,
              startTime.minute,
              startTime.second,
            ))) {
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

  void addDeviceTokenAndUserId(String userId) async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      // Use device token as the document ID in "device" collection
      if (deviceToken != null) {
        await device.doc(deviceToken).set({
          userIdField: userId,
        });
      }
    } catch (error) {
      throw CouldNotCreateException();
    }
  }

  void removeDeviceTokenAndUserId(String userId) async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      // Delete document by ID in "device" collection
      if (deviceToken != null) {
        await device.doc(deviceToken).delete();
      }
    } catch (error) {
      throw CouldNotDeleteException;
    }
  }
}
