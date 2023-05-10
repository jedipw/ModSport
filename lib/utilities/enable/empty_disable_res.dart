import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class EmptyDisableReservation extends StatelessWidget {
  const EmptyDisableReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.calendar_today,
                                      size: 100, color: primaryGray),
                                  SizedBox(height: 20),
                                  Text(
                                    'There are no disabled reservations',
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
                                    'to enable or edit on this page.',
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
                              );
  }
}