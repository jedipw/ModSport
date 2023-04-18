// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:modsport/utilities/reservation/date_list.dart';
import 'package:modsport/utilities/reservation/edit_button.dart';
import 'package:modsport/utilities/reservation/enable_button.dart';
import 'package:modsport/utilities/reservation/time_slot_disable.dart';
import 'package:modsport/utilities/reservation/time_slot_reserve.dart';
import 'package:modsport/utilities/reservation/reserve_button.dart';
import 'package:modsport/utilities/reservation/disable_button.dart';
import 'package:modsport/utilities/reservation/typeclass.dart';

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
  int selectedTimeSlot = -1;
  bool isDisableMenu = false;
  List<bool?> selectedTimeSlots = [];
  Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    String zoneName =
        widget.zoneId == '123456' ? 'Badminton Court 1' : 'Unknown Court';
    String facilityName =
        'King Mongkut\'s 190th Anniversary Memorial Building - 3rd Floor';
    List<String> parts = facilityName.split(RegExp(r'\s+(?=-\s)'));

    final DateTime now = DateTime.now().add(Duration(days: _selectedDateIndex));
    // A list of time slots as TimeSlotData objects
    bool isTimeSlotExpired(DateTime endTime) {
      final DateTime now = DateTime.now();
      return now.isAfter(endTime);
    }

    final List<ReservationData> reservationDB = [
      if (!isTimeSlotExpired(DateTime(now.year, now.month, now.day, 9, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 9),
          endTime: DateTime(now.year, now.month, now.day, 9, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 10, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 10),
          endTime: DateTime(now.year, now.month, now.day, 10, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 11, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 11),
          endTime: DateTime(now.year, now.month, now.day, 11, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 12, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 12),
          endTime: DateTime(now.year, now.month, now.day, 12, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 13, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 13),
          endTime: DateTime(now.year, now.month, now.day, 13, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 14, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 14),
          endTime: DateTime(now.year, now.month, now.day, 14, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 15, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 15),
          endTime: DateTime(now.year, now.month, now.day, 15, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 16, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 16),
          endTime: DateTime(now.year, now.month, now.day, 16, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 17, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 17),
          endTime: DateTime(now.year, now.month, now.day, 17, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 18, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 18),
          endTime: DateTime(now.year, now.month, now.day, 18, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 19, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 19),
          endTime: DateTime(now.year, now.month, now.day, 19, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 20, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 20),
          endTime: DateTime(now.year, now.month, now.day, 20, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 21, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 21),
          endTime: DateTime(now.year, now.month, now.day, 21, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 22, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 22),
          endTime: DateTime(now.year, now.month, now.day, 22, 59, 59),
          capacity: 4,
        ),
      if (!isTimeSlotExpired(
          DateTime(now.year, now.month, now.day, 23, 59, 59)))
        ReservationData(
          startTime: DateTime(now.year, now.month, now.day, 23),
          endTime: DateTime(now.year, now.month, now.day, 23, 59, 59),
          capacity: 4,
        ),
    ];

    List<DateTime> disabledReservation = [
      DateTime(2023, 4, 18, 15, 0, 0),
      DateTime(2023, 4, 18, 16, 0, 0),
      DateTime(2023, 4, 18, 18, 0, 0),
    ];

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

    bool isDisable(DateTime startTime) {
      for (int i = 0; i < disabledReservation.length; i++) {
        if (disabledReservation[i] == startTime) {
          return true;
        }
      }
      return false;
    }

    int countNumOfReservation(DateTime startTime) {
      int num = 0;
      for (int i = 0; i < userReservation.length; i++) {
        if (startTime == userReservation[i].startTime) {
          num++;
        }
      }
      return num;
    }

    int getFirstTimeSlot() {
      for (int i = 0; i < reservationDB.length; i++) {
        for (int j = 0; j < disabledReservation.length; j++) {
          if (reservationDB[i]
                  .startTime
                  .isAtSameMomentAs(disabledReservation[j]) ||
              countNumOfReservation(reservationDB[i].startTime) ==
                  reservationDB[i].capacity) {
            break;
          } else if (j == disabledReservation.length - 1) {
            return i;
          }
        }
      }
      return 0;
    }

    if (selectedTimeSlot == -1) {
      selectedTimeSlot = getFirstTimeSlot();
    }

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
                Image.asset(
                  'assets/images/badmintoncourt1.jpg',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    Text(
                      zoneName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        height: 1.5, // 39/26 = 1.5
                        color: Color(0xFFE17325),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0x99000000),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: RichText(
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
                        TextSpan(text: parts.sublist(1).join(' - ')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
            if (hasRole) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          isDisableMenu == true
                              ? setState(() {
                                  isDisableMenu = false;
                                  selectedTimeSlots = [];
                                })
                              : null;
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: isDisableMenu
                              ? Colors.white
                              : const Color(0xFFE17325),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE17325),
                          ),
                        ),
                        child: Text(
                          'RESERVE',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: isDisableMenu
                                ? const Color(0xFFE17325)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          isDisableMenu == false
                              ? setState(() {
                                  isDisableMenu = true;
                                })
                              : null;
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: !isDisableMenu
                              ? Colors.white
                              : const Color(0xFFE17325),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE17325),
                          ),
                        ),
                        child: Text(
                          'DISABLE',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: isDisableMenu
                                ? Colors.white
                                : const Color(0xFFE17325),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DateList(
                    selectedIndex: _selectedDateIndex,
                    onSelected: (index) => (index != _selectedDateIndex)
                        ? setState(() {
                            _selectedDateIndex = index;
                            selectedTimeSlot = -1;
                            _isReserved = false;
                            selectedTimeSlots = [];
                            key = UniqueKey();
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
                    child: isDisableMenu
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
                            isDisable: isDisable,
                            hasRole: hasRole,
                            countNumOfReservation: countNumOfReservation,
                            reservationDB: reservationDB,
                            disabledReservation: disabledReservation,
                            userReservation: userReservation,
                            selectedDateIndex: _selectedDateIndex,
                            selectedTimeSlot: selectedTimeSlot,
                            onChanged: (value) {
                              setState(() {
                                selectedTimeSlot = value!;
                                _isReserved = false;
                              });
                            },
                          ),
                  ),
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
                              countNumOfReservation(
                                      reservationDB[selectedTimeSlot]
                                          .startTime) !=
                                  reservationDB[selectedTimeSlot].capacity &&
                              !isDisable(
                                  reservationDB[selectedTimeSlot].startTime) &&
                              !isDisableMenu)
                            ReserveButton(
                              isReserved: _isReserved,
                              onPressed: () {
                                if (_isReserved) {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.white.withOpacity(0.5),
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
                                                    fontWeight: FontWeight.bold,
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 84,
                                                      height: 43,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _isReserved = false;
                                                          });
                                                          Navigator.of(context)
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
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20.0,
                                                            height: 1.2,
                                                            letterSpacing: 0.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 34.0),
                                                    SizedBox(
                                                      width: 84,
                                                      height: 43,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20.0,
                                                            height: 1.2,
                                                            letterSpacing: 0.0,
                                                            color: Colors.white,
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
                                    barrierColor: Colors.white.withOpacity(0.5),
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
                                                decoration: const BoxDecoration(
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
                          if (hasRole) ...[
                            if (isDisable(reservationDB[selectedTimeSlot]
                                    .startTime) ||
                                (isDisableMenu == true &&
                                    selectedTimeSlots
                                        .every((element) => element == false) &&
                                    reservationDB.any((reservation) {
                                      return disabledReservation
                                          .contains(reservation.startTime);
                                    }))) ...[
                              EditButton(isDisableMenu: isDisableMenu),
                              EnableButton(isDisableMenu: isDisableMenu),
                            ] else if (!selectedTimeSlots
                                    .every((element) => element == false) ||
                                isDisableMenu == false) ...[
                              DisableButton(
                                  isDisableMenu: isDisableMenu,
                                  selectedTimeSlots: selectedTimeSlots),
                            ]
                          ]
                        ],
                      ),
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
