import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

typedef OnPressedCallBack = Function();

class ToggleRoleButton extends StatelessWidget {
  const ToggleRoleButton(
      {super.key,
      required this.onPressed,
      required this.isError,
      required this.isEverythingLoaded,
      required this.isDisableMenu,
      required this.isSwipingUp});
  final OnPressedCallBack onPressed;
  final bool isError;
  final bool isEverythingLoaded;
  final bool isDisableMenu;
  final bool isSwipingUp;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(0),
        elevation: isSwipingUp ? 0 : 5,
        backgroundColor: isError || !isEverythingLoaded
            ? primaryGray
            : isDisableMenu
                ? primaryRed
                : primaryOrange,
        fixedSize: const Size.fromRadius(25),
      ),
      onPressed: onPressed,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: Icon(
          isSwipingUp
              ? isDisableMenu
                  ? Icons.admin_panel_settings_outlined
                  : Icons.person_2_outlined
              : Icons.swap_horiz,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
