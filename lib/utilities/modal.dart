import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/routes.dart';

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
                  color: primaryGreen,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 30),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
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

dynamic showLoadModal(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 60),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(color: primaryOrange),
              ),
              SizedBox(height: 60),
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
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryRed,
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
                            primaryGreen,
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
                            primaryRed,
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

dynamic showErrorModal(BuildContext context, OnPressedCallBack onPressed) {
  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
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
                  color: primaryRed,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 25),
              const Text(
                'Something went wrong!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                  height: 1.3,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Please try again later!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                  height: 1.3,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      );
    },
  );
}

dynamic showDoneConfirmationModal(
    BuildContext context, OnPressedCallBack onPressed) {
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
              children: const [
                SizedBox(height: 40),
                Text(
                  'Have you done and',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: staffOrange,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'wanted to disable?',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: staffOrange,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 50),
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
                            staffOrange,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Done',
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
                      width: 94,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Not yet',
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

dynamic showCancelConfirmationModal(
    BuildContext context, OnPressedCallBack onPressed) {
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
              children: const [
                SizedBox(height: 40),
                Text(
                  'Do you want',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryRed,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'to cancel?',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryRed,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 50),
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
                            primaryRed,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                      width: 94,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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

dynamic showEnableConfirmationModal(
    BuildContext context, OnPressedCallBack onPressed) {
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
              children: const [
                SizedBox(height: 40),
                Text(
                  'Do you want',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryGreen,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'to enable?',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryGreen,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 50),
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
                            primaryGreen,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                      width: 94,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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

dynamic showSaveConfirmationModal(
    BuildContext context, OnPressedCallBack onPressed) {
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
              children: const [
                SizedBox(height: 40),
                Text(
                  'Do you want',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: staffOrange,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'to save the edit?',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: staffOrange,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                ),
                SizedBox(height: 50),
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
                            staffOrange,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                      width: 94,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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

dynamic showLogoutConfirmationModal(BuildContext context,
    OnPressedCallBack onPressed, bool showSuccess, String mode) {
  String modeWord = 'sign out';

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
                  'Do you want to\n$modeWord ?',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: primaryRed,
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
                        onPressed: () async {
                          showLoadModal(context);
                          await FirebaseAuth.instance
                              .signOut()
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => Navigator.of(context).pushNamed(
                                    // navigates to homeRoute screen and removes previous routes
                                    loginRoute,
                                  ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryRed,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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

dynamic showSuccessMailModal(BuildContext context, bool needToClose) {
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
                  color: primaryGreen,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 30),
              const Text(
                'Email sent! \nPlease verify your email and try to login again.',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
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
