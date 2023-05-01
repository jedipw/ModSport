import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    required this.isSwipingUp,
    required this.isError,
    required this.isEverythingLoaded,
    required this.isDisableMenu,
  });
  final bool isSwipingUp;
  final bool isError;
  final bool isEverythingLoaded;
  final bool isDisableMenu;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSwipingUp
            ? isError || !isEverythingLoaded
                ? primaryGray
                : isDisableMenu
                    ? primaryRed
                    : primaryOrange
            : primaryOrange,
        shape: const CircleBorder(),
        elevation: isSwipingUp ? 0 : 5,
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
        fixedSize: const Size.fromRadius(25),
      ),
      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
    );
  }
}
