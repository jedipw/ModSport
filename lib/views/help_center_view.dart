import 'package:flutter/material.dart';
import 'package:modsport/utilities/drawer.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  final int _currentDrawerIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 150),
                // Start writing your code here
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                height: 125,
                decoration: const BoxDecoration(
                  color: Color(0xFFE17325),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'HELP CENTER',
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
                left: 15,
                top: 65,
                child: IconButton(
                  onPressed: () {
                    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                      _scaffoldKey.currentState?.openEndDrawer();
                    } else {
                      _scaffoldKey.currentState?.openDrawer();
                    }
                  },
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
