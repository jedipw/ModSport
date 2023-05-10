import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/reservation/zone_img.dart';
import 'package:modsport/utilities/reservation/zone_name.dart';
import 'package:modsport/utilities/types.dart';

import '../services/cloud/cloud_storage_exceptions.dart';





class DetailView extends StatefulWidget {
  final String zoneId;
  const DetailView({Key? key, required this.zoneId, required DateTime startDateTime}) : super(key: key);

  @override
  State<DetailView> createState() => _DetaiViewState();
}

class _DetaiViewState extends State<DetailView> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;


  final int _currentDrawerIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  String _imgUrl = '';
  String _locationName = '';
  String _locationId = '';
  String _zoneName = '';

  int _selectedDateIndex = 0;
  int _selectedTimeSlot = 0;

  double marginValue = 210.0;

  bool _hasRole = false;
  bool _isReserved = false;
  bool _isSwipingUp = false;
  bool _isReservationLoaded = false;
  bool _isZoneLoaded = false;
  bool _isLocationLoaded = false;
  bool _isDisableReservationLoaded = false;
  bool _isUserReservationLoaded = false;
  bool _isReservedLoaded = false;
  bool _isReservationIndexLoaded = false;
  bool _isReservationIdLoaded = true;
  bool _isHasRoleLoaded = false;
  bool _isDisableMenu = false;
  bool _isError = false;

  List<String> _reservationIds = [];
  List<String> _disableIds = [];
  List<bool?> _selectedTimeSlots = [];
  List<ReservationData> _reservations = [];
  List<DisableData> _disabledReservation = [];
  List<UserReservationData> _userReservation = [];

  List<Booking> _bookdetail = [];
  bool _isBookLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void handleError() {
    if (mounted) {
      setState(
        () {
          _isError = true;
        },
      );
    }
  }

  Future<void> fetchData() async {
    await _getBookingDetail();
  }



  Future<void> _getZoneData() async {
    try {
      // Get the zone data
      ZoneData zoneData = await FirebaseCloudStorage().getZone(widget.zoneId);
      
      String locationId = zoneData.locationId;
      String zoneName = zoneData.zoneName;
      String imgUrl = zoneData.imgUrl;

      // Update the state
      if (mounted) {
        setState(
          () {
            _imgUrl = imgUrl;
            _locationId = locationId;
            _zoneName = zoneName;
            _isZoneLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }


  Future<void> _getBookingDetail() async {
    try{
    String reservationId = '';
    BookingDetail? bookingDetail = await FirebaseCloudStorage().getBookingDetail(reservationId);
                                  await FirebaseCloudStorage().getBookingDetail(reservationId).then((detail) {
      setState(() {
        bookingDetail = detail;
      });});
     } catch (e) {
      handleError();
    }
  }

BookingDetail? bookingDetail;

////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    bool isEverythingLoaded() {
      return _isHasRoleLoaded &&
          _isReservationLoaded &&
          _isZoneLoaded &&
          _isLocationLoaded &&
          _isDisableReservationLoaded &&
          _isUserReservationLoaded &&
          _isReservationIdLoaded &&
          _isReservedLoaded &&
          _isReservationIndexLoaded;
    }
    BookingDetail? bookingDetail;

return Scaffold(
  key: _scaffoldKey,
  drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
  body: Container(
    color: Colors.white,
    child: Stack(
      children: [
        ZoneImg(isError: _isError, imgUrl: _imgUrl),
        AnimatedContainer(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Colors.white,
          ),
          duration: const Duration(milliseconds: 100),
          margin: EdgeInsets.only(top: marginValue),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 10),
                child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Positioned(
                                top: 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      bookingDetail?.isSuccessful == null ? Icons.check_circle : Icons.cancel_rounded,
                                      color: bookingDetail?.isSuccessful == null ? Colors.green : Colors.red,
                                      size: 150.0,
                                    ),
                                    Text(
                                      bookingDetail?.isSuccessful ?? false ? 'CANCELED' : 'SUCCESSFUL',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24.0,
                                        height: 1.5,
                                        color: bookingDetail?.isSuccessful ?? false ? Colors.red : Colors.green,
                                      ),
                                    ),
                                    if (bookingDetail?.isSuccessful ?? false)
                                      Text(
                                        'Reason: ${bookingDetail?.disableReason}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0,
                                          height: 1.5,
                                        ),
                                      ),
                                  Text(
                                    'Facility: $_zoneName',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      height: 1.5,
                                    ),
                                  ),
                                  Text(
                                    'Location: $_locationName',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      height: 1.5,
                                    ),
                                  ),
                                  Text(
                                    'Date: ${bookingDetail?.date}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      height: 1.5,
                                    ),
                                  ),
                                  Text(
                                    'Time: ${bookingDetail?.formattedTime} - ${bookingDetail?.formattedEndTime}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ],
    ),
  ),
])));
}
  //     body: StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //                 .collection('userreservation')
  //                 .where('userId', isEqualTo: userId)
  //                 .where('zoneId', isEqualTo: widget.zoneId)
  //                 .where('locationId', isEqualTo: widget.locationId)
  //                 .snapshots(),
  //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (!snapshot.hasData) {
  //                 return const Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               }

  //               final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
  //               final startDateTime = widget.startDateTime;
  //               final formattedDate = DateFormat('d MMM y').format(startDateTime);
  //               final formattedTime = DateFormat('HH:mm').format(startDateTime);
  //               final bool isSuccessful = data['isSuccessful'] ?? true;
  //               final String? disableReason = data['disableReason'];

  //               return StreamBuilder<DocumentSnapshot>(
  //                 stream: FirebaseFirestore.instance.collection('zone').doc(widget.zoneId).snapshots(),
  //                 builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //                   if (!snapshot.hasData) {
  //                     return const Center(
  //                       child: CircularProgressIndicator(),
  //                     );
  //                   }

  //                   final zoneData = snapshot.data!.data() as Map<String, dynamic>;
  //                   final String zoneName = zoneData['zoneName'];

  //                   return StreamBuilder<DocumentSnapshot>(
  //                     stream: FirebaseFirestore.instance.collection('location').doc(widget.locationId).snapshots(),
  //                     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //                       if (!snapshot.hasData) {
  //                         return const Center(
  //                           child: CircularProgressIndicator(),
  //                         );
  //                       }

  //                       final locationData = snapshot.data!.data() as Map<String, dynamic>;
  //                       final String locationName = locationData['locationName'];

  //         return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: [
  //                             Icon(Icons.check_circle,color: Colors.green,size: 150.0,),
  //                             Text('Successful', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 24.0,
  //                                   height: 1.5,
  //                                   color: Colors.green,),),
  //                             Text('Your reservation has been successful!', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Facility: $zoneName', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Location: $locationName', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),  
  //                             Text('Date: $formattedDate', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Time: $formattedTime', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),


  //             if (!isSuccessful && disableReason != null)
  //               StreamBuilder<QuerySnapshot>(
  //                 stream: FirebaseFirestore.instance
  //                     .collection('disable')
  //                     .where('userId', isEqualTo: userId)
  //                     .where('zoneId', isEqualTo: widget.zoneId)
  //                     .where('locationId', isEqualTo: widget.locationId)
  //                     .snapshots(),
  //                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //                   if (!snapshot.hasData) {
  //                     return const Center(
  //                       child: CircularProgressIndicator(),
  //                     );
  //                   }

  //                                 final disableData = snapshot.data!.docs.first
  //                                     .data() as Map<String, dynamic>;
  //                                 final String disableReason =
  //                                     disableData['disableReason'];

  //                   return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
  //                           children: [
  //                             Icon(Icons.cancel_rounded,color: Colors.red,size: 150.0,),
  //                             Text('Canceled', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 24.0,
  //                                   height: 1.5,
  //                                   color: Colors.red,),),
  //                             Text('Reason: $disableReason',style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Facility: $zoneName', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Location: $locationName', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),  
  //                             Text('Date: $formattedDate', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                             Text('Time: $formattedTime', style: TextStyle(fontFamily: 'Poppins',
  //                                   fontStyle: FontStyle.normal,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 12.0,
  //                                   height: 1.5,),),
  //                   ],);
  //                 },
  //               ),
  //           Stack(
  //           children: [
  //             Container(
  //               height: 125,
  //               decoration: const BoxDecoration(
  //                 color: primaryOrange,
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(20.0),
  //                   bottomRight: Radius.circular(20.0),
  //                 ),
  //               ),
  //               padding: const EdgeInsets.only(bottom: 17),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: const [
  //                   Text(
  //                     'STATUS',
  //                     style: TextStyle(
  //                       fontFamily: 'Poppins',
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 24.0,
  //                       height: 1.5,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               left: 5,
  //               top: 65,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: primaryOrange,
  //                   shape: const CircleBorder(),
  //                   padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
  //                   fixedSize: const Size.fromRadius(25),
  //                   elevation: 0,
  //                 ),
  //                 child: const Icon(Icons.arrow_back_ios, color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
            
  //         );
  //       },
  //     );
  //   }
  //   );
  // }
  // )