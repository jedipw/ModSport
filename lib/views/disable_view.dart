import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w600,
  fontSize: 26.0,
  height: 1.5,
);

// A stateless widget for the disable view
class DisableView extends StatefulWidget {
  const DisableView({super.key});

  @override
  State<DisableView> createState() => _DisableViewState();
}

class _DisableViewState extends State<DisableView> {
  int numOfCharacter = 0;
  final reasonController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    reasonController.dispose();
    super.dispose();
  }

  // The build method returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A Center widget containing a Text widget
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Facility:', style: textStyle),
                        Text('Date:', style: textStyle),
                        Text('Time:', style: textStyle),
                        const SizedBox(height: 50),
                        Text('Reason:',
                            style: textStyle, textAlign: TextAlign.left),
                        TextFormField(
                          controller: reasonController,
                          autofocus: true,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              numOfCharacter = reasonController.text.length;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$numOfCharacter/250',
                      style: TextStyle(
                          color: numOfCharacter > 250 || numOfCharacter < 10
                              ? Colors.red
                              : Colors.black),
                    ),
                    if (numOfCharacter < 10)
                      const Text(
                        'Type at least 10 characters!',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (numOfCharacter > 250)
                      const Text(
                        'Delete some characters!',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 55,
                width: 140,
                child: TextButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: numOfCharacter > 250 || numOfCharacter < 10
                            ? const Color(0xFF808080)
                            : const Color(0xFF009900),
                        width: 3,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ), // Set the button background color to grey
                  onPressed: numOfCharacter > 250 || numOfCharacter < 10
                      ? null
                      : () {
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
                                          'Are you sure\nyou want to\ndisable ?',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFCC0019),
                                            height: 1.3,
                                            letterSpacing: 0.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 84,
                                              height: 43,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color(0xFF009900),
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
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
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color(0xFFCC0019),
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
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
                        },
                  child: Text(
                    "DONE", // Set the button text to "Disable"
                    style: TextStyle(
                      color: numOfCharacter > 250 || numOfCharacter < 10
                          ? const Color(0xFF808080)
                          : const Color(0xFF009900),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Stack(children: [
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: Color(0xFFE17325),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'DISABLE',
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
          ),
          Positioned(
            left: 15,
            top: 65,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ]),
      ]),
    );
  }
}
