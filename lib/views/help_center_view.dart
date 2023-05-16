import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/drawer.dart';
import 'package:shimmer/shimmer.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final int _currentDrawerIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasRole = false;
  bool _isExpanded = false;
  bool _isHasRoleLoaded = false;
  bool _isError = false;

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

  Future<void> _getUserHasRoleData() async {
    try {
      bool userData = await FirebaseCloudStorage().getUserHasRole(userId);

      bool userHasRole = userData;
      // Update the state
      if (mounted) {
        setState(
          () {
            _hasRole = userHasRole;
            _isHasRoleLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
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

  Future<void> fetchData() async {
    await _getUserHasRoleData();
  }

  @override
  Widget build(BuildContext context) {
    Platform.isIOS
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarColor:
                  Colors.white, // set to Colors.black for black color
            ),
          )
        : null;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: _isError
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
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
                    )
                  : _isHasRoleLoaded
                      ? Column(
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
                              child: ExpansionTile(
                                collapsedIconColor: primaryOrange,
                                iconColor: secondaryOrange,
                                title: const Text(
                                  'Tutorials and Guides',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(0, 0, 0, 0.7),
                                  ),
                                ),
                                children: _hasRole
                                    ? <Widget>[
                                        //1 For user
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
                                          iconColor: primaryOrange,
                                          title: Text(
                                            "  For User",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color:
                                                  primaryOrange, // change color to orange
                                            ),
                                          ),
                                          children: <Widget>[
                                            //user tips1
                                            ExpansionTile(
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Reserve Page\n"
                                                  "      3) Select a sport facility\n"
                                                  "      4) Choose a date for reservation\n"
                                                  "      5) Select the desired time slot\n"
                                                  "      6) Press the 'RESERVE' button",
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
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Reserve Page\n"
                                                  "      3) Select the reserved sport facility\n"
                                                  "      4) Choose the reserved date\n"
                                                  "      5) Select the reserved time slot\n"
                                                  "      6) Press the 'CANCEL' button\n"
                                                  "      7) Press 'Yes' to confirm the cancellation",
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
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Status Page\n"
                                                  "      3)	Press the reservation box to view the details",
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
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
                                              iconColor: primaryOrange,
                                              title: Text(
                                                "    How to Change the Password",
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2)	Navigate to the Change Password Page\n"
                                                  "      3)	Enter your current Password\n"
                                                  "      4)	Enter your new Password\n"
                                                  "      5)	Re-enter your new Password to confirm\n"
                                                  "      6)	Press the 'Save' button",
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
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
                                          iconColor: primaryOrange,
                                          title: Text(
                                            "  For Staff",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color:
                                                  primaryOrange, // change color to orange
                                            ),
                                          ),
                                          children: <Widget>[
                                            //staff tips1
                                            ExpansionTile(
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
                                              iconColor: primaryOrange,
                                              title: Text(
                                                "    How to Disable Reservation",
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Reserve Page\n"
                                                  "      3) Toggle the button to switch to Staff view\n"
                                                  "      4)	Select the sport facility\n"
                                                  "      5)	Choose the date to disable\n"
                                                  "      6)	Select the time slot to disable\n"
                                                  "      7)	Press the 'DISABLE' button\n"
                                                  "      8)	Enter the reason to disable\n"
                                                  "      9) Press the 'DONE' button\n"
                                                  "      10) Press 'Done' to confirm",
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
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
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
                                                    title: Text(
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Reserve Page\n"
                                                  "      3) Toggle the button to switch to Staff view\n"
                                                  "      4)	Select the sport facility\n"
                                                  "      5)	Select the date to edit the disable reasons\n"
                                                  "      6)	Press 'EDIT' icon\n"
                                                  "      7)	Select time slots to edit disable\n"
                                                  "      8)	Press 'EDIT' button\n"
                                                  "      9) Type the new reason\n"
                                                  "      10) Press the 'SAVE' button\n"
                                                  "      11) Press 'Yes' to confirm",
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
                                              collapsedIconColor:
                                                  Colors.orangeAccent,
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
                                                  "      1) Press the Menu bar\n"
                                                  "      2) Navigate to the Reserve Page\n"
                                                  "      3) Toggle the button to switch to Staff view\n"
                                                  "      4)	Select the sport facility\n"
                                                  "      5)	Select the date to enable reservations\n"
                                                  "      6)	Press the 'EDIT' icon\n"
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
                                      ]
                                    : <Widget>[
                                        //user tips1
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
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
                                                title: Text(
                                              "      1) Press the Menu bar\n"
                                              "      2) Navigate to the Reserve Page\n"
                                              "      3) Select a sport facility\n"
                                              "      4) Choose a date for reservation\n"
                                              "      5) Select the desired time slot\n"
                                              "      6) Press the 'RESERVE' button",
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
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
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
                                                title: Text(
                                              "      1) Press the Menu bar\n"
                                              "      2) Navigate to the Reserve Page\n"
                                              "      3) Select the reserved sport facility\n"
                                              "      4) Choose the reserved date\n"
                                              "      5) Select the reserved time slot\n"
                                              "      6) Press the 'CANCEL' button\n"
                                              "      7) Press 'Yes' to confirm the cancellation",
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
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
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
                                                title: Text(
                                              "      1) Press the Menu bar\n"
                                              "      2) Navigate to the Status Page\n"
                                              "      3)	Press the reservation box to view the details",
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
                                        const ExpansionTile(
                                          collapsedIconColor:
                                              Colors.orangeAccent,
                                          iconColor: primaryOrange,
                                          title: Text(
                                            "    How to Change the Password",
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
                                                title: Text(
                                              "      1) Press the Menu bar\n"
                                              "      2)	Navigate to the Change Password Page\n"
                                              "      3)	Enter your current Password\n"
                                              "      4)	Enter your new Password\n"
                                              "      5)	Re-enter your new Password to confirm\n"
                                              "      6)	Press the 'Save' button",
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

                            //2
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Theme(
                                data: ThemeData(
                                  cardColor: _isExpanded
                                      ? Colors.grey[300]
                                      : Colors.white,
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
                                              text:
                                                  "  A: No, you cannot make a reservation for someone else. Reservations for sport facilities are typically linked to individual user accounts, and each user needs to make their own reservation using their own account.",
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
                                                  '  A: Yes, you can cancel your reservation as long as it is before the scheduled usage time of the sport facility you have reserved.',
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
                                                  '  A: To view your reservation result, go to the "Status"'
                                                  ' option in the menu bar of the app. Here, you can see the status of your reservations.',
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
                                                  '  A: Yes, there is a limit to the number of reservations you can make for each day at a specific sport facility. You can reserve one time slot per day at a given sport facility. However, if you switch to a different day, you can make another reservation for that day at the same or different sport facility. If the time for a specific reservation has already passed, you are still able to make another reservation for the same day. Additionally, you have the option to make reservations for different sport facilities within the same day. There is no restriction on the number of reservations you can make as long as they are within the available time slots and sport facilities.',
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
                                        color:
                                            primaryOrange, // change color to orange
                                      ),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                        "     If you are unable to log in to the app, "
                                        "please ensure that you are using the correct username and password."
                                        "If you have forgotten your password, you can reset it by clicking "
                                        "on the \"Forgot password?\" option on the login page.",
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
                                        color:
                                            primaryOrange, // change color to orange
                                      ),
                                    ),
                                    children: [
                                      ListTile(
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
                                        color:
                                            primaryOrange, // change color to orange
                                      ),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                        "     If the facility you wish to reserve is unavailable,"
                                        " please consider selecting a different date or time. If the facility "
                                        "remains unavailable, it is possible that it has been reserved by another individual"
                                        " or is temporarily closed.",
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
                                        color:
                                            primaryOrange, // change color to orange
                                      ),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                        "     If the app crashes or freezes, try restarting your"
                                        " device and then launching the app again. If the problem"
                                        " persists, try uninstalling and reinstalling the app. If "
                                        "that still doesn't work, please contact the customer support team"
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
                                        color:
                                            primaryOrange, // change color to orange
                                      ),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                        "     If you have any feedback or suggestions for the app,"
                                        " please don't hesitate to reach out to our customer support team. "
                                        "They are eager to receive your input and will make every effort to"
                                        " resolve any problems or address any concerns you may have.",
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
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 150),
                            // Start writing your code here
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: primaryOrange,
                                iconColor: secondaryOrange,
                                title: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    height: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: primaryOrange,
                                iconColor: secondaryOrange,
                                title: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    height: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: primaryOrange,
                                iconColor: secondaryOrange,
                                title: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    height: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: primaryOrange,
                                iconColor: secondaryOrange,
                                title: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 216, 216, 216),
                                  highlightColor: const Color.fromRGBO(
                                      173, 173, 173, 0.824),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    height: 20.0,
                                  ),
                                ),
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
