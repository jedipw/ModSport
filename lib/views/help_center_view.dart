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
  bool _isExpanded = false;

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
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  // Start writing your code here

                  //1 Tutorials and Guides
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ExpansionTile(
                      collapsedIconColor: primaryOrange,
                      iconColor: secondaryOrange,
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
                      children: <Widget>[
                        //1 For user
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  For User",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            //user tips1
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to Reservation Sport Facility",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Reserve Page\n"
                                  "      3) Select sport facility\n"
                                  "      4) Select date to reserve\n"
                                  "      5) Select time slot to reserve\n"
                                  "      6) Press 'RESERVE' button",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                            //user tips2
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to Cancel a Reservation",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Reserve Page\n"
                                  "      3) Select reserved sport facility\n"
                                  "      4) Select reserved date\n"
                                  "      5) Select reserved time slot\n"
                                  "      6) Press 'CANCEL' button\n"
                                  "      7) Press 'Yes' to confirm cancel reservation",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                            //user tips3
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to Check Reservation Status",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Status Page\n"
                                  "      3)	Press the reservation box to view details",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                            //user tips4
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to Change Password",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2)	Change Password Page\n"
                                  "      3)	Type your Current Password\n"
                                  "      4)	Type your New Password\n"
                                  "      5)	Type your New Password again to 'Confirm Password'\n"
                                  "      6)	Press 'Save' button",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),

                        //2 For staff
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  For Staff",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            //staff tips1
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to disable reservation",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Reserve Page\n"
                                  "      3) Press toggle button to switch to Staff view\n"
                                  "      4)	Select sport facility\n"
                                  "      5)	Select date to disable\n"
                                  "      6)	Select time slot to disable\n"
                                  "      7)	Press 'DISABLE' button\n"
                                  "      8)	Type Reason to disable\n"
                                  "      9) Press 'RESERVE' button",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                            //staff tips2
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to edit disable reservation",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Reserve Page\n"
                                  "      3) Press toggle button to switch to Staff view\n"
                                  "      4)	Select sport facility\n"
                                  "      5)	Select date to edit disable\n"
                                  "      6)	Press 'EDIT' icon\n"
                                  "      7)	Select time slot to edit disable\n"
                                  "      8)	Press 'EDIT' button\n"
                                  "      9) Type reason to edit disable\n"
                                  "      10) Press 'SAVE' button\n"
                                  "      11) Press 'Yes' to confirm edit reason",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                            //staff tips3
                            ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: primaryOrange,
                              title: Text(
                                "    How to enable reservation",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      primaryOrange, // change color to orange
                                ),
                              ),
                              children: <Widget>[
                                ListTile(
                                    // tileColor: Color.fromARGB(255, 254, 240, 226),
                                    title: Text(
                                  "      1) Menu bar\n"
                                  "      2) Reserve Page\n"
                                  "      3) Press toggle button to switch to Staff view\n"
                                  "      4)	Select sport facility\n"
                                  "      5)	Select date to enable\n"
                                  "      6)	Press 'EDIT' icon\n"
                                  "      7)	Select time slot to enable\n"
                                  "      8)	Press 'ENABLE' button\n"
                                  "      9) Press 'Yes' to confirm edit reason",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: primaryGray,
                                  ),
                                )),
                              ],
                            ),
                          ],
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
                    child: Theme(
                      data: ThemeData(
                        cardColor:
                            _isExpanded ? Colors.grey[300] : Colors.white,
                      ),
                      child: ExpansionTile(
                        collapsedIconColor: primaryOrange,
                        iconColor: secondaryOrange,
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
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          //Q1
                          ListTile(
                            // tileColor: const Color.fromARGB(255, 255, 230, 205),
                            title: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '  Q: Can I make a reservation for someone else?\n',
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
                                    text: '  A: Yes, you can.',
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
                          //Q2
                          ListTile(
                            // tileColor: const Color.fromARGB(255, 254, 240, 226),
                            title: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "  Q: Can I cancel a reservation if I change my mind?\n",
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
                                        '  A: Yes, you can cancel a reservation as long as'
                                        ' before reserved time coming.',
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
                          //Q3
                          ListTile(
                            // tileColor: const Color.fromARGB(255, 255, 230, 205),
                            title: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "  Q: How do I check my reservation result?\n",
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
                                        '  A: To view your reservation history, go to the "Status"'
                                        ' in menu bar of the app. Here you can see your status reservatons.',
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
                          //Q4
                          ListTile(
                            // tileColor: const Color.fromARGB(255, 254, 240, 226),
                            title: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "  Q: Is there a limit to the number of reservations I can make?\n",
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
                                        '  A: There is no limit to the number of reservations '
                                        'you can make, as long as the facility is available.',
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
                  ),

                  //3 Troubleshooting Tips
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const ExpansionTile(
                      collapsedIconColor: primaryOrange,
                      iconColor: secondaryOrange,
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
                        //1 Tips1
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  Can't log in to the app",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                                // tileColor: Color.fromARGB(255, 254, 240, 226),
                                title: Text(
                              "     If you're having trouble logging in to the app, "
                              "make sure you're using the correct username and password."
                              "If you forgot your password, you can reset it by clicking "
                              "on the 'Forget password?' on the LOG IN page.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: primaryGray,
                              ),
                            )),
                          ],
                        ),
                        //2 Tips2
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  Unable to make a reservation",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: [
                            ListTile(
                                // tileColor: Color.fromARGB(255, 254, 240, 226),
                                title: Text(
                              "     If you're having trouble making a reservation, check "
                              "that the facility you want to reserve is available.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: primaryGray,
                              ),
                            )),
                          ],
                        ),
                        //3 Tips3
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  Facility not available",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                                // tileColor: Color.fromARGB(255, 254, 240, 226),
                                title: Text(
                              "     If the facility you want to reserve is not available,"
                              " try selecting a different date or time. If the facility "
                              "is still not available, it may be reserved by someone else"
                              " or temporarily closed.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: primaryGray,
                              ),
                            )),
                          ],
                        ),
                        //4 Tips4
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  App crashes or freezes",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                                // tileColor: Color.fromARGB(255, 254, 240, 226),
                                title: Text(
                              "     If the app crashes or freezes, try restarting your"
                              " device and then launching the app again. If the problem"
                              " persists, try uninstalling and reinstalling the app. If "
                              "that still doesn't work, contact the customer support team"
                              " for assistance.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: primaryGray,
                              ),
                            )),
                          ],
                        ),
                        //5 Tips5
                        ExpansionTile(
                          collapsedIconColor: Colors.orangeAccent,
                          iconColor: primaryOrange,
                          title: Text(
                            "  Feedback and suggestions",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: primaryOrange, // change color to orange
                            ),
                          ),
                          children: <Widget>[
                            ListTile(
                                // tileColor: Color.fromARGB(255, 254, 240, 226),
                                title: Text(
                              "     If you have any feedback or suggestions for the app,"
                              " please feel free to contact the customer support team. "
                              "They would be happy to hear from you and will do their best"
                              " to address any issues or concerns you may have.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: primaryGray,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //4 Contact Information
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      // collapsedBackgroundColor: Colors.amber,
                      // backgroundColor: Colors.amber,
                      collapsedIconColor: primaryOrange,
                      iconColor: secondaryOrange,
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
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isExpanded = expanded;
                        });
                      },
                      children: <Widget>[
                        ListTile(
                          // tileColor: Colors.white,
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
