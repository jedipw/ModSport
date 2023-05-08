import 'package:flutter/material.dart';

class RoleName extends StatelessWidget {
  final bool isDisableMenu;
  final bool isSwipingUp;

  const RoleName({
    super.key,
    required this.isDisableMenu,
    required this.isSwipingUp,
  });

  @override
  Widget build(BuildContext context) {
    return isSwipingUp
        ? Container()
        : Row(
            children: [
              Text(
                isDisableMenu ? 'Staff' : 'User',
                style: const TextStyle(
                  fontSize: 14, fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5, // 21/14 = 1.5
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
              Icon(
                isDisableMenu
                    ? Icons.admin_panel_settings_outlined
                    : Icons.person_2_outlined,
                color: Colors.black,
              )
            ],
          );
  }
}
