// Importing necessary packages and files
import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/reservation/date_list.dart';
import 'package:modsport/utilities/reservation/edit_button.dart';
import 'package:modsport/utilities/reservation/enable_button.dart';
import 'package:modsport/utilities/reservation/time_slot_disable.dart';
import 'package:modsport/utilities/reservation/time_slot_loading.dart';
import 'package:modsport/utilities/reservation/time_slot_reserve.dart';
import 'package:modsport/utilities/reservation/reserve_button.dart';
import 'package:modsport/utilities/reservation/disable_button.dart';
import 'package:modsport/utilities/reservation/typeclass.dart';
import 'package:shimmer/shimmer.dart';

bool hasRole = true;

// Creating a StatefulWidget called ReservationView
class ReservationView extends StatefulWidget {
  const ReservationView({super.key, required this.zoneId});

  final String zoneId;

  // Override method to create a State object
  @override
  State<ReservationView> createState() => _ReservationViewState();
}

// Creating a State object called _ReservationViewState
class _ReservationViewState extends State<ReservationView> {
  int _selectedDateIndex = 0;
  bool _isReserved = false;
  int _selectedTimeSlot = 0;
  bool isDisableMenu = false;
  bool timeHasLoaded = false;
  List<bool?> selectedTimeSlots = [];
  Key key = UniqueKey();
  String _imgUrl = 'https://i.imgur.com/AoYPnKY.png';
  String _locationName = '';
  String _locationId = '';
  String _zoneName = '';
  List<DocumentSnapshot> _reservation = [];

  @override
  void initState() {
    super.initState();
    _getLocationData();
    _getZoneData();
    _getReservationData().then((value) {
      setState(() {
        timeHasLoaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getLocationData();
    _getZoneData();
    _getReservationData().then((value) {
      setState(() {
        timeHasLoaded = true;
      });
    });
  }

  Future<void> _getReservationData() async {
    try {
      timeHasLoaded = false;
      List<DocumentSnapshot> reservation =
          await FirebaseCloudStorage().getReservation(widget.zoneId);

      setState(() {
        _reservation = reservation;
      });
    } catch (e) {
      log('Error fetching location data: $e');
    }
  }

  Future<void> _getZoneData() async {
    try {
      // Get the zone document snapshot
      DocumentSnapshot zoneSnapshot =
          await FirebaseCloudStorage().getZone(widget.zoneId);

      String locationId = zoneSnapshot.data() != null &&
              (zoneSnapshot.data() as Map<String, dynamic>)
                  .containsKey('locationId')
          ? (zoneSnapshot.data() as Map<String, dynamic>)['locationId']
          : '';

      String zoneName = zoneSnapshot.data() != null &&
              (zoneSnapshot.data() as Map<String, dynamic>)
                  .containsKey('zoneName')
          ? (zoneSnapshot.data() as Map<String, dynamic>)['zoneName']
          : '';

      // Update the state
      setState(() {
        _locationId = locationId;
        _zoneName = zoneName;
      });
    } catch (e) {
      log('Error fetching location data: $e');
    }
  }

  Future<void> _getLocationData() async {
    try {
      await _getZoneData();
      // Get the location document snapshot
      DocumentSnapshot locationSnapshot =
          await FirebaseCloudStorage().getLocation(_locationId);

      // Extract the img_url from the location snapshot
      String imgUrl = locationSnapshot.data() != null &&
              (locationSnapshot.data() as Map<String, dynamic>)
                  .containsKey('imgUrl')
          ? (locationSnapshot.data() as Map<String, dynamic>)['imgUrl']
          : '';

      String locationName = locationSnapshot.data() != null &&
              (locationSnapshot.data() as Map<String, dynamic>)
                  .containsKey('locationName')
          ? (locationSnapshot.data() as Map<String, dynamic>)['locationName']
          : '';

      // Update the state with the imgUrl
      setState(() {
        _imgUrl = imgUrl;
        _locationName = locationName;
      });
    } catch (e) {
      log('Error fetching location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> parts = _locationName.split(RegExp(r'\s+(?=-\s)'));

    final DateTime now = DateTime.now().add(Duration(days: _selectedDateIndex));
    // A list of time slots as TimeSlotData objects
    bool isTimeSlotExpired(DateTime endTime) {
      final DateTime now = DateTime.now();
      return now.isAfter(endTime);
    }

    List<DateTime> disabledReservation = [
      DateTime(2023, 4, 20, 9, 0, 0),
      DateTime(2023, 4, 20, 10, 0, 0),
      DateTime(2023, 4, 20, 11, 0, 0),
      DateTime(2023, 4, 20, 12, 0, 0),
      DateTime(2023, 4, 20, 13, 0, 0),
      DateTime(2023, 4, 20, 14, 0, 0),
      DateTime(2023, 4, 20, 15, 0, 0),
      DateTime(2023, 4, 20, 16, 0, 0),
      DateTime(2023, 4, 20, 17, 0, 0),
      DateTime(2023, 4, 20, 18, 0, 0),
      DateTime(2023, 4, 20, 19, 0, 0),
      DateTime(2023, 4, 20, 20, 0, 0),
      DateTime(2023, 4, 20, 21, 0, 0),
      DateTime(2023, 4, 20, 22, 0, 0),
      DateTime(2023, 4, 20, 23, 0, 0),
    ];

    bool isDisable(DateTime? startTime) {
      for (int i = 0; i < disabledReservation.length; i++) {
        if (disabledReservation[i] == startTime) {
          return true;
        }
      }
      return false;
    }

    List<UserReservationData> userReservation = [
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '12345'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '1234'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '123'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
      UserReservationData(
          startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
    ];

    int countNumOfReservation(DateTime? startTime) {
      int num = 0;
      for (int i = 0; i < userReservation.length; i++) {
        if (startTime == userReservation[i].startTime) {
          num++;
        }
      }
      return num;
    }

    bool isTheSameDay(DateTime day) {
      if (DateFormat('EEE').format(day).substring(0, 3) ==
          DateFormat('EEE').format(now).substring(0, 3)) return true;
      return false;
    }

    final List<ReservationData> reservationDB = [];

    for (int i = 0; i < _reservation.length; i++) {
      Map<String, dynamic> reservationData =
          _reservation[i].data() as Map<String, dynamic>;

      DateTime startTime = reservationData['startTime'].toDate();
      DateTime endTime = reservationData['endTime'].toDate();
      int capacity = reservationData['capacity'];

      if ((isDisableMenu &&
              !isTimeSlotExpired(DateTime(now.year, now.month, now.day,
                  endTime.hour, endTime.minute, endTime.second)) &&
              isTheSameDay(startTime)) ||
          (!isDisableMenu &&
              !isTimeSlotExpired(DateTime(now.year, now.month, now.day,
                  endTime.hour, endTime.minute, endTime.second)) &&
              !isDisable(DateTime(
                now.year,
                now.month,
                now.day,
                startTime.hour,
                startTime.minute,
                startTime.second,
              )) &&
              countNumOfReservation(startTime) != 4 &&
              isTheSameDay(startTime))) {
        reservationDB.add(
          ReservationData(
            startTime: startTime,
            endTime: endTime,
            capacity: capacity,
          ),
        );
      }
    }

    reservationDB.sort((a, b) => a.startTime!.compareTo(b.startTime!));

    if (selectedTimeSlots.isEmpty) {
      selectedTimeSlots = List.generate(reservationDB.length, (index) => false);
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Use a Stack widget to position the arrow button on top of the image
            Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 240,
                      color: const Color(0xFF808080),
                    ),
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            CircularProgressIndicator(color: Color(0xFFE17325)),
                      ),
                    ),
                    Image.network(
                      _imgUrl,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE17325),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                            fixedSize: const Size.fromRadius(25),
                          ),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 200),
                  ),
                ),
              ],
            ),

