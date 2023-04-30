import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/types.dart';
import 'package:shimmer/shimmer.dart';

class EditView extends StatefulWidget {
  const EditView(
      {super.key, required this.selectedDateIndex, required this.zoneId});
  final int selectedDateIndex;
  final String zoneId;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  bool _isReasonShow = false;
  bool _isReservationLoaded = false;
  bool _isError = false;
  bool _isDisableReservationLoaded = false;

  List<ReservationData> _reservations = [];
  List<DisableData> _disabledReservation = [];
  List<bool> _selectedTimeSlots = [];
  final List<String> _disableIds = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Ensure that the data is fetched when entered this page for the second time and onward.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  // Handle the error when data cannot be fetched from database
  void handleError() {
    if (mounted) {
      setState(
        () {
          _isError = true;
        },
      );
    }
  }

  Future<void> _getReservationData() async {
    try {
      // Get reservation (time slot) data
      List<ReservationData> reservations = await FirebaseCloudStorage()
          .getEditReservation(widget.zoneId, true, widget.selectedDateIndex);

      // Update the state
      if (mounted) {
        setState(
          () {
            _reservations = reservations;
            _isReservationLoaded = true;
            if (_selectedTimeSlots.isEmpty) {
              _selectedTimeSlots =
                  List.generate(reservations.length, (index) => false);
            }
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getDisableReservationData() async {
    try {
      // Get disable reservation data
      List<DisableData> disable = await FirebaseCloudStorage()
          .getDisableReservation(widget.zoneId, widget.selectedDateIndex);

      // Update the state
      if (mounted) {
        setState(
          () {
            _disabledReservation = disable;
            _isDisableReservationLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  String _getDayOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  // Fetch the data from the database
  Future<void> fetchData() async {
    setState(
      () {
        _isReservationLoaded = false;
        _isDisableReservationLoaded = false;
      },
    );
    await _getReservationData();
    await _getDisableReservationData();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      unselectedWidgetColor: Colors.white,
    );

    int numOfSelectedTimeSlots =
        _selectedTimeSlots.where((element) => element == true).length;
    // Check if every data has been retrieved from the database
    bool isEverythingLoaded() {
      return _isReservationLoaded && _isDisableReservationLoaded;
    }

    DateTime currentDate =
        DateTime.now().add(Duration(days: widget.selectedDateIndex));

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 140),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          '${_getDayOrdinal(currentDate.day)} ${DateFormat('MMMM').format(currentDate)} ${currentDate.year}',
                          style: const TextStyle(
                            color: primaryOrange,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            height:
                                1.5, // adjust line height with the line-height CSS property
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_isReasonShow) {
                              setState(() {
                                _isReasonShow = false;
                              });
                            } else {
                              setState(() {
                                _isReasonShow = true;
                              });
                            }
                          },
                          child: Text(
                            _isReasonShow ? 'Hide Reasons' : 'Show Reasons',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              height:
                                  1.5, // adjust line height with the line-height CSS property
                              decoration: TextDecoration.underline,
                              color: primaryGray,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
                isEverythingLoaded() && !_isError
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                            itemCount: _reservations.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  _isReasonShow
                                      ? Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            color: authenGray,
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 75, 10, 20),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 30, 15, 30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Reason:',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.7),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _disabledReservation[index]
                                                    .disableReason,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedTimeSlots[index] =
                                            !_selectedTimeSlots[index];
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 18, 5, 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.25),
                                            offset: Offset(0, 4),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            activeColor: primaryGray,
                                            value: _selectedTimeSlots[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _selectedTimeSlots[index] =
                                                    value!;
                                              });
                                            },
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity: const VisualDensity(
                                                horizontal: 1, vertical: 1),
                                            hoverColor:
                                                primaryOrange.withOpacity(0.04),
                                            focusColor:
                                                primaryOrange.withOpacity(0.12),
                                          ),
                                          const SizedBox(
                                            width: 9,
                                          ), // Add some space between the checkbox and the text
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${_reservations[index].startTime.toString().substring(11, 16)} - ${_reservations[index].endTime.toString().substring(11, 16)}',
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 22,
                                                        color: primaryGray),
                                                  ),
                                                  Row(
                                                    children: const [
                                                      SizedBox(width: 8),
                                                      Icon(
                                                        Icons.block,
                                                        color: primaryGray,
                                                        size: 35,
                                                      ),
                                                      SizedBox(width: 13),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    : _isError
                        ? Container()
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                              shrinkWrap: true,
                              itemCount: 8, // increment by 1
                              itemBuilder: (context, index) {
                                // Builds a RadioListTile widget for each item in the list
                                return Theme(
                                  data: theme,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ListTileTheme(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 2),
                                      selectedColor: primaryOrange,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: RadioListTile(
                                            secondary: Container(
                                              width: 24,
                                              height: 24,
                                              margin: const EdgeInsets.only(
                                                  left: 15),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  width: 2,
                                                  color: primaryGray,
                                                ),
                                              ),
                                            ),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Shimmer.fromColors(
                                                    baseColor:
                                                        const Color.fromARGB(
                                                            255, 216, 216, 216),
                                                    highlightColor:
                                                        const Color.fromRGBO(
                                                            173,
                                                            173,
                                                            173,
                                                            0.824),
                                                    child: Container(
                                                      width: 150,
                                                      height: 30.0,
                                                      color: Colors.white,
                                                    )),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.people,
                                                        color: primaryGray,
                                                        size: 30),
                                                    const SizedBox(width: 4),
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              216,
                                                              216,
                                                              216),
                                                      highlightColor:
                                                          const Color.fromRGBO(
                                                              173,
                                                              173,
                                                              173,
                                                              0.824),
                                                      child: Container(
                                                        width: 40,
                                                        height: 30.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            value: index,
                                            groupValue: const [
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                              6,
                                              7,
                                              8
                                            ],
                                            onChanged: null,
                                            activeColor: Colors.white,
                                            selectedTileColor: primaryOrange,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
          if (isEverythingLoaded() &&
              !_selectedTimeSlots.every((element) => element == false)) ...[
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                color: const Color.fromRGBO(255, 255, 255, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 140,
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: primaryOrange,
                              width: 3,
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ), // Set the button background color to grey

                        onPressed: null,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "EDIT ", // Set the button text to "Disable"
                              style: TextStyle(
                                color: primaryOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                height: 1.5,
                              ),
                            ),
                            numOfSelectedTimeSlots > 1
                                ? Text(
                                    "($numOfSelectedTimeSlots)", // Set the button text to "Disable"
                                    style: const TextStyle(
                                      color: primaryOrange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      height: 1.5,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 140,
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: primaryGreen,
                              width: 3,
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ), // Set the button background color to grey
                        onPressed: () {
                          _selectedTimeSlots.asMap().forEach(
                            (index, isSelected) {
                              if (isSelected) {
                                _disableIds.add(
                                  _disabledReservation[index].disableId,
                                );
                              }
                            },
                          );
                          showEnableConfirmationModal(
                            context,
                            () async {
                              try {
                                Navigator.of(context).pop();
                                showLoadModal(context);
                                // Call createDisableReservation to disable the selected time slots
                                await FirebaseCloudStorage()
                                    .deleteDisableReservation(
                                      _disableIds,
                                    )
                                    .then(
                                      (_) => Navigator.of(context).pop(),
                                    )
                                    .then(
                                      (_) => showSuccessModal(context, false),
                                    )
                                    .then(
                                      (_) => Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                    .then(
                                      (_) => setState(
                                        () {
                                          _selectedTimeSlots = [];
                                        },
                                      ),
                                    )
                                    .then(
                                      (_) => fetchData(),
                                    );
                              } catch (e) {
                                showErrorModal(
                                  context,
                                  () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    fetchData();
                                  },
                                );
                              }
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "ENABLE ", // Set the button text to "Disable"
                              style: TextStyle(
                                color: primaryGreen,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                height: 1.5,
                              ),
                            ),
                            numOfSelectedTimeSlots > 1
                                ? Text(
                                    "($numOfSelectedTimeSlots)", // Set the button text to "Disable"
                                    style: const TextStyle(
                                      color: primaryGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      height: 1.5,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: primaryOrange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'EDIT DISABLE',
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
            left: 10,
            top: 65,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                shape: const CircleBorder(),
                fixedSize: const Size.fromRadius(25),
                elevation: 0,
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    ));
  }
}
