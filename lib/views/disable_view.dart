import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';
import 'package:modsport/services/cloud/firebase_cloud_storage.dart';
import 'package:modsport/utilities/modal.dart';
import 'package:modsport/utilities/types.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

TextStyle topTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 22,
  height:
      1.5, // or line-height: 33px, which is equivalent to 1.5 times the font size
  color: primaryGray,
);

TextStyle inputTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w400,
  fontSize: 22,
  height:
      1.5, // or line-height: 33px, which is equivalent to 1.5 times the font size
  color: Color.fromRGBO(0, 0, 0, 0.45),
);

TextStyle bottomTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 14,
  height:
      1.5, // or line-height: 21px, which is equivalent to 1.5 times the font size
  color: Color.fromRGBO(0, 0, 0, 0.45),
);

// A stateless widget for the disable view
class DisableView extends StatefulWidget {
  const DisableView({
    super.key,
    required this.disableIds,
    required this.zoneId,
    required this.reservationIds,
    this.reason = '',
    required this.selectedDateIndex,
    required this.mode,
  });
  final List<String> disableIds;
  final String zoneId;
  final List<String> reservationIds;
  final String reason;
  final int selectedDateIndex;
  final String mode;

  @override
  State<DisableView> createState() => _DisableViewState();
}

class _DisableViewState extends State<DisableView> {
  double _textFieldWidth = double.infinity;

  String _zoneName = '';
  List<Map<String, dynamic>> reservationTimes = [];
  List<Timestamp> startTimes = [];
  TextEditingController reasonController = TextEditingController();
  int numOfCharacter = 0;

  bool _isZoneNameLoaded = false;
  bool _isReservationTimeLoaded = false;
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
      log('Error fetching zone name: $e');
    }
  }

  Future<void> _getReservationTime() async {
    try {
      List<Map<String, dynamic>> reservation = await FirebaseCloudStorage()
          .getReservationTime(widget.reservationIds, widget.selectedDateIndex);
      setState(() {
        reservationTimes = reservation;
        startTimes = reservation
            .map((time) => Timestamp.fromDate(time["startTime"]))
            .toList();

        _isReservationTimeLoaded = true;
      });
    } catch (e) {
      log('Error fetching zone name: $e');
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
    return Scaffold(
      // A Center widget containing a Text widget
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Facility: ', style: topTextStyle),
                              _isZoneNameLoaded
                                  ? Expanded(
                                      child: Text(_zoneName,
                                          style: inputTextStyle),
                                    )
                                  : Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 216, 216, 216),
                                      highlightColor: const Color.fromRGBO(
                                          173, 173, 173, 0.824),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        width: 150,
                                        height: 25.0,
                                        color: Colors.white,
                                      ),
                                    ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text('Date: ', style: topTextStyle),
                                  const SizedBox(width: 26),
                                  _isReservationTimeLoaded
                                      ? Text(
                                          '${_getDayOrdinal(reservationTimes.first['startTime'].day)} ${DateFormat('MMMM').format(reservationTimes.first['startTime'])} ${reservationTimes[0]['startTime'].year}',
                                          style: inputTextStyle)
                                      : Shimmer.fromColors(
                                          baseColor: const Color.fromARGB(
                                              255, 216, 216, 216),
                                          highlightColor: const Color.fromRGBO(
                                              173, 173, 173, 0.824),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            width: 150,
                                            height: 25.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time: ', style: topTextStyle),
                              const SizedBox(width: 23),
                              _isReservationTimeLoaded
                                  ? Column(
                                      children: reservationTimes
                                          .map(
                                            (text) => Text(
                                                '${text['startTime'].toString().substring(11, 16)} - ${text['endTime'].toString().substring(11, 16)}',
                                                style: inputTextStyle),
                                          )
                                          .toList(),
                                      // Text(widget.reservationIds[index]);
                                    )
                                  : Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 216, 216, 216),
                                      highlightColor: const Color.fromRGBO(
                                          173, 173, 173, 0.824),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        width: 150,
                                        height: 25.0,
                                        color: Colors.white,
                                      )),
                            ],
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
                                        focusedBorder: UnderlineInputBorder(
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
                                      cursorRadius: const Radius.circular(1.0),
                                      autofocus: true,
                                      onChanged: (_) {
                                        setState(() {
                                          numOfCharacter =
                                              reasonController.text.length;
                                        });
                                      },
                                      onEditingComplete: () {
                                        setState(() {
                                          _textFieldWidth = constraint.maxWidth;
                                        });
                                      },
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16.0,
                                        height: 20.0 / 13.0,
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
            ),
          ),
          Stack(
            children: [
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
                  children: [
                    Text(
                      widget.mode == editMode ? 'EDIT REASON' : 'DISABLE',
                      style: const TextStyle(
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    shape: const CircleBorder(),
                    fixedSize: const Size.fromRadius(25),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 40),
                ),
              ),
              Positioned(
                right: 15,
                top: 70,
                child: SizedBox(
                  height: 40,
                  width: 70,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        numOfCharacter < 10 ||
                                numOfCharacter > 250 ||
                                (widget.mode == editMode &&
                                    reasonController.text == widget.reason)
                            ? const Color.fromRGBO(241, 185, 146, 0.5)
                            : const Color.fromRGBO(241, 185, 146, 1),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ), // Set the button background color to grey
                    onPressed: numOfCharacter < 10 ||
                            numOfCharacter > 250 ||
                            (widget.mode == editMode &&
                                reasonController.text == widget.reason)
                        ? null
                        : () {
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
                                            .then((_) =>
                                                Navigator.of(context).pop())
                                            .then((_) =>
                                                Navigator.of(context).pop());
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
                                            .then((_) =>
                                                Navigator.of(context).pop())
                                            .then((_) =>
                                                Navigator.of(context).pop());
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
                    child: Text(
                      widget.mode == editMode
                          ? "SAVE"
                          : "DONE", // Set the button text to "Disable"
                      style: TextStyle(
                        color: numOfCharacter < 10 ||
                                numOfCharacter > 250 ||
                                (widget.mode == editMode &&
                                    reasonController.text == widget.reason)
                            ? const Color.fromRGBO(0, 0, 0, 0.2)
                            : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        height: 1.5,
                      ),
                    ),
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
