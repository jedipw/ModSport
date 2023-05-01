import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DetailView extends StatefulWidget {
  final String zoneId;
  final DateTime startDateTime;

  const DetailView({Key? key, required this.zoneId, required this.startDateTime})
      : super(key: key);

  @override
  _DetaiViewState createState() => _DetaiViewState();
}

class _DetaiViewState extends State<DetailView> {
  final int _currentDrawerIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userreservation')
            .where('userId', isEqualTo: userId)
            .where('zoneId', isEqualTo: widget.zoneId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final startDateTime = widget.startDateTime;
          final formattedDate =
              DateFormat('d MMM y').format(startDateTime); // Example date format
          final formattedTime =
              DateFormat('HH:mm').format(startDateTime); // Example time format
          final bool isSuccessful = data['isSuccessful'] ?? true;
          final String? disableReason = data['disableReason'];

          return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                    .collection('zone')
                    .doc(widget.zoneId)
                    .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final zoneData = snapshot.data!.data() as Map<String, dynamic>;
                    final String zoneName = zoneData['zoneName'];

          return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.check_circle,color: Colors.green,size: 150.0,),
                              Text('Successful', style: TextStyle(fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.0,
                                    height: 1.5,
                                    color: Colors.green,),),
                              Text('Your reservation has been successful!', style: TextStyle(fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    height: 1.5,),),
                              Text('Facility: $zoneName', style: TextStyle(fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    height: 1.5,),),
                              Text('Date: $formattedDate', style: TextStyle(fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    height: 1.5,),),
                              Text('Time: $formattedTime', style: TextStyle(fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    height: 1.5,),),
              if (!isSuccessful && disableReason != null)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('disable')
                      .where('userId', isEqualTo: userId)
                      .where('zoneId', isEqualTo: widget.zoneId)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final disableData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    final String disableReason = disableData['disableReason'];

                    return Text('due to $disableReason');
                  },
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
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                    fixedSize: const Size.fromRadius(25),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
            
          );
        },
      );
    }));
  }
}