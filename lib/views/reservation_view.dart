import 'dart:developer' show log;
import 'package:flutter/material.dart';

import 'package:modsport/constants/mode.dart';

import 'package:modsport/services/cloud/firebase_cloud_storage.dart';

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

import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/types.dart';

import 'package:modsport/views/disable_view.dart';

const bool hasRole = true;
const int numOfUserDay = 7;
const String userId = 'Dgi6rfj8wyDMuZ8WagFT';

// Creating a StatefulWidget called ReservationView
class ReservationView extends StatefulWidget {
  const ReservationView({super.key, required this.zoneId});

  final String zoneId;

  // Override method to create a State object
  @override
  State<ReservationView> createState() => _ReservationViewState();
}

// Creating a State object called _ReservationViewState
class _ReservationViewState extends State<ReservationView> {
  bool _isReservationLoaded = false;
  bool _isZoneLoaded = false;
  bool _isLocationLoaded = false;
  bool _isDisableReservationLoaded = false;
  bool _isUserReservationLoaded = false;
  bool _isReservedLoaded = false;
  bool _isReservationIndexLoaded = false;
  bool _isReservationIdLoaded = true;

  bool _isReserved = false;
  bool _isDisableMenu = false;
  bool _isError = false;

  int _selectedDateIndex = 0;
  int _selectedTimeSlot = 0;

  String _imgUrl = '';
  String _locationName = '';
  String _locationId = '';
  String _zoneName = '';
  String _firstDisableReason = '';

  List<String> _reservationIds = [];
  List<String> _disableIds = [];
  List<bool?> _selectedTimeSlots = [];
  List<ReservationData> _reservations = [];
  List<DisableData> _disabledReservation = [];
  List<UserReservationData> _userReservation = [];

