import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/constants/color.dart';

class EditView extends StatefulWidget {
  const EditView({super.key, required this.selectedDateIndex});
  final int selectedDateIndex;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  bool _isReasonShow = false;

  String _getDayOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate =
        DateTime.now().add(Duration(days: widget.selectedDateIndex));

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 140),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          '${_getDayOrdinal(currentDate.day)} ${DateFormat('MMMM').format(currentDate)} ${currentDate.year}',
                          style: const TextStyle(
                            color: primaryOrange,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            height:
                                1.5, // adjust line height with the line-height CSS property
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_isReasonShow) {
                              setState(() {
                                _isReasonShow = false;
                              });
                            } else {
                              setState(() {
                                _isReasonShow = true;
                              });
                            }
                          },
                          child: Text(
                            _isReasonShow ? 'Hide Reasons' : 'Show Reasons',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              height:
                                  1.5, // adjust line height with the line-height CSS property
                              decoration: TextDecoration.underline,
                              color: primaryGray,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: primaryOrange,
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
                    color: Colors.white,
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
                backgroundColor: primaryOrange,
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                shape: const CircleBorder(),
                fixedSize: const Size.fromRadius(25),
                elevation: 0,
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    ));
  }
}
