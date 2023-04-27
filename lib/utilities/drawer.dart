import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/modal.dart';

class ModSportDrawer extends StatelessWidget {
  const ModSportDrawer({super.key, required this.currentDrawerIndex});
  final int currentDrawerIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(10, 80, 0, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: primaryOrange,
                  maxRadius: 25,
                  child: Text(
                    'FL',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FIRSTNAME LASTNAME',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                        color: primaryOrange,
                      ),
                    ),
                    Text(
                      'firstname.lastn@kmutt.ac.th',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5, // line-height equivalent in Flutter
                        color: Color.fromRGBO(0, 0, 0,
                            0.7), // using the `Color.fromRGBO()` constructor
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                tileColor: currentDrawerIndex == 0
                    ? const Color.fromRGBO(217, 217, 217, 0.5)
                    : Colors.white,
                title: Row(
                  children: const [
                    Icon(Icons.home, color: primaryOrange),
                    SizedBox(width: 8),
                    Text(
                      'Reserve',
                      style: TextStyle(
                        color: primaryOrange,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5, // line-height equivalent in Flutter
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                },
              ),
              ListTile(
                tileColor: currentDrawerIndex == 1
                    ? const Color.fromRGBO(217, 217, 217, 0.5)
                    : Colors.white,
                title: Row(
                  children: const [
                    Icon(Icons.event_available, color: primaryOrange),
                    SizedBox(width: 8),
                    Text(
                      'Status',
                      style: TextStyle(
                        color: primaryOrange,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5, // line-height equivalent in Flutter
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(statusRoute, (route) => false);
                },
              ),
              ListTile(
                tileColor: currentDrawerIndex == 2
                    ? const Color.fromRGBO(217, 217, 217, 0.5)
                    : Colors.white,
                title: Row(
                  children: const [
                    Icon(Icons.help_outline, color: primaryOrange),
                    SizedBox(width: 8),
                    Text(
                      'Help Center',
                      style: TextStyle(
                        color: primaryOrange,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5, // line-height equivalent in Flutter
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      helpCenterRoute, (route) => false);
                },
              ),
              ListTile(
                tileColor: currentDrawerIndex == 3
                    ? const Color.fromRGBO(217, 217, 217, 0.5)
                    : Colors.white,
                title: Row(
                  children: const [
                    Icon(Icons.lock_outline, color: primaryOrange),
                    SizedBox(width: 8),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        color: primaryOrange,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5, // line-height equivalent in Flutter
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      changePasswordRoute, (route) => false);
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: 180,
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: const BorderSide(
                          color: primaryOrange,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        showConfirmationModal(context, () {
                          Navigator.of(context).pop();
                          showLoadModal(context);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        }, false, logOutMode);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Sign out',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.5, // line-height equivalent in Flutter
                              color:
                                  primaryOrange, // assuming primaryOrange is a shade of orange
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(Icons.logout, color: primaryOrange),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
