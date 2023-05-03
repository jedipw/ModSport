import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/reservation/function.dart';
import 'package:modsport/utilities/types.dart';
import 'package:modsport/views/disable_view.dart';
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
  bool _isReservationIdLoaded = false;
  bool _isZoneNameLoaded = false;

  String _firstDisableReason = '';
  String _zoneName = '';

  List<ReservationData> _reservations = [];
  List<DisableData> _disabledReservation = [];
  List<bool> _selectedTimeSlots = [];
  List<String> _reservationIds = [];
  List<String> _disableIds = [];

  @override
  void initState() {
    super.initState();
    fetchData(enterMode);
  }

  // Ensure that the data is fetched when entered this page for the second time and onward.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData(enterMode);
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

  Future<void> _getZoneName() async {
    try {
      // Get the zone data
      ZoneData zoneData = await FirebaseCloudStorage().getZone(widget.zoneId);
      String zoneName = zoneData.zoneName;
      // Update the state
      setState(() {
        _zoneName = zoneName;
        _isZoneNameLoaded = true;
      });
    } catch (e) {
      log('Error fetching zone name: $e');
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
  Future<void> fetchData(String mode) async {
    switch (mode) {
      case enterMode:
        await _getZoneName()
            .then((_) => _getReservationData())
            .then((_) => _getDisableReservationData())
            .then((_) => _getReservationIds());
        break;
      case adminMode:
        setState(
          () {
            _isReservationLoaded = false;
            _isDisableReservationLoaded = false;
            _isReservationIdLoaded = false;
          },
        );
        await _getReservationData()
            .then((_) => _getDisableReservationData())
            .then((_) => _getReservationIds());
        break;
    }
  }

  Future<void> _getReservationIds() async {
    try {
      List<DateTime?> reservationTimes = [];

      // From reservation data that is not disabled, extract only the startTime.
      for (int i = 0; i < _reservations.length; i++) {
        if (isDisable(
          _reservations[i].startTime,
          _disabledReservation,
        )) {
          reservationTimes.add(_reservations[i].startTime);
        }
      }

      // Get reservation ID from list of startTime
      List<String> reservations =
          await FirebaseCloudStorage().getReservationIds(
        reservationTimes,
        widget.zoneId,
      );

      // Update the state
      if (mounted) {
        setState(() {
          _reservationIds = reservations;
          _isReservationIdLoaded = true;
        });
      }
    } catch (e) {
      handleError();
    }
  }

  // Used to check whether every disable reason in the same day is the same
  bool checkSameDisableReasonAndDate(
      List<DisableData> disableDatas, DateTime date) {
    List<DisableData> disables = [];
    _selectedTimeSlots.asMap().forEach((index, isSelected) {
      if (isSelected) {
        disables.add(
          _disabledReservation[index],
        );
      }
    });

    if (disables.isEmpty) {
      // If the list is empty, there's no disableReason to compare against.
      return true;
    }

    final Map<String, List<DisableData>> groupedData = {};

    // Group the data by year, month, and day
    for (var data in disables) {
      final dateKey =
          '${data.startDateTime.year}-${data.startDateTime.month}-${data.startDateTime.day}';
      groupedData.putIfAbsent(dateKey, () => []).add(data);
    }

    // Check if every group for the given date has the same disableReason
    final dateKey = '${date.year}-${date.month}-${date.day}';
    if (!groupedData.containsKey(dateKey)) {
      // If there's no group for the given date, there's no disableReason to compare against.
      return true;
    }

    final group = groupedData[dateKey];
    final disableReason = group!.first.disableReason;
    // Update the state
    if (mounted) {
      setState(
        () {
          _firstDisableReason = disableReason;
        },
      );
    }

    return group.every((data) => data.disableReason == disableReason);
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
      return _isReservationLoaded &&
          _isDisableReservationLoaded &&
          _isReservationIdLoaded &&
          _isZoneNameLoaded;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 140),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              '${_getDayOrdinal(currentDate.day)} ${DateFormat('MMMM').format(currentDate)} ${currentDate.year}',
                              style: const TextStyle(
                                color: staffOrange,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _zoneName,
                              style: const TextStyle(
                                color: staffOrange,
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
                        const SizedBox(height: 8),
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
                    if (checkSameDisableReasonAndDate(
                      _disabledReservation,
                      DateTime.now().add(
                        Duration(
                          days: widget.selectedDateIndex,
                        ),
                      ),
                    ))
                      SizedBox(
                        height: 55,
                        width: 140,
                        child: TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: staffOrange,
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
                            _disableIds = [];
                            _selectedTimeSlots.asMap().forEach(
                              (index, isSelected) {
                                if (isSelected) {
                                  _disableIds.add(
                                    _disabledReservation[index].disableId,
                                  );
                                }
                              },
                            );

                            _reservationIds = [];
                            _selectedTimeSlots.asMap().forEach(
                              (index, isSelected) {
                                if (isSelected) {
                                  _reservationIds.add(
                                    _reservations[index].reservationId,
                                  );
                                }
                              },
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => DisableView(
                                  disableIds: _disableIds,
                                  zoneId: widget.zoneId,
                                  reservationIds: _reservationIds,
                                  reason: _firstDisableReason,
                                  selectedDateIndex: widget.selectedDateIndex,
                                  mode: editMode,
                                ),
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
                                  (_) => fetchData(adminMode),
                                );
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "EDIT ", // Set the button text to "Disable"
                                style: TextStyle(
                                  color: staffOrange,
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
                          _disableIds = [];
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
                                      (_) => setState(
                                        () {
                                          _selectedTimeSlots = [];
                                        },
                                      ),
                                    )
                                    .then(
                                      (_) => fetchData(adminMode),
                                    );
                              } catch (e) {
                                showErrorModal(
                                  context,
                                  () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    fetchData(adminMode);
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
          Positioned(
            top: 130,
            right: 20,
            child: TextButton(
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
          ),
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: staffOrange,
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
                backgroundColor: staffOrange,
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
