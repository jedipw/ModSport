import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final int _currentDrawerIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        isOpened && Platform.isIOS
            ? SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.dark.copyWith(
                statusBarColor:
                    primaryGray, // set to Colors.black for black color
              ))
            : Platform.isIOS
                ? SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.light.copyWith(
                    statusBarColor:
                        primaryGray, // set to Colors.black for black color
                  ))
                : null;
      },
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
                // Start writing your code here

                //1
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text(
                      'Tutorials and Guides',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                      ),
                    ),
                    //subtitle: Text('Trailing expansion arrow icon'),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "This is tile number 1",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //2
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    title: const Text(
                      'Frequently Asked Questions (FAQs)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                      ),
                    ),
                    children: <Widget>[
                      //1
                      ListTile(
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Q: Can I make a reservation for someone else?\n',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              TextSpan(
                                text: 'A: Yes, you can.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: primaryGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //2
                      ListTile(
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Q: Can I modify or cancel my reservation once it's been made?\n",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              TextSpan(
                                text:
                                    'A: Yes, you can cancel your reservation.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: primaryGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //3
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text(
                      'Troubleshooting Tips',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                      ),
                    ),
                    children: <Widget>[
                      ListTile(
                        //1
                        title: Text(
                          "This is tile number 3.1",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                      ListTile(
                        //2
                        title: Text(
                          "This is tile number 3.2",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                      ListTile(
                        //3
                        title: Text(
                          "This is tile number 3.3",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                      ListTile(
                        //4
                        title: Text(
                          "This is tile number 3.4",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                      ListTile(
                        //5
                        title: Text(
                          "This is tile number 3.5",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: primaryGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //4
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    title: const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                      ),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Phone number: ",
                                style: TextStyle(
                                  color: primaryOrange,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "02-212-2510\n",
                              ),
                              TextSpan(
                                text: "Email address: ",
                                style: TextStyle(
                                  color: primaryOrange,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "pawin.nakv@kmutt.ac.th\n",
                              ),
                              TextSpan(
                                text: "Mailing address: ",
                                style: TextStyle(
                                  color: primaryOrange,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "126 Pracha Uthit Rd, Bang Mot, Thung Khru, Bangkok 10140\n",
                              ),
                              TextSpan(
                                text: "Hours of operation: ",
                                style: TextStyle(
                                  color: primaryOrange,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: "8:00 a.m.-4:00 p.m.",
                              ),
                            ],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryGray,
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
                      'HOW CAN WE HELP?',
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
