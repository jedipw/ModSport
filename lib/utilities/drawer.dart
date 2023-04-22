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
                    backgroundColor: primaryOrange,
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
                    color:
                        currentDrawerIndex == 0 ? primaryOrange : Colors.black),
                const SizedBox(width: 8),
                const Text('Home'),
              ],
            ),
            selectedColor: primaryOrange,
            selected: currentDrawerIndex == 0,
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false);
            },
          ),
          ListTile(
            selectedColor: primaryOrange,
            selected: currentDrawerIndex == 1,
            title: Row(
              children: [
                Icon(Icons.rule,
                    color:
                        currentDrawerIndex == 1 ? primaryOrange : Colors.black),
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
            selectedColor: primaryOrange,
            selected: currentDrawerIndex == 2,
            title: Row(
              children: [
                Icon(currentDrawerIndex == 2 ? Icons.help : Icons.help_outline,
                    color:
                        currentDrawerIndex == 2 ? primaryOrange : Colors.black),
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
              showConfirmationModal(context, () {
                Navigator.of(context).pop();
                showLoadModal(context);
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, false, logOutMode);
            },
          ),
        ],
      ),
    );
  }
}
