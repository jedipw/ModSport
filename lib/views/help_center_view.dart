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
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text('Tutorials and Guides'),
                    //subtitle: Text('Trailing expansion arrow icon'),
                    children: <Widget>[
                      ListTile(title: Text('This is tile number 1')),
                    ],
                  ),
                ),

                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text('Frequently Asked Questions (FAQs)'),
                    children: <Widget>[
                      ListTile(
                          title: Text(
                              'Q: Can I make a reservation for someone else?\nA: Yes, you can.')),
                      ListTile(
                          title: Text(
                              "Q: Can I modify or cancel my reservation once it's been made?\n"
                              "A:  Yes, you can cancel your reservation.")),
                    ],
                  ),
                ),

                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text('Troubleshooting Tips'),
                    children: <Widget>[
                      ListTile(title: Text('This is tile number 3')),
                    ],
                  ),
                ),

                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ExpansionTile(
                    title: Text('Contact Information'),
                    children: <Widget>[
                      ListTile(
                          title: Text(
                              "Phone number: 02-212-2510\nEmail address: pawin.nakv@kmutt.ac.th\n"
                              "Mailing address: 126 Pracha Uthit Rd, Bang Mot, Thung Khru, Bangkok 10140\n"
                              "Hours of operation: 8:00 a.m.-4:00 p.m.")),
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
