import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

typedef OnPressedCallBack = Function();

class ToggleRoleButton extends StatelessWidget {
  const ToggleRoleButton(
      {super.key,
      required this.onPressed,
      required this.isError,
      required this.isEverythingLoaded,
      required this.isDisableMenu});
  final OnPressedCallBack onPressed;
  final bool isError;
  final bool isEverythingLoaded;
  final bool isDisableMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
          elevation: 5,
          backgroundColor: isError || !isEverythingLoaded
              ? primaryGray
              : isDisableMenu
                  ? primaryRed
                  : primaryOrange,
        ),
        onPressed: onPressed,
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: const Icon(
            Icons.swap_horiz,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
