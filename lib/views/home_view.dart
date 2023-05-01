// Import firebase cloud storage
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/reservation_view.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _getZonesData() async {
    try {
      List<ZoneData> zones = await FirebaseCloudStorage().getAllZones();
      log(zones.toString());
      setState(() {
        _zoneList = zones;
      });
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    // Handle the error in a way that makes sense for your app
  }

  Future<void> fetchData() async {
    await _getZonesData().then((_) => _getZonesData());
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
            child: Column(
              children: [
                const SizedBox(height: 230),
                // Start writing your code here
                SizedBox(
                  // button to filter
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      'All',
                      'Badminton',
                      'Football',
                      'Valleyball',
                      'Run',
                      'Peathong'
                    ]
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
                                    color: Color.fromARGB(124, 0, 0, 0),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Column(
                  children: _zoneList
                      .map((e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReservationView(
                                    zoneId: e.zoneId,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 356,
                              height: 257,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        e.imgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(30),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.zoneName,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 22.0,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Transform.rotate(
                                                  angle: -28 * 3.14 / 180,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isPushPinClicked =
                                                            !isPushPinClicked;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.push_pin,
                                                      size: 24,
                                                      color: isPushPinClicked
                                                          ? Colors.orange
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      e.locationId,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 12.0,
                                                        color: Color.fromARGB(
                                                            132, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
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
                )

                // Row(

                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all(
                //               primaryOrange)), // Set the button background color
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const ReservationView(
                //                 zoneId: 'TEHMJQbzdGplLBfcrZq0'),
                //           ),
                //         );
                //       },
                //       child: const Text(
                //         "Badminton Court 1",
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
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
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
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
