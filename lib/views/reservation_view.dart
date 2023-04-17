// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:modsport/utilities/reservation/date_list.dart';
import 'package:modsport/utilities/reservation/time_slot.dart';
import 'package:modsport/utilities/reservation/reserve_button.dart';
import 'package:modsport/utilities/reservation/disable_button.dart';

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

  @override
  Widget build(BuildContext context) {
    String zoneName =
        widget.zoneId == '123456' ? 'Badminton Court 1' : 'Unknown Court';
    String facilityName =
        'King Mongkut\'s 190th Anniversary Memorial Building - 3rd Floor';
    List<String> parts = facilityName.split(RegExp(r'\s+(?=-\s)'));

    final DateTime now =
        DateTime.now().add(Duration(days: _selectedDateIndex));
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
      DateTime(2023, 4, 17, 14, 0, 0),
      DateTime(2023, 4, 19, 16, 0, 0),
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
    ];

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
                            _selectedTimeSlot = 0;
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
                    child: TimeSlot(
                      reservationDB: reservationDB,
                      disabledReservation: disabledReservation,
                      userReservation: userReservation,
                      selectedDateIndex: _selectedDateIndex,
                      selectedTimeSlot: _selectedTimeSlot,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeSlot = value!;
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
                          if (_selectedDateIndex < 7)
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
                            const DisableButton(),
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