  @override
  void initState() {
    super.initState();
    fetchData(firstMode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData(firstMode);
  }

  void handleError() {
    if (mounted) {
      setState(() {
        _isError = true;
      });
    }
  }

  Future<void> _getReservationIndexData() async {
    try {
      if (_reservations.isNotEmpty) {
        int reservationIndex;
        if (_isReserved) {
          reservationIndex = await FirebaseCloudStorage()
              .getUserReservationIndex(_reservations, userId, widget.zoneId);
        } else {
          reservationIndex = 0;
        }
        if (mounted) {
          setState(() {
            _selectedTimeSlot = reservationIndex;
            _isReservationIndexLoaded = true;
          });
        }

        List<ReservationData> invalidReservations = [];
        for (int i = 0; i < _reservations.length; i++) {
          int numReservations = countNumOfReservation(
              _reservations[i].startTime, _userReservation);
          if (numReservations >= _reservations[i].capacity! &&
              i != _selectedTimeSlot &&
              !_isDisableMenu) {
            invalidReservations.add(_reservations[i]);
          }
        }

        // Remove invalid reservations
        for (int i = 0; i < invalidReservations.length; i++) {
          if (mounted) {
            setState(() {
              _reservations.remove(invalidReservations[i]);
            });
          }
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

  Future<void> _getIsReservedData() async {
    try {
      if (_reservations.isNotEmpty) {
        bool isUserReserved = await FirebaseCloudStorage().getIsUserReserved(
            userId,
            widget.zoneId,
            DateTime.now().add(Duration(days: _selectedDateIndex)),
            _reservations,
            _selectedTimeSlot);

        if (mounted) {
          setState(() {
            _isReserved = isUserReserved;
            _isReservedLoaded = true;
          });
        }
      } else {
        if (mounted) {
          _isReservedLoaded = true;
        }
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getUserReservationData() async {
    try {
      List<UserReservationData> userRes =
          await FirebaseCloudStorage().getAllUserReservation(widget.zoneId);
      if (mounted) {
        setState(() {
          _userReservation = userRes;
          _isUserReservationLoaded = true;
        });
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getReservationIds() async {
    try {
      List<DateTime?> reservationTimes = [];
      for (int i = 0; i < _reservations.length; i++) {
        if (isDisable(_reservations[i].startTime, _disabledReservation)) {
          reservationTimes.add(_reservations[i].startTime);
        }
      }
      List<String> reservations = await FirebaseCloudStorage()
          .getReservationIds(reservationTimes, widget.zoneId);
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

  Future<void> _getDisableReservationData() async {
    try {
      final DateTime now =
          DateTime.now().add(Duration(days: _selectedDateIndex));
      List<DisableData> disable =
          await FirebaseCloudStorage().getDisableReservation(widget.zoneId);
      if (mounted) {
        setState(() {
          _disabledReservation = disable;
          _isDisableReservationLoaded = true;
          _disableIds = disable
              .where((data) =>
                  data.startDateTime.year == now.year &&
                  data.startDateTime.month == now.month &&
                  data.startDateTime.day == now.day)
              .map((data) => data.disableId)
              .toList();
        });
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> _getReservationData() async {
    try {
      List<ReservationData> reservations = await FirebaseCloudStorage()
          .getReservation(widget.zoneId, _isDisableMenu, _selectedDateIndex);

      if (mounted) {
        setState(() {
          _reservations = reservations;
          _isReservationLoaded = true;
          if (_selectedTimeSlots.isEmpty) {
            _selectedTimeSlots =
                List.generate(reservations.length, (index) => false);
          }
        });
      }
    } catch (e) {
      handleError();
    }
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
        setState(() {
          _imgUrl = imgUrl;
          _locationId = locationId;
          _zoneName = zoneName;
          _isZoneLoaded = true;
        });
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

      // Extract the imgUrl and locationName from the location data
      String locationName = locationData;

      // Update the state with the imgUrl
      if (mounted) {
        setState(() {
          _locationName = locationName;
          _isLocationLoaded = true;
        });
      }
    } catch (e) {
      handleError();
    }
  }

  Future<void> fetchData(String mode) async {
    switch (mode) {
      case firstMode:
        await _getZoneData()
            .then((_) => _getLocationData())
            .then((_) => _getReservationData())
            .then((_) => _getUserReservationData())
            .then((_) => _getDisableReservationData())
            .then((_) => _getIsReservedData())
            .then((_) => _getReservationIndexData());
        break;
      case userMode:
        setState(() {
          _isReservationLoaded = false;
          _isUserReservationLoaded = false;
          _isDisableReservationLoaded = false;
          _isReservedLoaded = false;
          _isReservationIndexLoaded = false;
        });
        await _getReservationData()
            .then((_) => _getUserReservationData())
            .then((_) => _getDisableReservationData())
            .then((_) => _getIsReservedData())
            .then((_) => _getReservationIndexData());
        break;
      case adminMode:
        setState(() {
          _isReservationLoaded = false;
          _isUserReservationLoaded = false;
          _isDisableReservationLoaded = false;
          _isReservationIdLoaded = false;
        });
        await _getReservationData()
            .then((_) => _getUserReservationData())
            .then((_) => _getDisableReservationData())
            .then((_) => _getReservationIds());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      if (mounted) {
        setState(() {
          _firstDisableReason = disableReason;
        });
      }

      return group.every((data) => data.disableReason == disableReason);
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Use a Stack widget to position the arrow button on top of the image
            Stack(
              children: [
                ZoneImg(isError: _isError, imgUrl: _imgUrl),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      children: const [
                        SizedBox(width: 12),
                        GoBackButton(),
                      ],
                    ),
                  ],
                ),
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
                  child: ZoneName(
                    isError: _isError,
                    isZoneLoaded: _isZoneLoaded,
                    zoneName: _zoneName,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                  child: LocationName(
                    isError: _isError,
                    isLocationLoaded: _isLocationLoaded,
                    locationName: _locationName,
                  ),
                ),
                if (hasRole) ...[
                  Positioned(
                    right: 20,
                    child: ToggleRoleButton(
                      onPressed: () {
                        if (_isDisableMenu &&
                            !_isError &&
                            isEverythingLoaded()) {
                          setState(() {
                            _isDisableMenu = false;
                            _selectedDateIndex =
                                _selectedDateIndex > numOfUserDay - 1
                                    ? numOfUserDay - 1
                                    : _selectedDateIndex;
                          });
                          // If isDisableMenu is true, disable the menu and update the widget state
                          fetchData(userMode);
                        } else if (!_isDisableMenu &&
                            !_isError &&
                            isEverythingLoaded()) {
                          setState(() {
                            _selectedTimeSlots = [];
                            _isDisableMenu = true;
                          });
                          // If isDisableMenu is false, enable the menu and update the widget state
                          fetchData(adminMode);
                        }
                      },
                      isError: _isError,
                      isDisableMenu: _isDisableMenu,
                      isEverythingLoaded: isEverythingLoaded(),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 65,
                    child: RoleName(isDisableMenu: _isDisableMenu),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DateList(
                    isEverythingLoaded: isEverythingLoaded(),
                    isError: _isError,
                    numOfUserDay: numOfUserDay,
                    isDisableMenu: _isDisableMenu,
                    selectedIndex: _selectedDateIndex,
                    onSelected: (index) {
                      if (index != _selectedDateIndex &&
                          !_isError &&
                          isEverythingLoaded()) {
                        setState(() {
                          _selectedDateIndex = index;
                          _selectedTimeSlots = [];
                        });
                        fetchData(_isDisableMenu ? adminMode : userMode);
                      }
                    },
                    hasRole: hasRole,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: _isError
                        ? Container()
                        : isEverythingLoaded()
                            ? _isDisableMenu
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
                            : const TimeSlotLoading(),
                  ),
                  if (_isError) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: const ErrorMessage(),
                        ),
                      ],
                    )
                  ] else if (!_isError &&
                      _reservations.isEmpty &&
                      isEverythingLoaded()) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: const NoReservationMessage(),
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
                                        await FirebaseCloudStorage()
                                            .deleteUserReservation(
                                                userId,
                                                widget.zoneId,
                                                _reservations[_selectedTimeSlot]
                                                    .startTime!)
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
                                      },
                                      true,
                                      cancelMode,
                                    );
                                  } else {
                                    showLoadModal(context);
                                    await FirebaseCloudStorage()
                                        .createUserReservation(
                                            _reservations[_selectedTimeSlot]
                                                .startTime!,
                                            userId,
                                            widget.zoneId,
                                            _reservations[_selectedTimeSlot]
                                                .capacity!)
                                        .then(
                                          (_) => Navigator.of(context).pop(),
                                        )
                                        .then(
                                          (_) =>
                                              showSuccessModal(context, false),
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
                                            .map((disabledData) =>
                                                disabledData.startDateTime)
                                            .any((disabledDateTime) =>
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
                                                        .startTime!.second);
                                      },
                                    );
                                  },
                                ))) ...[
                              if (checkSameDisableReasonAndDate(
                                _disabledReservation,
                                DateTime.now().add(
                                  Duration(days: _selectedDateIndex),
                                ),
                              )) ...[
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
                                          (_) => fetchData(adminMode),
                                        );
                                  },
                                )
                              ],
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
                                                _disableIds)
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
                                        // Handle error
                                        log('Error enable reservation: $e');
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
                                            _reservations[index].reservationId);
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
                            ]
                          ]
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
