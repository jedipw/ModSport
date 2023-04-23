// Import a neccesary package from Flutter.
import 'package:flutter/material.dart';

// Import constants
import 'package:modsport/constants/mode.dart';

// Import firebase cloud storage
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

// Import reservation page's utilities
import 'package:modsport/utilities/reservation/date_list.dart';
import 'package:modsport/utilities/reservation/edit_button.dart';
import 'package:modsport/utilities/reservation/enable_button.dart';
import 'package:modsport/utilities/reservation/function.dart';
import 'package:modsport/utilities/reservation/time_slot_disable.dart';
import 'package:modsport/utilities/reservation/time_slot_loading.dart';
import 'package:modsport/utilities/reservation/time_slot_reserve.dart';
import 'package:modsport/utilities/reservation/reserve_button.dart';
import 'package:modsport/utilities/reservation/disable_button.dart';
import 'package:modsport/utilities/reservation/error_message.dart';
import 'package:modsport/utilities/reservation/location_name.dart';
import 'package:modsport/utilities/reservation/no_reservation_message.dart';
import 'package:modsport/utilities/reservation/role_name.dart';
import 'package:modsport/utilities/reservation/toggle_role_button.dart';
import 'package:modsport/utilities/reservation/zone_name.dart';
import 'package:modsport/utilities/reservation/go_back_button.dart';
import 'package:modsport/utilities/reservation/zone_img.dart';

// Import global utilities
import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/types.dart';

// Import disable page
import 'package:modsport/views/disable_view.dart';

// Imaginary user database (will be removed later)
const bool hasRole = true;
const String userId = 'Dgi6rfj8wyDMuZ8WagFT';

// Number of Dates that will appear in the date list for normal user
const int numOfUserDay = 7;

// Creating a StatefulWidget called ReservationView
class ReservationView extends StatefulWidget {
  const ReservationView({super.key, required this.zoneId});

  // Get zone ID that is sent from the home page.
  final String zoneId;

  // Override method to create a State object
  @override
  State<ReservationView> createState() => _ReservationViewState();
}

// Creating a State object called _ReservationViewState
class _ReservationViewState extends State<ReservationView> {
  // Variables that determine whether the data has been successfully retrieve from database
  bool _isReservationLoaded = false;
  bool _isZoneLoaded = false;
  bool _isLocationLoaded = false;
  bool _isDisableReservationLoaded = false;
  bool _isUserReservationLoaded = false;
  bool _isReservedLoaded = false;
  bool _isReservationIndexLoaded = false;
  bool _isReservationIdLoaded = true;

  // All boolean variables
  bool _isReserved = false;
  bool _isDisableMenu = false;
  bool _isError = false;

  // All integer variables
  int _selectedDateIndex = 0;
  int _selectedTimeSlot = 0;

  // All string variables
  String _imgUrl = '';
  String _locationName = '';
  String _locationId = '';
  String _zoneName = '';
  String _firstDisableReason = '';

  // All lists
  List<String> _reservationIds = [];
  List<String> _disableIds = [];
  List<bool?> _selectedTimeSlots = [];
  List<ReservationData> _reservations = [];
  List<DisableData> _disabledReservation = [];
  List<UserReservationData> _userReservation = [];

  // Ensure that the data is fetched when entered this page for the first time.
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

