import 'package:flutter/material.dart';

import 'package:modsport/constants/color.dart';

import 'package:modsport/utilities/reservation/toggle_role_button.dart';

typedef OnPressedCallBack = Function();

class ReservationAppBar extends StatelessWidget {
  final bool isSwipingUp;
  final bool isError;
  final bool isEverythingLoaded;
  final bool isDisableMenu;
  final bool hasRole;

  final OnPressedCallBack onPressed;

  const ReservationAppBar({
    super.key,
    required this.isSwipingUp,
    required this.isError,
    required this.isEverythingLoaded,
    required this.isDisableMenu,
    required this.hasRole,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isSwipingUp
            ? Stack(
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: isError || !isEverythingLoaded
                          ? primaryGray
                          : isDisableMenu
                              ? staffOrange
                              : primaryOrange,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 17),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'RESERVATION',
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
                      ],
                    ),
                  ),
                ],
              )
            : Container(),

        // If user has staff role, show toggle role button.
        if (hasRole && isSwipingUp) ...[
          Positioned(
            right: 10,
            top: 65,
            child:
                // Toggle role button
                Column(
              children: [
                ToggleRoleButton(
                  isSwipingUp: isSwipingUp,
                  isError: isError,
                  isDisableMenu: isDisableMenu,
                  isEverythingLoaded: isEverythingLoaded,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
