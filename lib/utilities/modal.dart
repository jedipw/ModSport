import 'package:flutter/material.dart';
import 'package:modsport/constants/mode.dart';

typedef OnPressedCallBack = Function();

dynamic showSuccessModal(BuildContext context, bool needToClose) {
  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    builder: (BuildContext context) {
      if (needToClose) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      }
      return Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 10),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                  height: 1.3,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      );
    },
  );
}

dynamic showConfirmationModal(BuildContext context, OnPressedCallBack onPressed,
    bool showSuccess, String mode) {
  String modeWord = '';

  switch (mode) {
    case editMode:
      modeWord = 'edit';
      break;
    case disableMode:
      modeWord = 'disable';
      break;
    case cancelMode:
      modeWord = 'cancel';
      break;
    case logOutMode:
      modeWord = 'log out';
      break;
    case enableMode:
      modeWord = 'enable';
      break;
  }

  showDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Are you sure\nyou want to\n$modeWord ?',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFFCC0019),
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 84,
                      height: 43,
                      child: TextButton(
                        onPressed: onPressed,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF009900),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            height: 1.2,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 34.0),
                    SizedBox(
                      width: 84,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFCC0019),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            height: 1.2,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
