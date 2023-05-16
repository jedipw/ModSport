import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/disable/close_button.dart';

import 'package:modsport/utilities/disable/date.dart';
import 'package:modsport/utilities/disable/error_message.dart';
import 'package:modsport/utilities/disable/facility.dart';
import 'package:modsport/utilities/disable/finish_button.dart';

import 'package:modsport/utilities/disable/text_style.dart';
import 'package:modsport/utilities/disable/time.dart';

import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/types.dart';

class DisableView extends StatefulWidget {
  final String zoneId;
  final String mode;
  final String reason;

  final int selectedDateIndex;

  final List<String> disableIds;
  final List<String> reservationIds;

  const DisableView({
    super.key,
    required this.disableIds,
    required this.zoneId,
    required this.reservationIds,
    required this.selectedDateIndex,
    required this.mode,
    this.reason = '',
  });

  @override
  State<DisableView> createState() => _DisableViewState();
}

class _DisableViewState extends State<DisableView> {
  bool _isZoneNameLoaded = false;
  bool _isReservationTimeLoaded = false;
  bool _isError = false;

  int numOfCharacter = 0;

  double _textFieldWidth = double.infinity;

  String _zoneName = '';

  TextEditingController reasonController = TextEditingController();

  List<Map<String, dynamic>> reservationTimes = [];
  List<Timestamp> startTimes = [];

  @override
  void initState() {
    super.initState();
    _getZoneName();
    _getReservationTime();
    reasonController = TextEditingController(text: widget.reason);
    numOfCharacter = reasonController.text.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getZoneName();
    _getReservationTime();
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
      handleError();
    }
  }

  Future<void> _getReservationTime() async {
    try {
      List<Map<String, dynamic>> reservation = await FirebaseCloudStorage()
          .getReservationTime(widget.reservationIds, widget.selectedDateIndex);
      setState(() {
        reservationTimes = reservation;
        startTimes = reservation
            .map((time) => Timestamp.fromDate(time[startTimeField]))
            .toList();

        _isReservationTimeLoaded = true;
      });
    } catch (e) {
      handleError();
    }
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    reasonController.dispose();
    super.dispose();
  }

  // The build method returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    Platform.isIOS
        ? widget.mode == editMode
            ? SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor:
                      Colors.black, // set to Colors.black for black color
                ),
              )
            : SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.light.copyWith(
                  statusBarColor:
                      Colors.white, // set to Colors.black for black color
                ),
              )
        : null;
    return Scaffold(
      // A Center widget containing a Text widget
      body: Stack(
        children: [
          SingleChildScrollView(
            child: !_isError
                ? Column(
                    children: [
                      const SizedBox(height: 150),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(35, 20, 35, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FacilityName(
                                  isZoneNameLoaded: _isZoneNameLoaded,
                                  zoneName: _zoneName,
                                ),
                                DateDetail(
                                  isReservationTimeLoaded:
                                      _isReservationTimeLoaded,
                                  reservationTimes: reservationTimes,
                                ),
                                TimeDetail(
                                  isReservationTimeLoaded:
                                      _isReservationTimeLoaded,
                                  reservationTimes: reservationTimes,
                                ),
                                const SizedBox(height: 50),
                                Text('Reason:', style: topTextStyle),
                                if (numOfCharacter < 10) ...[
                                  Text(
                                    'Type at least 10 characters!',
                                    style: bottomTextStyle,
                                  ),
                                ] else if (numOfCharacter > 250) ...[
                                  Text(
                                    'Don\'t type more than 250 characters!',
                                    style: bottomTextStyle,
                                  ),
                                ] else ...[
                                  const SizedBox(height: 21),
                                ],
                                LayoutBuilder(
                                  builder: (context, constraint) {
                                    return SizedBox(
                                      width: _textFieldWidth,
                                      child: Stack(
                                        children: [
                                          TextField(
                                            cursorColor: Colors.black,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: reasonController,
                                            maxLines: null,
                                            minLines: 1,
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            cursorWidth: 1.0,
                                            cursorRadius:
                                                const Radius.circular(1.0),
                                            autofocus: true,
                                            onChanged: (_) {
                                              setState(() {
                                                numOfCharacter =
                                                    reasonController
                                                        .text.length;
                                              });
                                            },
                                            onEditingComplete: () {
                                              setState(() {
                                                _textFieldWidth =
                                                    constraint.maxWidth;
                                              });
                                            },
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.0,
                                              height: 20.0 / 13.0,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$numOfCharacter/250',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height:
                                              1.5, // or line-height: 21px, which is equivalent to 1.5 times the font size
                                          color: numOfCharacter < 10 ||
                                                  numOfCharacter > 250
                                              ? secondaryOrange
                                              : primaryGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const DisableErrorMessage()),
          ),
          Stack(
            children: [
              Container(
                height: 125,
                decoration: BoxDecoration(
                  color: widget.mode == editMode ? Colors.white : staffOrange,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.mode == editMode ? 'EDIT REASON' : 'DISABLE',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                        height: 1.5,
                        color: widget.mode == editMode
                            ? staffOrange
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                top: 65,
                child: DisableCloseButton(
                    mode: widget.mode,
                    onPressed: () {
                      widget.mode == editMode
                          ? reasonController.text != widget.reason &&
                                  (numOfCharacter >= 10 &&
                                      numOfCharacter <= 250)
                              ? showEditExitConfirmationModal(context,
                                  () async {
                                  Navigator.of(context).pop();
                                  showLoadModal(context);
                                  try {
                                    await FirebaseCloudStorage()
                                        .updateDisableReason(
                                          widget.disableIds,
                                          reasonController.text,
                                        )
                                        .then(
                                            (_) => Navigator.of(context).pop())
                                        .then(
                                            (_) => Navigator.of(context).pop());
                                  } catch (e) {
                                    // Handle error
                                    showErrorModal(
                                      context,
                                      () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                                }, () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                })
                              : Navigator.of(context).pop()
                          : numOfCharacter >= 10
                              ? showDisableExitConfirmationModal(context, () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                })
                              : Navigator.of(context).pop();
                    }),
              ),
              Positioned(
                right: 15,
                top: 70,
                child: SizedBox(
                  height: 40,
                  width: 70,
                  child: FinishButton(
                    reason: widget.reason,
                    reasonController: reasonController,
                    numOfCharacter: numOfCharacter,
                    mode: widget.mode,
                    onPressed: () {
                      widget.mode == disableMode
                          ? showDoneConfirmationModal(
                              context,
                              () async {
                                Navigator.of(context).pop();
                                showLoadModal(context);
                                try {
                                  // Call createDisableReservation to disable the selected time slots
                                  await FirebaseCloudStorage()
                                      .createDisableReservation(
                                        widget.zoneId,
                                        reasonController.text,
                                        startTimes,
                                      )
                                      .then((_) => Navigator.of(context).pop())
                                      .then((_) => Navigator.of(context).pop());
                                } catch (e) {
                                  // Handle error
                                  showErrorModal(
                                    context,
                                    () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                            )
                          : showSaveConfirmationModal(
                              context,
                              () async {
                                Navigator.of(context).pop();
                                showLoadModal(context);
                                try {
                                  await FirebaseCloudStorage()
                                      .updateDisableReason(
                                        widget.disableIds,
                                        reasonController.text,
                                      )
                                      .then((_) => Navigator.of(context).pop())
                                      .then((_) => Navigator.of(context).pop());
                                } catch (e) {
                                  // Handle error
                                  showErrorModal(
                                    context,
                                    () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
