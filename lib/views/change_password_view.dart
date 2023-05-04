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
              // const Expanded(
              //   child: CustomPageView(),
              // ),
            ],
          ),
        ),
      );
    }
    return const Text("Loading..");
  }
}

class CustomPageView extends StatefulWidget {
  const CustomPageView({Key? key}) : super(key: key);

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  final _controller = PageController(initialPage: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _controller,
      children: [
        // First page
        Row(
          children: [
            Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(
                    top: 136,
                    left: 113,
                  ),
                  decoration: const BoxDecoration(
                    color: primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: 38.67 * ((22 / 7) / 180),
                    child: const Icon(
                      Icons.key,
                      size: 97.86,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _controller.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Second page
        Container(
          color: Colors.red,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _controller.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              child: const Text("Back"),
            ),
          ),
        )
      ],
    );
  }
}