            Stack(
              children: [
                Positioned(
                  left: 25,
                  child: _zoneName.isEmpty
                      ? Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 216, 216, 216),
                          highlightColor:
                              const Color.fromRGBO(173, 173, 173, 0.824),
                          child: Container(
                            width: 150,
                            height: 30.0,
                            color: Colors.white,
                          ))
                      : Text(
                          _zoneName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            height: 1.5, // 39/26 = 1.5
                            color: Color(0xFFE17325),
                          ),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0x99000000),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: _locationName.isEmpty
                            ? Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 216, 216, 216),
                                highlightColor:
                                    const Color.fromRGBO(173, 173, 173, 0.824),
                                child: Container(
                                  width: double.infinity,
                                  height: 10.0,
                                  color: Colors.white,
                                ))
                            : RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5, // 21/14 = 1.5
                                    color: Color(0x99000000),
                                    letterSpacing: 0,
                                  ),
                                  children: [
                                    TextSpan(text: '${parts[0]} '),
                                    TextSpan(
                                        text: parts.sublist(1).join(' - ')),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 100),
                    ],
                  ),
                ),
                if (hasRole) ...[
                  Positioned(
                    right: 10,
                    child: SizedBox(
                      width: 70.0,
                      height: 70.0,
                      child: IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: isDisableMenu
                                ? const Color(0xFFCC0019)
                                : const Color(0xFFE17325),
                            radius: 35.0,
                            child: const Icon(
                              Icons.swap_horiz_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (isDisableMenu) {
                            // If isDisableMenu is true, disable the menu and update the widget state
                            _getReservationData().then((_) {
                              setState(() {
                                isDisableMenu = false;
                                _selectedDateIndex = _selectedDateIndex > 6
                                    ? 0
                                    : _selectedDateIndex;
                                _selectedTimeSlot = 0;
                                _isReserved = false;
                                selectedTimeSlots = [];
                                timeHasLoaded = true;
                                key = UniqueKey();
                              });
                            }).catchError((error) {
                              // Handle any errors that occurred while fetching the reservation data
                              log('Error fetching reservation data: $error');
                            });
                          } else {
                            // If isDisableMenu is false, enable the menu and update the widget state
                            _getReservationData().then((_) {
                              setState(() {
                                isDisableMenu = true;
                                _selectedTimeSlot = 0;
                                _isReserved = false;
                                timeHasLoaded = true;
                                selectedTimeSlots = [];
                                key = UniqueKey();
                              });
                            }).catchError((error) {
                              // Handle any errors that occurred while fetching the reservation data
                              log('Error fetching reservation data: $error');
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 65,
                    child: Row(
                      children: [
                        Text(isDisableMenu ? 'Staff' : 'User',
                            style: const TextStyle(
                              fontSize: 13, fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.5, // 21/14 = 1.5
                              letterSpacing: 0,
                            )),
                        Icon(isDisableMenu
                            ? Icons.admin_panel_settings_outlined
                            : Icons.person_2_outlined)
                      ],
                    ),
                  )
                ]
              ],
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DateList(
                    isDisableMenu: isDisableMenu,
                    selectedIndex: _selectedDateIndex,
                    onSelected: (index) => (index != _selectedDateIndex)
                        ? _getReservationData().then((_) {
                            setState(() {
                              _selectedDateIndex = index;
                              _selectedTimeSlot = 0;
                              _isReserved = false;
                              timeHasLoaded = true;
                              selectedTimeSlots = [];
                              key = UniqueKey();
                            });
                          })
                        : null,
                    hasRole: hasRole,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: timeHasLoaded
                        ? isDisableMenu
                            ? TimeSlotDisable(
                                key: key,
                                userReservation: userReservation,
                                countNumOfReservation: countNumOfReservation,
                                reservationDB: reservationDB,
                                selectedTimeSlots: selectedTimeSlots,
                                disabledReservation: disabledReservation,
                                isDisable: isDisable,
                                onChanged: (int index, bool? value) {
                                  setState(() {
                                    selectedTimeSlots[index] = value;
                                  });
                                },
                              )
                            : TimeSlotReserve(
                                key: key,
                                countNumOfReservation: countNumOfReservation,
                                reservationDB: reservationDB,
                                disabledReservation: disabledReservation,
                                userReservation: userReservation,
                                selectedDateIndex: _selectedDateIndex,
                                selectedTimeSlot: _selectedTimeSlot,
                                isReserved: _isReserved,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTimeSlot = value!;
                                    _isReserved = false;
                                  });
                                },
                              )
                        : const TimeSlotLoading(),
                  ),
                  if (reservationDB.isEmpty && timeHasLoaded) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.event_busy,
                                  size: 100, color: Color(0x99000000)),
                              SizedBox(height: 20),
                              Text(
                                'Sorry, we don\'t have any',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5, // 21/14 = 1.5
                                  color: Color(0x99000000),
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                'reservations available for this date.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5, // 21/14 = 1.5
                                  color: Color(0x99000000),
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.75),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_selectedDateIndex < 7 &&
                                reservationDB.isNotEmpty &&
                                countNumOfReservation(
                                        reservationDB[_selectedTimeSlot]
                                            .startTime) !=
                                    reservationDB[_selectedTimeSlot].capacity &&
                                !isDisable(reservationDB[_selectedTimeSlot]
                                    .startTime) &&
                                !isDisableMenu)
                              ReserveButton(
                                isReserved: _isReserved,
                                onPressed: () {
                                  if (_isReserved) {
                                    showDialog(
                                      context: context,
                                      barrierColor:
                                          Colors.white.withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                children: const [
                                                  SizedBox(height: 40),
                                                  Text(
                                                    'Are you sure\nyou want to\ncancel ?',
                                                    style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFCC0019),
                                                      height: 1.3,
                                                      letterSpacing: 0.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 30),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 84,
                                                        height: 43,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _isReserved =
                                                                  false;
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                              const Color(
                                                                  0xFF009900),
                                                            ),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                              Colors.white,
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20.0,
                                                              height: 1.2,
                                                              letterSpacing:
                                                                  0.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 34.0),
                                                      SizedBox(
                                                        width: 84,
                                                        height: 43,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                              const Color(
                                                                  0xFFCC0019),
                                                            ),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                              Colors.white,
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20.0,
                                                              height: 1.2,
                                                              letterSpacing:
                                                                  0.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      _isReserved = true;
                                    });
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      barrierColor:
                                          Colors.white.withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 60),
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                  ),
                                                  child: const Icon(Icons.check,
                                                      color: Colors.white,
                                                      size: 80),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Success!',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                    height: 1.3,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 60),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                              ),
                            if (reservationDB.isNotEmpty &&
                                    isDisable(reservationDB[_selectedTimeSlot]
                                        .startTime) ||
                                (isDisableMenu == true &&
                                    selectedTimeSlots
                                        .every((element) => element == false) &&
                                    reservationDB.any((reservation) {
                                      return disabledReservation
                                          .contains(reservation.startTime);
                                    }))) ...[
                              const EditButton(),
                              const EnableButton(),
                            ] else if (!selectedTimeSlots
                                    .every((element) => element == false) &&
                                isDisableMenu == true) ...[
                              DisableButton(
                                  isDisableMenu: isDisableMenu,
                                  selectedTimeSlots: selectedTimeSlots),
                            ]
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
