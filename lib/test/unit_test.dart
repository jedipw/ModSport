import 'package:test/test.dart';
import 'package:modsport/test/unit_test.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/services/cloud/cloud_storage_exceptions.dart';
import 'package:modsport/utilities/reservation/location_name.dart';
import 'package:modsport/utilities/reservation/zone_name.dart';
import 'package:modsport/utilities/types.dart';


var userRes = FirebaseFirestore.instance.collection('userReservation');
var zone = FirebaseFirestore.instance.collection('zone');
var disable = FirebaseFirestore.instance.collection('disable');
var device = FirebaseFirestore.instance.collection('device');

void main() {
  group('Reservation Functions', () {
    test('createUserReservation', () {
      // Test setup
      DateTime startDateTime = DateTime.now();
      String userId = 'user123';
      String zoneId = 'zone456';
      int capacity = 10;

      // Test execution
      expect(() => createUserReservation(startDateTime, userId, zoneId, capacity), throwsA(isA<CouldNotCreateException>()));
    });

    test('deleteUserReservation', () {
      // Test setup
      String userId = 'user123';
      String zoneId = 'zone456';
      DateTime startDateTime = DateTime.now();

      // Test execution
      expect(() => deleteUserReservation(userId, zoneId, startDateTime), throwsA(isA<CouldNotDeleteException>()));
    });
  });

  group('Device Token Functions', () {
    test('addDeviceTokenAndUserId', () {
      // Test setup
      String userId = 'user123';

      // Test execution
      expect(() => addDeviceTokenAndUserId(userId), throwsA(isA<CouldNotCreateException>()));
    });

    test('removeDeviceTokenAndUserId', () {
      // Test setup
      String userId = 'user123';

      // Test execution
      expect(() => removeDeviceTokenAndUserId(userId), throwsA(isA<CouldNotDeleteException>()));
    });
  });
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
      throw CouldNotDeleteException(); // Add parentheses to create an instance of the exception
    }
  }