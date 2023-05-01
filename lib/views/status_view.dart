import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class Booking {
  final String zone;
  final String date;
  final String time;
  final DateTime dateTime;
  final bool isSuccessful;

  Booking({
    required this.zone,
    required this.date,
    required this.time,
    required this.dateTime,
    required this.isSuccessful,
  });
}

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final int _currentDrawerIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  

  @override
  Widget build(BuildContext context) {
    
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userreservation').where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Booking> bookings = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final startDateTime = DateTime.fromMillisecondsSinceEpoch(
                data['startDateTime'].millisecondsSinceEpoch);
            final formattedDate = DateFormat('d MMM y')
                .format(startDateTime); // Example date format
            final formattedTime = DateFormat('HH:mm')
                .format(startDateTime); // Example time format
            return Booking(
              zone: data['zoneId'],
              date: formattedDate,
              time: formattedTime,
              dateTime: startDateTime,
              isSuccessful: data['isSuccessful'],
            );
          }).toList();

          return Stack(
            children: [
          
              Padding(
                padding: const EdgeInsets.fromLTRB(6,125,6,6.0),
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final booking = bookings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailView(
                              zoneId: booking.zone,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          booking.zone,
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
                                          '${booking.date}\n${booking.time}',
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
                                booking.isSuccessful
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 60.0,
                                      )
                                    : const Icon(
                                        Icons.cancel_rounded,
                                        color: Colors.red,
                                        size: 60.0,
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
          );
        },
      ),
    );
  }
}
