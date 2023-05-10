import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/constants/color.dart';

import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/utilities/reservation/location_name.dart';
import 'package:modsport/utilities/types.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class DetailView extends StatefulWidget {
  final String zoneId;
  final DateTime startDateTime;

  const DetailView(
      {Key? key, required this.zoneId, required this.startDateTime})
      : super(key: key);

  @override
  State<DetailView> createState() => _DetaiViewState();
}

class _DetaiViewState extends State<DetailView> {
  final int _currentDrawerIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isError = false;
  bool _isZoneLoaded = false;
  bool _isLocationLoaded = false;
  bool _isEndTimeLoaded = false;
  bool _isReasonLoaded = false;
  bool _isSuccessLoaded = false;
  bool _isSuccessful = false;

  String _zoneName = '';
  String _locationId = '';
  String _imgUrl = '';
  String _locationName = '';
  String reason = '';

  DateTime endTime = DateTime(2023);

  // Ensure that the data is fetched when entered this page for the first time.
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Ensure that the data is fetched when entered this page for the second time and onward.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  // Handle the error when data cannot be fetched from database
  void handleError() {
    if (mounted) {
      setState(
        () {
          _isError = true;
        },
      );
    }
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

  Future<void> _getLocationData() async {
    try {
      // Get the location data
      String locationData =
          await FirebaseCloudStorage().getLocation(_locationId);

      // Extract the locationName from the location data
      String locationName = locationData;

      // Update the state
      if (mounted) {
        setState(
          () {
            _locationName = locationName;
            _isLocationLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getEndTime() async {
    try {
      DateTime endTimeGet = await FirebaseCloudStorage()
          .getEndTime(widget.zoneId, widget.startDateTime);

      setState(() {
        endTime = endTimeGet;
        _isEndTimeLoaded = true;
      });
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getIsDisabled() async {
    try {
      String isDis = await FirebaseCloudStorage()
          .getIsDisabled(widget.zoneId, widget.startDateTime);

      setState(() {
        reason = isDis;
        _isReasonLoaded = true;
      });
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getIsSuccess() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      bool isSuccess = await FirebaseCloudStorage()
          .getIsSuccessful(widget.zoneId, widget.startDateTime, userId);

      setState(() {
        _isSuccessful = isSuccess;
        _isSuccessLoaded = true;
      });
    } catch (e) {
      handleError();
    }
  }

  // Fetch the data from the database
  Future<void> fetchData() async {
    await _getZoneData().then(
      (_) => _getLocationData()
          .then((_) => _getEndTime())
          .then((_) => _getIsDisabled())
          .then((_) => _getIsSuccess()),
    );
  }

  String getDayOrdinal(int day) {
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
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(widget.startDateTime);
    final formattedEndTime = DateFormat('HH:mm').format(endTime);

    bool isEverythingLoaded() {
      return _isZoneLoaded &&
          _isEndTimeLoaded &&
          _isLocationLoaded &&
          _isReasonLoaded &&
          _isSuccessLoaded;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Stack(
              children: [
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 216, 216, 216),
                  highlightColor: const Color.fromRGBO(173, 173, 173, 0.824),
                  child: Container(
                    width: double.infinity,
                    height: 240,
                    color: primaryGray,
                  ),
                ),
                _isError && _imgUrl.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: 240,
                        color: primaryGray,
                      )
                    : FutureBuilder(
                        future: Future(() {}),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Image.network(
                            _imgUrl,
                            height: 240,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Container();
                            },
                          );
                        },
                      ),
              ],
            ),
            Positioned(
              top: 215,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 270, 0, 40),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: !_isError
                    ? isEverythingLoaded()
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isSuccessful
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        size: 150,
                                        color: _isSuccessful
                                            ? primaryGreen
                                            : primaryRed,
                                      )
                                    ],
                                  ),
                                  Text(
                                    _isSuccessful ? 'Successful' : 'Canceled',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 26.0,
                                      color: _isSuccessful
                                          ? primaryGreen
                                          : primaryRed,
                                    ),
                                  ),
                                  _isSuccessful
                                      ? const Text(
                                          'Your reservation has been successful!',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                              color: primaryGray),
                                        )
                                      : Container(),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  !_isSuccessful
                                      ? reason.isNotEmpty
                                          ? SizedBox(
                                              width: 250,
                                              child: Text(
                                                'Reason: $reason',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  height: 27.0 /
                                                      18.0, // Adjust line height by dividing by font size
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.6),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: const [
                                                Text(
                                                  'This facility is now available ',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                    height: 27.0 /
                                                        18.0, // Adjust line height by dividing by font size
                                                  ),
                                                ),
                                                Text(
                                                  'to reserve again.',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                    height: 27.0 /
                                                        18.0, // Adjust line height by dividing by font size
                                                  ),
                                                )
                                              ],
                                            )
                                      : Container(),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 30),
                                  const Text(
                                    'Facility:    ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                  Text(
                                    _zoneName,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 19.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 30),
                                  const Text(
                                    'Location: ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      _locationName,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19.0,
                                        color: Color.fromRGBO(0, 0, 0, 0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 30),
                                  const Text(
                                    'Date:         ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '${getDayOrdinal(widget.startDateTime.day)} ${DateFormat('MMMM').format(widget.startDateTime)} ${widget.startDateTime.year}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19.0,
                                        color: Color.fromRGBO(0, 0, 0, 0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 30),
                                  const Text(
                                    'Time:         ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.8),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '$formattedTime-$formattedEndTime',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19.0,
                                        color: Color.fromRGBO(0, 0, 0, 0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 216, 216, 216),
                                highlightColor:
                                    const Color.fromRGBO(173, 173, 173, 0.824),
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 150,
                                                  height: 20),
                                              const SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 200,
                                                  height: 15),
                                              const SizedBox(height: 60),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 300,
                                                  height: 15),
                                              const SizedBox(height: 40),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 300,
                                                  height: 15),
                                              const SizedBox(height: 40),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 300,
                                                  height: 15),
                                              const SizedBox(height: 40),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  width: 300,
                                                  height: 15),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height - 330,
                        child: Column(
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
                      ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 65),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        shape: const CircleBorder(),
                        elevation: 5,
                        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                        fixedSize: const Size.fromRadius(25),
                      ),
                      child:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
