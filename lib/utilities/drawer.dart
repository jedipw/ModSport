import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class ModSportDrawer extends StatelessWidget {
  const ModSportDrawer({super.key, required this.currentDrawerIndex});
  final int currentDrawerIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 150,
            child: DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 225, 115, 37),
                    child: Text(
                      'FL',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Firstname Lastname'),
                      Text('firstname.lastn@kmutt.ac.th'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.home,
                    color: currentDrawerIndex == 0
                        ? const Color.fromARGB(255, 225, 115, 37)
                        : Colors.black),
                const SizedBox(width: 8),
                const Text('Home'),
              ],
            ),
            selectedColor: const Color.fromARGB(255, 225, 115, 37),
            selected: currentDrawerIndex == 0,
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false);
            },
          ),
          ListTile(
            selectedColor: const Color.fromARGB(255, 225, 115, 37),
            selected: currentDrawerIndex == 1,
            title: Row(
              children: [
                Icon(Icons.rule,
                    color: currentDrawerIndex == 1
                        ? const Color.fromARGB(255, 225, 115, 37)
                        : Colors.black),
                const SizedBox(width: 8),
                const Text('Status'),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(statusRoute, (route) => false);
            },
          ),
          ListTile(
            selectedColor: const Color.fromARGB(255, 225, 115, 37),
            selected: currentDrawerIndex == 2,
            title: Row(
              children: [
                Icon(currentDrawerIndex == 2 ? Icons.help : Icons.help_outline,
                    color: currentDrawerIndex == 2
                        ? const Color.fromARGB(255, 225, 115, 37)
                        : Colors.black),
                const SizedBox(width: 8),
                const Text('Help Center'),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(helpCenterRoute, (route) => false);
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.logout, color: Colors.black),
                SizedBox(width: 8),
                Text('Log out'),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  barrierColor: Colors.white.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.zero,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: const [
                              SizedBox(height: 40),
                              Text(
                                'Are you sure\nyou want to\nlog out ?',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFCC0019),
                                  height: 1.3,
                                  letterSpacing: 0.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 84,
                                    height: 43,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                loginRoute, (route) => false);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color(0xFF009900),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0,
                                          height: 1.2,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 34.0),
                                  SizedBox(
                                    width: 84,
                                    height: 43,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color(0xFFCC0019),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0,
                                          height: 1.2,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
