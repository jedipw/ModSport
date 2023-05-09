import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/detail_view.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:modsport/utilities/reservation/error_message.dart';

import '../utilities/types.dart';

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final int _currentDrawerIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Booking> _book = [];
  bool _isBookLoaded = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _bookings() async {
    try {
      List<Booking> status = await FirebaseCloudStorage().getBookings();
      setState(() {
        _book = status;
        _isBookLoaded = true;
      });
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    if (mounted) {
      setState(
        () {
          _isError = true;
        },
      );
    }
  }

  Future<void> fetchData() async {
    await _bookings();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final validBookings =
        _book.where((booking) => booking.dateTime.isAfter(now)).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          !_isError
              ? _isBookLoaded
                  ? validBookings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.calendar_today,
                                size: 90.0,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'You haven\'t made any reservations.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(6, 125, 6, 6),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: validBookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              final booking = validBookings[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailView(
                                          zoneId: booking.zoneId,
                                          startDateTime: booking.dateTime,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: -3,
                                          blurRadius: 4,
                                          offset: const Offset(5,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking.zoneName,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0,
                                                    height: 20.0 / 13.0,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                  ),
                                                ),
                                                Text(
                                                  '${booking.date}\n${booking.time} - ${booking.endTime}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16.0,
                                                    height: 20.0 / 13.0,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            booking.isSuccessful
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 70.0,
                                                  )
                                                : const Icon(
                                                    Icons.cancel_rounded,
                                                    color: Colors.red,
                                                    size: 70.0,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(13, 35, 13, 0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: -3,
                                    blurRadius: 4,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          size: 70.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: -3,
                                    blurRadius: 4,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          size: 70.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: -3,
                                    blurRadius: 4,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          size: 70.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: -3,
                                    blurRadius: 4,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          size: 70.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: -3,
                                    blurRadius: 4,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              height: 13,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          size: 70.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.error, size: 100, color: primaryGray),
                              SizedBox(height: 20),
                              Text(
                                'Something went wrong!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5, // 21/14 = 1.5
                                  color: primaryGray,
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                'Please try again later.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5, // 21/14 = 1.5
                                  color: primaryGray,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          Stack(
            children: [
              Container(
                height: 125,
                decoration: const BoxDecoration(
                  color: primaryOrange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'STATUS',
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
                    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                      _scaffoldKey.currentState?.openEndDrawer();
                    } else {
                      _scaffoldKey.currentState?.openDrawer();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: const CircleBorder(),
                    fixedSize: const Size.fromRadius(25),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
