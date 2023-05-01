// Import firebase cloud storage
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/reservation_view.dart';
import 'package:shimmer/shimmer.dart';

import '../utilities/types.dart';
import 'dart:developer';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// class Faciliy {
//   final image;
//   final name;
//   final location;

//   Faciliy(this.image, this.name, this.location);
// }

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _currentDrawerIndex =
      0; // Define current selected index of the drawer
  List<ZoneData> _zoneList = [];
  bool isPushPinClicked = false;
  bool _isZoneLoaded = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> _getZonesData() async {
    try {
      List<ZoneData> zones = await FirebaseCloudStorage().getAllZones();
      log(zones.toString());
      setState(() {
        _zoneList = zones;
        _isZoneLoaded = true;
      });
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    // Handle the error in a way that makes sense for your app
  }

  Future<void> fetchData() async {
    await _getZonesData();
  }

  // List<Faciliy> facilities = [
  //   Faciliy(
  //       'https://www.kmutt.ac.th/wp-content/uploads/2020/09/MG_0489-scaled.jpg',
  //       'Badminton',
  //       '160th year kmutt')
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 230),
                  // Start writing your code here

                  _isZoneLoaded
                      ? Container(
                          padding: EdgeInsets.only(top: 35),
                          child: Column(
                            children: _zoneList
                                .map((e) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReservationView(
                                                    zoneId: e.zoneId),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 293,
                                        padding: const EdgeInsets.fromLTRB(
                                            35, 0, 35, 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 4))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Stack(
                                            children: [
                                              Stack(
                                                children: [
                                                  Shimmer.fromColors(
                                                    baseColor:
                                                        const Color.fromARGB(
                                                            255, 216, 216, 216),
                                                    highlightColor:
                                                        const Color.fromRGBO(
                                                            173,
                                                            173,
                                                            173,
                                                            0.824),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: primaryGray,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        30),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        30)),
                                                      ),
                                                      width: double.infinity,
                                                      height: 164,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 164,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      ),
                                                      child: e.imgUrl.isEmpty
                                                          ? Container(
                                                              color:
                                                                  primaryGray,
                                                            )
                                                          : FutureBuilder(
                                                              future:
                                                                  Future(() {}),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot
                                                                      snapshot) {
                                                                return Image
                                                                    .network(
                                                                  e.imgUrl,
                                                                  height: 164,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          exception,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Container();
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(30),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            e.zoneName,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 22.0,
                                                              color:
                                                                  primaryOrange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Transform
                                                                .rotate(
                                                              angle: 45 *
                                                                  3.14 /
                                                                  180,
                                                              child: Icon(
                                                                Icons
                                                                    .push_pin_outlined,
                                                                size: 24,
                                                                color: isPushPinClicked
                                                                    ? primaryOrange
                                                                    : primaryGray,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            size: 16,
                                                            color: primaryGray,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          SizedBox(
                                                            width:
                                                                200, // set a smaller width to fit the location in the card
                                                            child:
                                                                FutureBuilder<
                                                                    String>(
                                                              future: FirebaseCloudStorage()
                                                                  .getLocation(e
                                                                      .locationId),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          String>
                                                                      snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216),
                                                                    highlightColor:
                                                                        const Color.fromRGBO(
                                                                            173,
                                                                            173,
                                                                            173,
                                                                            0.824),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            primaryGray,
                                                                      ),
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          24,
                                                                    ),
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  return const Text(
                                                                      'Location not found');
                                                                } else {
                                                                  return Text(
                                                                    snapshot.data ??
                                                                        '',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          11.5,
                                                                      color:
                                                                          primaryGray,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.fromLTRB(30, 35, 30, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 257,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 216, 216, 216),
                                    highlightColor: const Color.fromRGBO(
                                        173, 173, 173, 0.824),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30)),
                                            color: Colors.white,
                                          ),
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 200,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 257,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 216, 216, 216),
                                    highlightColor: const Color.fromRGBO(
                                        173, 173, 173, 0.824),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30)),
                                            color: Colors.white,
                                          ),
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 200,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 257,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 216, 216, 216),
                                    highlightColor: const Color.fromRGBO(
                                        173, 173, 173, 0.824),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30)),
                                            color: Colors.white,
                                          ),
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 200,
                                                height: 16,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 190),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              // button to filter
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    ['All', 'Badminton', 'Football', 'Valleyball', 'Peathong']
                        .map((e) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Do something when the button is pressed
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                    color: primaryGray,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 190,
                decoration: const BoxDecoration(
                  color: primaryOrange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'KMUTT RESERVATION',
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
                    const SizedBox(height: 25),
                    Container(
                        padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xffE17325),
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ))
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
