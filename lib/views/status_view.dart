import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/detail_view.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

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
    // Handle the error in a way that makes sense for your app
  }

  Future<void> fetchData() async {
    await _bookings();
  }

  

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: 

           Stack(
            children: [
          
              Padding(
                padding: const EdgeInsets.fromLTRB(6,125,6,6.0),
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _book.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = _book[index];
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
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                      
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            booking.zoneName,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20.0,
                                              height: 20.0 / 13.0,
                                              color: Color.fromRGBO(0, 0, 0, 0.7),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${booking.date}\n${booking.time} - ${booking.endTime}',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.0,
                                              height: 20.0 / 13.0,
                                              color: Color.fromRGBO(0, 0, 0, 0.7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                booking.isSuccessful
                                    ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 70.0,
                                        ),
                                    )
                                    : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                          size: 70.0,
                                        ),
                                    )
                              ]),
                        ),
                      ),
                    );
                  },
                ),
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
