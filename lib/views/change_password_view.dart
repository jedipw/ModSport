import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/drawer.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final int _currentDrawerIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final TextEditingController _currentPasswordController =
  //     TextEditingController();
  // final TextEditingController _newPasswordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
        body: Container(
          color: authenGray,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 75),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                        _scaffoldKey.currentState?.openEndDrawer();
                      } else {
                        _scaffoldKey.currentState?.openDrawer();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: authenGray,
                      shape: const CircleBorder(),
                      fixedSize: const Size.fromRadius(25),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.menu, color: primaryOrange),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      );
    }
    return const Text("Loading..");
  }
}
