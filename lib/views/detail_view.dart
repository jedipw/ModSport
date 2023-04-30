import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

// This class represents the Detail view of the app
class DetailView extends StatelessWidget {
  const DetailView(
      {super.key, required this.zoneId, required this.startDateTime});

  final String zoneId;
  final DateTime startDateTime;

  // This method builds the UI for the Detail view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This widget is the body of the screen, which displays the text 'Detail Page' at the center of the screen
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
                // Start writing your code here
                Center(
                    child:
                        Text('Zone ID: $zoneId \n Start time: $startDateTime'))
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
                      'STATUS',
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
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                    fixedSize: const Size.fromRadius(25),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
