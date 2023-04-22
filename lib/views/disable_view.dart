import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/types.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

TextStyle topTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 22,
  height:
      1.5, // or line-height: 33px, which is equivalent to 1.5 times the font size
  color: Color.fromRGBO(0, 0, 0, 0.6),
);

TextStyle bottomTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 14,
  height:
      1.5, // or line-height: 21px, which is equivalent to 1.5 times the font size
  color: Color(0xFFDB611D),
);

// A stateless widget for the disable view
class DisableView extends StatefulWidget {
  const DisableView({
    super.key,
    required this.disableIds,
    required this.zoneId,
    required this.reservationIds,
    this.reason = '',
    required this.selectedDateIndex,
    required this.mode,
  });
  final List<String> disableIds;
  final String zoneId;
  final List<String> reservationIds;
  final String reason;
  final int selectedDateIndex;
  final String mode;

  @override
  State<DisableView> createState() => _DisableViewState();
}

class _DisableViewState extends State<DisableView> {
  String _zoneName = '';
  List<Map<String, dynamic>> reservationTimes = [];
  List<Timestamp> startTimes = [];
  TextEditingController reasonController = TextEditingController();
  int numOfCharacter = 0;

  bool _isZoneNameLoaded = false;
  bool _isReservationTimeLoaded = false;
  String _getDayOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  void initState() {
    super.initState();
    _getZoneName();
    _getReservationTime();
    reasonController = TextEditingController(text: widget.reason);
    numOfCharacter = reasonController.text.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getZoneName();
    _getReservationTime();
  }

  Future<void> _getZoneName() async {
    try {
      // Get the zone data
      ZoneData zoneData = await FirebaseCloudStorage().getZone(widget.zoneId);
      String zoneName = zoneData.zoneName;
      // Update the state
      setState(() {
        _zoneName = zoneName;
        _isZoneNameLoaded = true;
      });
    } catch (e) {
      log('Error fetching zone name: $e');
    }
  }

  Future<void> _getReservationTime() async {
    try {
      List<Map<String, dynamic>> reservation = await FirebaseCloudStorage()
          .getReservationTime(widget.reservationIds, widget.selectedDateIndex);
      setState(() {
        reservationTimes = reservation;
        startTimes = reservation
            .map((time) => Timestamp.fromDate(time["startTime"]))
            .toList();

        _isReservationTimeLoaded = true;
      });
    } catch (e) {
      log('Error fetching zone name: $e');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    reasonController.dispose();
    super.dispose();
  }

  // The build method returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A Center widget containing a Text widget
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Facility: ', style: topTextStyle),
                            _isZoneNameLoaded
                                ? Expanded(
                                    child: Text(_zoneName, style: topTextStyle),
                                  )
                                : Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 216, 216, 216),
                                    highlightColor: const Color.fromRGBO(
                                        173, 173, 173, 0.824),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: 150,
                                      height: 25.0,
                                      color: Colors.white,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('Date: ', style: topTextStyle),
                                _isReservationTimeLoaded
                                    ? Text(
                                        '${_getDayOrdinal(reservationTimes.first['startTime'].day)} ${DateFormat('MMMM').format(reservationTimes.first['startTime'])} ${reservationTimes[0]['startTime'].year}',
                                        style: topTextStyle)
                                    : Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(
                                            255, 216, 216, 216),
                                        highlightColor: const Color.fromRGBO(
                                            173, 173, 173, 0.824),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          width: 150,
                                          height: 25.0,
                                          color: Colors.white,
                                        )),
                              ],
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: ', style: topTextStyle),
                            _isReservationTimeLoaded
                                ? Column(
                                    children: reservationTimes
                                        .map((text) => Text(
                                            '${text['startTime'].toString().substring(11, 16)} - ${text['endTime'].toString().substring(11, 16)}',
                                            style: topTextStyle))
                                        .toList(),
                                    // Text(widget.reservationIds[index]);
                                  )
                                : Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 216, 216, 216),
                                    highlightColor: const Color.fromRGBO(
                                        173, 173, 173, 0.824),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: 150,
                                      height: 25.0,
                                      color: Colors.white,
                                    )),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Text('Reason:', style: topTextStyle),
                        TextFormField(
                          controller: reasonController,
                          autofocus: true,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              numOfCharacter = reasonController.text.length;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$numOfCharacter/250',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height:
                            1.5, // or line-height: 21px, which is equivalent to 1.5 times the font size
                        color: numOfCharacter < 10 || numOfCharacter > 250
                            ? const Color(0xFFDB611D)
                            : const Color(0xFF808080),
                      ),
                    ),
                    if (numOfCharacter < 10)
                      Text(
                        'Type at least 10 characters!',
                        style: bottomTextStyle,
                      ),
                    if (numOfCharacter > 250)
                      Text(
                        'Delete some characters!',
                        style: bottomTextStyle,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 55,
                width: 140,
                child: TextButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: numOfCharacter > 250 || numOfCharacter < 10
                            ? const Color(0xFF808080)
                            : const Color(0xFFE17325),
                        width: 3,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ), // Set the button background color to grey
                  onPressed: numOfCharacter > 250 || numOfCharacter < 10
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.white.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: EdgeInsets.zero,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(height: 40),
                                        Text(
                                          'Are you sure\nyou want to\n${widget.mode} ?',
                                          style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFCC0019),
                                            height: 1.3,
                                            letterSpacing: 0.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 30),
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
                                                onPressed: () async {
                                                  try {
                                                    // Call createDisableReservation to disable the selected time slots
                                                    widget.mode == 'disable' ? await FirebaseCloudStorage()
                                                        .createDisableReservation(
                                                          widget.zoneId,
                                                          reasonController.text,
                                                          startTimes,
                                                        )
                                                        .then((_) =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop())
                                                        .then((_) =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop())
                                                        .then((_) => showDialog(
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
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.8),
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
                                                            )) : await FirebaseCloudStorage()
                                                        .updateDisableReason(
                                                          widget.disableIds,
                                                          reasonController.text,
                                                        )
                                                        .then((_) =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop())
                                                        .then((_) =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop())
                                                        .then((_) => showDialog(
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
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.8),
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
                                                            ));
                                                  } catch (e) {
                                                    // Handle error
                                                    log('Error disabling reservation: $e');
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color(0xFF009900),
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.white,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
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
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color(0xFFCC0019),
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.white,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
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
                        },
                  child: Text(
                    "DONE", // Set the button text to "Disable"
                    style: TextStyle(
                      color: numOfCharacter > 250 || numOfCharacter < 10
                          ? const Color(0xFF808080)
                          : const Color(0xFFE17325),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Stack(children: [
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: Color(0xFFE17325),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'DISABLE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 5,
            top: 65,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE17325),
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                shape: const CircleBorder(),
                fixedSize: const Size.fromRadius(25),
                elevation: 0,
              ),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ]),
      ]),
    );
  }
}
