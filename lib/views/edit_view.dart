import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class EditView extends StatelessWidget {
  const EditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(),
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                  'EDIT DISABLE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                    height: 1.5,
                    color: primaryOrange,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 65,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                shape: const CircleBorder(),
                fixedSize: const Size.fromRadius(25),
                elevation: 0,
              ),
              child: const Icon(Icons.close, color: primaryOrange, size: 40),
            ),
          ),
        ],
      ),
    ));
  }
}
