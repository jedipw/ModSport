// Importing necessary packages and files
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/reservation/date_list.dart';
import 'package:modsport/utilities/reservation/edit_button.dart';
import 'package:modsport/utilities/reservation/enable_button.dart';
import 'package:modsport/utilities/reservation/time_slot_disable.dart';
import 'package:modsport/utilities/reservation/time_slot_loading.dart';
import 'package:modsport/utilities/reservation/time_slot_reserve.dart';
import 'package:modsport/utilities/reservation/reserve_button.dart';
import 'package:modsport/utilities/reservation/disable_button.dart';
import 'package:modsport/utilities/types.dart';
import 'package:shimmer/shimmer.dart';

const bool hasRole = true;
const int numOfUserDay = 7;

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
  bool _isTimeFirstLoaded = true;
  bool _isTimeLoaded = false;
  bool _isZoneLoaded = false;
  bool _isLocationLoaded = false;
  bool _isDisableReservationLoaded = false;
  bool _isUserReservationLoaded = false;
  List<bool?> selectedTimeSlots = [];
  Key key = UniqueKey();
  String _imgUrl = 'https://i.imgur.com/AoYPnKY.png';
  String _locationName = '';
  String _locationId = '';
  String _zoneName = '';
  List<ReservationData> _reservations = [];
  List<DisableData> disabledReservation = [];
  List<UserReservationData> userReservation = [];

  @override
  void initState() {
    super.initState();
    _getUserReservationData();
    _getDisableReservationData();
    _getLocationData();
    _getZoneData();
    _getReservationData().then((value) {
      setState(() {
        _isTimeLoaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserReservationData();
    _getDisableReservationData();
    _getLocationData();
    _getZoneData();
    _getReservationData();
  }

  Future<void> _getUserReservationData() async {
    try {
      List<UserReservationData> userRes =
          await FirebaseCloudStorage().getAllUserReservation(widget.zoneId);

      setState(() {
        userReservation = userRes;
        _isUserReservationLoaded = true;
      });
    } catch (e) {
      log('Error fetching user reservation data: $e');
    }
  }

  Future<void> _getDisableReservationData() async {
    try {
      List<DisableData> disable =
          await FirebaseCloudStorage().getDisableReservation(widget.zoneId);

      setState(() {
        disabledReservation = disable;
        _isDisableReservationLoaded = true;
      });
    } catch (e) {
      log('Error fetching disable data: $e');
    }
  }

  Future<void> _getReservationData() async {
    try {
      List<ReservationData> reservations = await FirebaseCloudStorage()
          .getReservation(widget.zoneId, isDisableMenu, _selectedDateIndex);
      log(reservations.length.toString());
      setState(() {
        _reservations = reservations;
        _isTimeLoaded = true;
        _isTimeFirstLoaded = false;
        if (selectedTimeSlots.isEmpty) {
          selectedTimeSlots =
              List.generate(reservations.length, (index) => false);
        }
      });
    } catch (e) {
      log('Error fetching reservation data: $e');
    }
  }

  Future<void> _getZoneData() async {
    try {
      // Get the zone data
      ZoneData zoneData = await FirebaseCloudStorage().getZone(widget.zoneId);
      String locationId = zoneData.locationId;
      String zoneName = zoneData.zoneName;

      // Update the state
      setState(() {
        _locationId = locationId;
        _zoneName = zoneName;
        _isZoneLoaded = true;
      });
    } catch (e) {
      log('Error fetching zone data: $e');
    }
  }

  Future<void> _getLocationData() async {
    try {
      await _getZoneData();
      // Get the location data
      LocationData locationData =
          await FirebaseCloudStorage().getLocation(_locationId);

      // Extract the imgUrl and locationName from the location data
      String imgUrl = locationData.imgUrl;
      String locationName = locationData.locationName;

      // Update the state with the imgUrl
      setState(() {
        _imgUrl = imgUrl;
        _locationName = locationName;
        _isLocationLoaded = true;
      });
    } catch (e) {
      log('Error fetching location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> parts = _locationName.split(RegExp(r'\s+(?=-\s)'));

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

    // List<UserReservationData> userReservation = [
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 25, 17, 30, 0), userId: '12345'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '1234'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '123'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 16, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 17, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
    //   UserReservationData(
    //       startTime: DateTime(2023, 4, 18, 17, 0, 0), userId: '12'),
    // ];

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

    // final List<ReservationData> reservationDB = [];

    // for (int i = 0; i < _reservations.length; i++) {
    //   ReservationData reservationData = _reservations[i];

    //   DateTime? startTime = reservationData.startTime;
    //   DateTime? endTime = reservationData.endTime;
    //   int? capacity = reservationData.capacity;

    //   // if ((isDisableMenu) ||
    //   //     (!isDisableMenu && countNumOfReservation(startTime) != capacity)) {
    //   //   reservationDB.add(
    //   //     ReservationData(
    //   //       startTime: DateTime(
    //   //         now.year,
    //   //         now.month,
    //   //         now.day,
    //   //         startTime!.hour,
    //   //         startTime.minute,
    //   //         startTime.second,
    //   //       ),
    //   //       endTime: DateTime(
    //   //         now.year,
    //   //         now.month,
    //   //         now.day,
    //   //         endTime!.hour,
    //   //         endTime.minute,
    //   //         endTime.second,
    //   //       ),
    //   //       capacity: capacity,
    //   //     ),
    //   //   );
    //   // }
    // }

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
                  child: !_isZoneLoaded
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
                        child: !_isLocationLoaded
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
                              Icons.swap_horiz,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (isDisableMenu) {
                            setState(() {
                              _isTimeLoaded = false;
                              _isDisableReservationLoaded = false;
                              isDisableMenu = false;
                              selectedTimeSlots = [];
                            });
                            // If isDisableMenu is true, disable the menu and update the widget state
                            _getReservationData()
                                .then((_) => _getDisableReservationData())
                                .then((_) => _getUserReservationData())
                                .then((_) {
                              setState(() {
                                _selectedDateIndex =
                                    _selectedDateIndex > numOfUserDay - 1
                                        ? numOfUserDay - 1
                                        : _selectedDateIndex;
                                _selectedTimeSlot = 0;
                                _isReserved = false;

                                key = UniqueKey();
                              });
                            }).catchError((error) {
                              // Handle any errors that occurred while fetching the reservation data
                              log('Error fetching reservation data: $error');
                            });
                          } else {
                            setState(() {
                              _isTimeLoaded = false;
                              _isDisableReservationLoaded = false;
                              selectedTimeSlots = [];
                              isDisableMenu = true;
                            });
                            // If isDisableMenu is false, enable the menu and update the widget state
                            _getReservationData()
                                .then((_) => _getDisableReservationData())
                                .then((_) => _getUserReservationData())
                                .then((_) {
                              setState(() {
                                _selectedTimeSlot = 0;
                                _isReserved = false;

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

            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DateList(
                    numOfUserDay: numOfUserDay,
                    isDisableMenu: isDisableMenu,
                    selectedIndex: _selectedDateIndex,
                    onSelected: (index) {
                      if (index != _selectedDateIndex) {
                        setState(() {
                          _selectedDateIndex = index;
                          _isTimeLoaded = false;
                          selectedTimeSlots = [];
                          _isDisableReservationLoaded = false;
                        });
                        _getReservationData()
                            .then((_) => _getDisableReservationData())
                            .then((_) => _getUserReservationData())
                            .then((_) {
                          setState(() {
                            _selectedTimeSlot = 0;
                            _isReserved = false;

                            key = UniqueKey();
                          });
                        });
                      }
                    },
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
                    child: _isTimeLoaded &&
                            _isDisableReservationLoaded &&
                            _isUserReservationLoaded
                        ? isDisableMenu
                            ? TimeSlotDisable(
                                key: key,
                                userReservation: userReservation,
                                countNumOfReservation: countNumOfReservation,
                                reservation: _reservations,
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
                                reservation: _reservations,
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
                        : _isTimeFirstLoaded
                            ? const TimeSlotLoading()
                            : Container(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE17325),
                                  ),
                                ),
                              ),
                  ),
                  if (_reservations.isEmpty && _isTimeLoaded) ...[
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
                                _reservations.isNotEmpty &&
                                !isDisable(_reservations[_selectedTimeSlot]
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
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              barrierColor: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                                return Center(
                                                                  child:
                                                                      AlertDialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const SizedBox(
                                                                            height:
                                                                                60),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              100,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          child: const Icon(
                                                                              Icons.check,
                                                                              color: Colors.white,
                                                                              size: 80),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                        const Text(
                                                                          'Success!',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                Colors.black,
                                                                            height:
                                                                                1.3,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                60),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
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
                            if ((isDisableMenu == true &&
                                selectedTimeSlots
                                    .every((element) => element == false) &&
                                _reservations.any((reservation) {
                                  return _reservations.any((reservation) {
                                    return disabledReservation
                                        .map((disabledData) =>
                                            disabledData.startDateTime)
                                        .any((disabledDateTime) =>
                                            disabledDateTime.year ==
                                                reservation.startTime!.year &&
                                            disabledDateTime.month ==
                                                reservation.startTime!.month &&
                                            disabledDateTime.day ==
                                                reservation.startTime!.day &&
                                            disabledDateTime.hour ==
                                                reservation.startTime!.hour &&
                                            disabledDateTime.minute ==
                                                reservation.startTime!.minute &&
                                            disabledDateTime.second ==
                                                reservation.startTime!.second);
                                  });
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
