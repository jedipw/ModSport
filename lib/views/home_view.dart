//search ได้ list ได้
// Import firebase cloud storage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:modsport/views/reservation_view.dart';
import 'package:shimmer/shimmer.dart';

import '../services/cloud/cloud_storage_constants.dart';
import '../utilities/types.dart';
import 'dart:developer';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _currentDrawerIndex =
      0; // Define current selected index of the drawer
  String _searchText = '';
  // String _selectedCategory = 'All'; // initialize to 'All'

  List<ZoneData> _zoneList = [];
  List<String> _categoryList = [];
  List<bool> _pushPinClickedList = [];
  bool _isCategoryLoaded = false;
  bool isPinned = true;
  // bool _isPushPinClicked = false;
  bool _isZoneLoaded = false;
  bool _isSearching = false; //detect search bar
  int index = 0;
  late String
      _selectedCategory; // assume this state variable stores the currently selected category

  TextEditingController _searchController = TextEditingController();
  List<ZoneData> _foundZones = [];
  final ScrollController _scrollController = ScrollController();
  Map<String, bool> _pushPinClickedMap = {};

  @override
  void initState() {
    super.initState();
    _foundZones = _zoneList;
    fetchData();
    FirebaseCloudStorage().getPinnedZones().then((pinnedZones) {
    setState(() {
      _pushPinClickedList = pinnedZones.map((zoneId) => true).toList();
    });
  });
  FirebaseCloudStorage().getAllZones().then((zoneList) {
    setState(() {
      _zoneList = zoneList;
      if (_pushPinClickedList.isNotEmpty) {
        for (int i = 0; i < _pushPinClickedList.length; i++) {
          if (_pushPinClickedList[i]) {
            String pinnedZoneId = _zoneList[i].zoneId;
            int pinnedIndex = _zoneList.indexWhere((zone) => zone.zoneId == pinnedZoneId);
            ZoneData pinnedZone = _zoneList.removeAt(pinnedIndex);
            _zoneList.insert(0, pinnedZone);
          }
        }
      }
    });
  }).catchError((e) {
    // if (e is CouldNotFetchDataException) {
    //   // Handle exception
    // }
  });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

//For
  Future<void> _getZonesData() async {
    try {
      List<ZoneData> zones = await FirebaseCloudStorage().getAllZones();
      log(zones.toString());
      setState(() {
        _zoneList = zones;
        _isZoneLoaded = true;
        _foundZones = _zoneList;
        
        isPinned = false;
        // _isPushPinClicked = false;
      });
    } catch (e) {
      _handleError();
    }
  }

//For category
  Future<void> _getCategoriesData() async {
    try {
      List<String> categories = await FirebaseCloudStorage().getAllCategories();
      setState(() {
        _categoryList = categories;
        _isCategoryLoaded = true;
      });
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    // Handle the error in a way that makes sense for your app
  }

  Future<void> _getZoneToCategoriesData() async {
    try {
      List<DocumentSnapshot<Object?>> zoneToCategories =
          await FirebaseCloudStorage().getAllZoneToCategory();

      List<String> categories = zoneToCategories
          .map((doc) => doc.get("categoryName").toString())
          .toList();

      setState(() {
        _categoryList = categories;
        _isCategoryLoaded = true;
      });
    } catch (e) {
      _handleError();
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }
  
  

//For push pin
  // void _handlePushPinClick(int index) async {
  //   // Get the zone data for the clicked push pin
  //   ZoneData clickedZone = _zoneList[index];
  //   // Remove the clicked zone data from the list
  //   _zoneList.removeAt(index);
  //   // Add the clicked zone data back to the list at the beginning
  //   _zoneList.insert(0, clickedZone);
  //   // log("Hi: " + clickedZone.zoneName.toString());

  //   // Set the state to trigger a re-render of the list
  //   setState(() {});

  //   // Pin the zone in the database
  //   try {
  //     await FirebaseCloudStorage().pinZone(clickedZone.zoneId);
  //   } catch (e) {
  //     log("Could not pin zone: $e");
  //   }
  // }
 void _handlePushPinClick(String zoneId) {
  setState(() {
    _pushPinClickedMap[zoneId] = true;
    FirebaseCloudStorage().pinZone(zoneId);
    
    // find the index of the zone with the given id
    int index = _zoneList.indexWhere((zone) => zone.zoneId == zoneId);
    
    // remove the zone from the list
    ZoneData pinnedZone = _zoneList.removeAt(index);
    
    // insert the zone at the beginning of the list
    _zoneList.insert(0, pinnedZone);
    
    // update the list of pinned zones
    _pushPinClickedList.insert(0, true);
  });
}



  void _handleUnpinClick(String zoneId) {
    setState(() {
      _pushPinClickedMap[zoneId] = false;
      FirebaseCloudStorage().unpinZone(zoneId);
    });
  }

  


  Future<void> fetchData() async {
    await _getZonesData();
    await _getCategoriesData();
    // await _getZoneToCategoriesData();
    // await _getZoneToCategoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 230),

                  // Start writing your code here

                  _isZoneLoaded
                      ? Container(
                          padding: const EdgeInsets.only(top: 35),
                          child: Column(
                            children: _zoneList.asMap().entries.map((entry) {
                              //  bool _isPushPinClicked = false;
                              final index = entry.key;
                              final e = entry.value;

                              if (_pushPinClickedList.length <= index) {
                                // Set initial value of push pin clicked status for new items
                                _pushPinClickedList.add(false);
                              }
                              bool isPushPinClicked =
                                  _pushPinClickedList[index];
                              log(index.toString());
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReservationView(zoneId: e.zoneId),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 293,
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 4,
                                            offset: const Offset(0, 4))
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: const Color.fromARGB(
                                                  255, 216, 216, 216),
                                              highlightColor:
                                                  const Color.fromRGBO(
                                                      173, 173, 173, 0.824),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: primaryGray,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                          topLeft:
                                                              Radius.circular(
                                                                  30)),
                                                ),
                                                width: double.infinity,
                                                height: 164,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 164,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                                child: e.imgUrl.isEmpty
                                                    ? Container(
                                                        color: primaryGray,
                                                      )
                                                    : FutureBuilder(
                                                        future: Future(() {}),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          return Image.network(
                                                            e.imgUrl,
                                                            height: 164,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (BuildContext
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
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(30),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      e.zoneName,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 22.0,
                                                        color: primaryOrange,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _pushPinClickedMap[
                                                                  e.zoneId] =
                                                              _pushPinClickedMap[e
                                                                          .zoneId] ==
                                                                      null
                                                                  ? true
                                                                  : !_pushPinClickedMap[
                                                                      e.zoneId]!;
                                                          if (_pushPinClickedMap[
                                                              e.zoneId]!) {
                                                            _handlePushPinClick(
                                                                e.zoneId);
                                                          } else {
                                                            FirebaseCloudStorage()
                                                                .unpinZone(
                                                                    e.zoneId);
                                                          }
                                                        });
                                                      },
                                                      child: Transform.rotate(
                                                        angle: 45 * 3.14 / 180,
                                                        child: Icon(
                                                          _pushPinClickedMap[e
                                                                          .zoneId] ==
                                                                      null ||
                                                                  !_pushPinClickedMap[
                                                                      e.zoneId]!
                                                              ? Icons
                                                                  .push_pin_outlined
                                                              : Icons.push_pin,
                                                          size: 24,
                                                          color: _pushPinClickedMap[e
                                                                          .zoneId] ==
                                                                      null ||
                                                                  !_pushPinClickedMap[
                                                                      e.zoneId]!
                                                              ? primaryGray
                                                              : primaryOrange,
                                                        ),
                                                      ),
                                                    )
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
                                                    const SizedBox(width: 4),
                                                    SizedBox(
                                                      width:
                                                          200, // set a smaller width to fit the location in the card
                                                      child:
                                                          FutureBuilder<String>(
                                                        future:
                                                            FirebaseCloudStorage()
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
                                                              baseColor: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  216,
                                                                  216,
                                                                  216),
                                                              highlightColor:
                                                                  const Color
                                                                          .fromRGBO(
                                                                      173,
                                                                      173,
                                                                      173,
                                                                      0.824),
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color:
                                                                      primaryGray,
                                                                ),
                                                                width: double
                                                                    .infinity,
                                                                height: 24,
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
                                                                fontSize: 11.5,
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
                              );
                            }).toList(),
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
            margin: const EdgeInsets.only(top: 190),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              // button to filter
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Do something when the button is pressed
                        // For example, show all zones that have not been filtered yet
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                          color: primaryGray,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ..._categoryList.map((categoryName) {
                    log(categoryName);
                    return Container(
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Do something when the button is pressed
                          // For example, show only zones in this category
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                            color: primaryGray,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          if (_isSearching && _foundZones.isNotEmpty)
            Visibility(
              visible: true,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  padding: const EdgeInsets.only(top: 155),
                  child: ListView.builder(
                    itemCount: _foundZones.length,
                    itemBuilder: (context, index) {
                      final ZoneData zone = _foundZones[index];
                      return ListTile(
                        title: Text(zone.zoneName),
                        onTap: () {
                          // do something when user taps on the search result
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReservationView(zoneId: zone.zoneId),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          //search no found not working yet.
          // if (_isSearching && _foundZones.isEmpty)
          //           Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 const Icon(
          //                   Icons.search,
          //                   size: 100,
          //                   color: Colors.grey,
          //                 ),
          //                 const SizedBox(height: 16),
          //                 const Text(
          //                   'No results found',
          //                   style: TextStyle(
          //                     fontSize: 24,
          //                     fontWeight: FontWeight.w400,
          //                     color: Colors.grey,
          //                   ),
          //                 ),

          // _isSearching ? Visibility(
          //   visible: _isSearching,

          //   child: Container(
          //     color: Colors.white,
          //   )):
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
                    //search bar below
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          prefixIcon: _isSearching
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: primaryOrange,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isSearching = false;
                                      _searchController.clear();
                                      _searchText = '';
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                )
                              : const Icon(
                                  Icons.search,
                                  color: primaryOrange,
                                ),
                          suffixIcon: _isSearching
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController =
                                          TextEditingController();
                                      _searchText = '';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                            _foundZones = _zoneList
                                .where((zone) => zone.zoneName
                                    .toLowerCase()
                                    .contains(_searchText.toLowerCase()))
                                .toList();
                          });
                        },
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