  // Used to check whether every disable reason in the same day is the same
  bool checkSameDisableReasonAndDate(
      List<DisableData> disableDatas, DateTime date) {
    if (disableDatas.isEmpty) {
      // If the list is empty, there's no disableReason to compare against.
      return true;
    }

    final Map<String, List<DisableData>> groupedData = {};

    // Group the data by year, month, and day
    for (var data in disableDatas) {
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

  Future<void> _getZoneData() async {
    try {
      // Get the zone data
      ZoneData zoneData = await FirebaseCloudStorage().getZone(widget.zoneId);
      String locationId = zoneData.locationId;
      String zoneName = zoneData.zoneName;
      String imgUrl = zoneData.imgUrl;

      // Update the state
      if (mounted) {
        setState(
          () {
            _imgUrl = imgUrl;
            _locationId = locationId;
            _zoneName = zoneName;
            _isZoneLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getLocationData() async {
    try {
      // Get the location data
      String locationData =
          await FirebaseCloudStorage().getLocation(_locationId);

      // Extract the locationName from the location data
      String locationName = locationData;

      // Update the state
      if (mounted) {
        setState(
          () {
            _locationName = locationName;
            _isLocationLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getReservationData() async {
    try {
      // Get reservation (time slot) data
      List<ReservationData> reservations = await FirebaseCloudStorage()
          .getReservation(widget.zoneId, _isDisableMenu, _selectedDateIndex);

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

  Future<void> _getUserReservationData() async {
    try {
      // Get user reservation data
      List<UserReservationData> userRes =
          await FirebaseCloudStorage().getAllUserReservation(widget.zoneId);

      // Update the state
      if (mounted) {
        setState(
          () {
            _userReservation = userRes;
            _isUserReservationLoaded = true;
          },
        );
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getDisableReservationData() async {
    try {
      final DateTime selectedDate =
          DateTime.now().add(Duration(days: _selectedDateIndex));

      // Get disable reservation data
      List<DisableData> disable =
          await FirebaseCloudStorage().getDisableReservation(widget.zoneId);

      // Update the state
      if (mounted) {
        setState(
          () {
            _disabledReservation = disable;
            _isDisableReservationLoaded = true;
            _disableIds = disable
                .where(
                  (data) =>
                      data.startDateTime.year == selectedDate.year &&
                      data.startDateTime.month == selectedDate.month &&
                      data.startDateTime.day == selectedDate.day,
                )
                .map(
                  (data) => data.disableId,
                )
                .toList();
          },
        );
      }
    } catch (e) {
      handleError();
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

  Future<void> _getReservationIndexData() async {
    try {
      if (_reservations.isNotEmpty) {
        // Get the time slot index that the user has reserved.
        int reservationIndex =
            await FirebaseCloudStorage().getUserReservationIndex(
          _reservations,
          userId,
          widget.zoneId,
        );

        // Update the state
        if (mounted) {
          setState(() {
            _selectedTimeSlot = reservationIndex;
            _isReservationIndexLoaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isReservationIndexLoaded = true;
          });
        }
      }
    } catch (e) {
      handleError();
    }
  }

  void removeInvalidReservation() {
    List<ReservationData> invalidReservations = [];
    // Check if number of user reservation has exceeded the capacity and user is the one who reserved it
    for (int i = 0; i < _reservations.length; i++) {
      int numReservations =
          countNumOfReservation(_reservations[i].startTime, _userReservation);
      if (numReservations >= _reservations[i].capacity! &&
          i != _selectedTimeSlot &&
          !_isDisableMenu) {
        invalidReservations.add(_reservations[i]);
      }
    }

    // Remove invalid reservations
    for (int i = 0; i < invalidReservations.length; i++) {
      if (mounted) {
        setState(
          () {
            _reservations.remove(invalidReservations[i]);
          },
        );
      }
    }
  }

  Future<void> _getIsReservedData() async {
    try {
      if (_reservations.isNotEmpty) {
        final DateTime selectedDate =
            DateTime.now().add(Duration(days: _selectedDateIndex));

        // Get a boolean that determines whether user has reserved any time slot in selected date
        bool isUserReserved = await FirebaseCloudStorage().getIsUserReserved(
            userId,
            widget.zoneId,
            selectedDate,
            _reservations,
            _selectedTimeSlot);

        // Update the state
        if (mounted) {
          setState(
            () {
              _isReserved = isUserReserved;
              _isReservedLoaded = true;
            },
          );
        }
      } else {
        // If no reservation is available, just update the state
        if (mounted) {
          _isReservedLoaded = true;
        }
      }
    } catch (e) {
      handleError();
    }
  }

  // Fetch the data from the database
  Future<void> fetchData(String mode) async {
    switch (mode) {
      // When enter the page
      case enterMode:
        await _getZoneData()
            .then(
              (_) => _getLocationData(),
            )
            .then(
              (_) => _getReservationData(),
            )
            .then(
              (_) => _getUserReservationData(),
            )
            .then(
              (_) => _getDisableReservationData(),
            )
            .then(
              (_) => _getReservationIndexData(),
            )
            .then(
              (_) => removeInvalidReservation(),
            )
            .then(
              (_) => _getIsReservedData(),
            );
        break;

      // When reload in the user page
      case userMode:
        setState(
          () {
            _isReservationLoaded = false;
            _isUserReservationLoaded = false;
            _isDisableReservationLoaded = false;
            _isReservedLoaded = false;
            _isReservationIndexLoaded = false;
          },
        );
        await _getReservationData()
            .then(
              (_) => _getUserReservationData(),
            )
            .then(
              (_) => _getDisableReservationData(),
            )
            .then(
              (_) => _getReservationIndexData(),
            )
            .then(
              (_) => removeInvalidReservation(),
            )
            .then(
              (_) => _getIsReservedData(),
            );
        break;

      // When reload in the admin page
      case adminMode:
        setState(
          () {
            _isReservationLoaded = false;
            _isUserReservationLoaded = false;
            _isDisableReservationLoaded = false;
            _isReservationIdLoaded = false;
          },
        );
        await _getReservationData()
            .then(
              (_) => _getUserReservationData(),
            )
            .then(
              (_) => _getDisableReservationData(),
            )
            .then(
              (_) => _getReservationIds(),
            );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if every data has been retrieved from the database
    bool isEverythingLoaded() {
      return _isReservationLoaded &&
          _isZoneLoaded &&
          _isLocationLoaded &&
          _isDisableReservationLoaded &&
          _isUserReservationLoaded &&
          _isReservationIdLoaded &&
          _isReservedLoaded &&
          _isReservationIndexLoaded;
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Use a Stack widget to position the arrow button on top of the image
            Stack(
              children: [
                // The zone image
                ZoneImg(isError: _isError, imgUrl: _imgUrl),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      children: const [
                        SizedBox(width: 12),
                        // Go back button
                        GoBackButton(),
                      ],
                    ),
                  ],
                ),
                // White container that has circular border on top left and top right
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 200),
                  ),
                ),
              ],
            ),

            Stack(
              children: [
                Positioned(
                  left: 25,
                  child:
                      // Zone name
                      ZoneName(
                    isError: _isError,
                    isZoneLoaded: _isZoneLoaded,
                    zoneName: _zoneName,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                  child:
                      // Location name
                      LocationName(
                    isError: _isError,
                    isLocationLoaded: _isLocationLoaded,
                    locationName: _locationName,
                  ),
                ),
                // If user has staff role, show toggle role button.
                if (hasRole) ...[
                  Positioned(
                    right: 20,
                    child:
                        // Toggle role button
                        ToggleRoleButton(
                      isError: _isError,
                      isDisableMenu: _isDisableMenu,
                      isEverythingLoaded: isEverythingLoaded(),
                      onPressed: () {
                        // If currently in disable menu, no error, and everything is loaded
                        if (_isDisableMenu &&
                            !_isError &&
                            isEverythingLoaded()) {
                          // Switch to user menu
                          setState(
                            () {
                              _isDisableMenu = false;
                              _selectedDateIndex =
                                  _selectedDateIndex > numOfUserDay - 1
                                      ? numOfUserDay - 1
                                      : _selectedDateIndex;
                            },
                          );
                          fetchData(userMode);
                          // If currently not in disable menu, no error, and everything is loaded
                        } else if (!_isDisableMenu &&
                            !_isError &&
                            isEverythingLoaded()) {
                          // Switch to disable menu
                          setState(
                            () {
                              _selectedTimeSlots = [];
                              _isDisableMenu = true;
                            },
                          );
                          fetchData(adminMode);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 65,
                    child:
                        // Role name (User or Admin)
                        RoleName(
                      isDisableMenu: _isDisableMenu,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  // List of date
                  child: DateList(
                    isEverythingLoaded: isEverythingLoaded(),
                    isError: _isError,
                    numOfUserDay: numOfUserDay,
                    isDisableMenu: _isDisableMenu,
                    selectedIndex: _selectedDateIndex,
                    hasRole: hasRole,
                    onSelected: (index) {
                      if (index != _selectedDateIndex &&
                          !_isError &&
                          isEverythingLoaded()) {
                        setState(
                          () {
                            _selectedDateIndex = index;
                            if (_isDisableMenu) {
                              _selectedTimeSlots = [];
                            }
                          },
                        );
                        fetchData(_isDisableMenu ? adminMode : userMode);
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: _isError
                        ? Container()
                        : isEverythingLoaded()
                            ? _isDisableMenu
                                // If you are in disable menu, show TimeSlotDisable
                                ? TimeSlotDisable(
                                    userReservation: _userReservation,
                                    reservation: _reservations,
                                    selectedTimeSlots: _selectedTimeSlots,
                                    disabledReservation: _disabledReservation,
                                    onChanged: (int index, bool? value) {
                                      setState(() {
                                        _selectedTimeSlots[index] = value;
                                      });
                                    },
                                  )
                                // If you are in user menu, show TimeSlotReserve
                                : TimeSlotReserve(
                                    reservation: _reservations,
                                    disabledReservation: _disabledReservation,
                                    userReservation: _userReservation,
                                    selectedDateIndex: _selectedDateIndex,
                                    selectedTimeSlot: _selectedTimeSlot,
                                    isReserved: _isReserved,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedTimeSlot = value!;
                                        _isReserved = false;
                                      });
                                    },
                                  )
                            // If data has not been fetched, show TimeSlotLoading
                            : const TimeSlotLoading(),
                  ),
                  if (_isError) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: const
                              // Show error message
                              ErrorMessage(),
                        ),
                      ],
                    ),
                  ] else if (!_isError &&
                      _reservations.isEmpty &&
                      isEverythingLoaded()) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: const
                              // Show that there is no reservation (show the message).
                              NoReservationMessage(),
                        ),
                      ],
                    ),
                  ],
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.75),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (isEverythingLoaded() && !_isError) ...[
                            if (_selectedDateIndex < 7 &&
                                _reservations.isNotEmpty &&
                                !isDisable(
                                    _reservations[_selectedTimeSlot].startTime,
                                    _disabledReservation) &&
                                !_isDisableMenu)
                              ReserveButton(
                                isReserved: _isReserved,
                                onPressed: () async {
                                  if (_isReserved) {
                                    showConfirmationModal(
                                      context,
                                      () async {
                                        Navigator.of(context).pop();
                                        showLoadModal(context);
                                        try {
                                          await FirebaseCloudStorage()
                                              .deleteUserReservation(
                                                userId,
                                                widget.zoneId,
                                                _reservations[_selectedTimeSlot]
                                                    .startTime!,
                                              )
                                              .then(
                                                (_) =>
                                                    Navigator.of(context).pop(),
                                              )
                                              .then(
                                                (_) => showSuccessModal(
                                                    context, false),
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
                                                    _isReserved = false;
                                                  },
                                                ),
                                              )
                                              .then(
                                                (_) => fetchData(userMode),
                                              );
                                        } catch (e) {
                                          showErrorModal(
                                            context,
                                            () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              fetchData(userMode);
                                            },
                                          );
                                        }
                                      },
                                      true,
                                      cancelMode,
                                    );
                                  } else {
                                    showLoadModal(context);
                                    try {
                                      await FirebaseCloudStorage()
                                          .createUserReservation(
                                            _reservations[_selectedTimeSlot]
                                                .startTime!,
                                            userId,
                                            widget.zoneId,
                                            _reservations[_selectedTimeSlot]
                                                .capacity!,
                                          )
                                          .then(
                                            (_) => Navigator.of(context).pop(),
                                          )
                                          .then(
                                            (_) => showSuccessModal(
                                                context, false),
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
                                                _isReserved = true;
                                              },
                                            ),
                                          )
                                          .then(
                                            (_) => fetchData(userMode),
                                          );
                                    } catch (e) {
                                      showErrorModal(
                                        context,
                                        () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          fetchData(userMode);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            if ((_isDisableMenu == true &&
                                _selectedTimeSlots
                                    .every((element) => element == false) &&
                                _reservations.any(
                                  (reservation) {
                                    return _reservations.any(
                                      (reservation) {
                                        return _disabledReservation
                                            .map(
                                              (disabledData) =>
                                                  disabledData.startDateTime,
                                            )
                                            .any(
                                              (disabledDateTime) =>
                                                  disabledDateTime.year == reservation.startTime!.year &&
                                                  disabledDateTime.month ==
                                                      reservation
                                                          .startTime!.month &&
                                                  disabledDateTime.day ==
                                                      reservation
                                                          .startTime!.day &&
                                                  disabledDateTime.hour ==
                                                      reservation
                                                          .startTime!.hour &&
                                                  disabledDateTime.minute ==
                                                      reservation
                                                          .startTime!.minute &&
                                                  disabledDateTime.second ==
                                                      reservation
                                                          .startTime!.second,
                                            );
                                      },
                                    );
                                  },
                                ))) ...[
                              if (checkSameDisableReasonAndDate(
                                _disabledReservation,
                                DateTime.now().add(
                                  Duration(
                                    days: _selectedDateIndex,
                                  ),
                                ),
                              )) ...[
                                // Edit button
                                EditButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => DisableView(
                                          disableIds: _disableIds,
                                          zoneId: widget.zoneId,
                                          reservationIds: _reservationIds,
                                          reason: _firstDisableReason,
                                          selectedDateIndex: _selectedDateIndex,
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
                                          (_) => fetchData(
                                            adminMode,
                                          ),
                                        );
                                  },
                                )
                              ],
                              // Enable button
                              EnableButton(
                                onPressed: () {
                                  showConfirmationModal(
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
                                              (_) =>
                                                  Navigator.of(context).pop(),
                                            )
                                            .then(
                                              (_) => showSuccessModal(
                                                  context, false),
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
                                              (_) => fetchData(adminMode),
                                            );
                                      } catch (e) {
                                        showErrorModal(
                                          context,
                                          () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            fetchData(userMode);
                                          },
                                        );
                                      }
                                    },
                                    true,
                                    enableMode,
                                  );
                                },
                              ),
                            ] else if (!_selectedTimeSlots
                                    .every((element) => element == false) &&
                                _isDisableMenu == true) ...[
                              DisableButton(
                                isDisableMenu: _isDisableMenu,
                                selectedTimeSlots: _selectedTimeSlots,
                                onPressed: () {
                                  _reservationIds = [];
                                  _selectedTimeSlots.asMap().forEach(
                                    (index, isSelected) {
                                      if (isSelected!) {
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
                                        selectedDateIndex: _selectedDateIndex,
                                        mode: disableMode,
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
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
