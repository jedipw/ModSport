import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String zone;
  final String date;
  final String time;
  final bool isSuccessful;

  Booking({
    required this.zone,
    required this.date,
    required this.time,
    required this.isSuccessful,
  });
}

class StatusView extends StatelessWidget {
  final List<Booking> bookings = [
    Booking(
      zone: 'Badminton Court 1',
      date: '3th May 2023',
      time: '19.00 - 19.59',
      isSuccessful: true,
    ),
    Booking(
      zone: 'Volleyball Court 2',
      date: '5th May 2023',
      time: '18.00 - 18.59',
      isSuccessful: false,
    ),
  ];

  StatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              homeRoute,
              (route) => false,
            );
          },
          child: const Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              menuRoute,
              (route) => false,
            );
          },
          child: const Text(
            "Menu",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (BuildContext context, int index) {
            final booking = bookings[index];
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
              onTap: () => Navigator.pushNamed(context, detailRoute),
            );
          },
        ),
      ),
    );
  }
}
