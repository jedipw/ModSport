import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class CustomPageViewButton extends StatelessWidget {
  final int pageIndex;
  final PageController controller;
  final Function()? onPressed;

  const CustomPageViewButton({
    Key? key,
    required this.pageIndex,
    required this.controller,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          controller.animateToPage(
            pageIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        minimumSize: const Size(174, 64),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.25),
      ),
      child: const Text(
        "Next",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
