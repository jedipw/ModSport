import 'package:flutter/material.dart';

class RoleName extends StatelessWidget {
  const RoleName({
    super.key,
    required this.isDisableMenu,
  });
  final bool isDisableMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(isDisableMenu ? 'Staff' : 'User',
            style: const TextStyle(
              fontSize: 14, fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.5, // 21/14 = 1.5
              letterSpacing: 0,
            )),
        Icon(isDisableMenu
            ? Icons.admin_panel_settings_outlined
            : Icons.person_2_outlined)
      ],
    );
  }
}
