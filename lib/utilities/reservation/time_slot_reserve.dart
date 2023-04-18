import 'package:flutter/material.dart';
import 'package:modsport/utilities/reservation/typeclass.dart';

typedef OnChangedCallback = void Function(int? value);
typedef CountNumOfReservationCallback = int Function(DateTime startTime);
typedef IsDisableCallback = bool Function(DateTime startTime);

// A StatefulWidget that creates a list of time slots as RadioListTile widgets
class TimeSlotReserve extends StatefulWidget {
  const TimeSlotReserve(
      {super.key,
      required this.isDisable,
      required this.hasRole,
      required this.countNumOfReservation,
      required this.reservationDB,
      required this.disabledReservation,
      required this.userReservation,
      required this.selectedDateIndex,
      required this.selectedTimeSlot,
      required this.onChanged});

  final IsDisableCallback isDisable;
  final bool hasRole;
  final CountNumOfReservationCallback countNumOfReservation;
  final List<ReservationData> reservationDB;
  final List<DateTime> disabledReservation;
  final List<UserReservationData> userReservation;
  final int selectedDateIndex;
  final int selectedTimeSlot;
  final OnChangedCallback onChanged;

  @override
  State<TimeSlotReserve> createState() => _TimeSlotReserveState();
}

// The State class for the TimeSlot widget
class _TimeSlotReserveState extends State<TimeSlotReserve> {
  // The index of the selected time slot

  @override
  Widget build(BuildContext context) {
    // Set the inactive radio button color
    final ThemeData theme = Theme.of(context).copyWith(
      unselectedWidgetColor: Colors.white,
    );

    // Builds a ListView of RadioListTile widgets
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      shrinkWrap: true,
      itemCount: widget.reservationDB.length,
      itemBuilder: (context, index) {
        // Builds a RadioListTile widget for each item in the list
        final int numOfReservation =
            widget.countNumOfReservation(widget.reservationDB[index].startTime);
        return Theme(
          data: theme,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              selectedColor: const Color(0xFFE17325),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: widget.isDisable(widget.reservationDB[index].startTime)
                      ? RadioListTile(
                          secondary: widget.selectedTimeSlot == index
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(left: 15),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF808080),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.hasRole
                                        ? Colors.white
                                        : const Color(0xFF808080),
                                    border: Border.all(
                                      width: 2,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.reservationDB[index].startTime.toString().substring(11, 16)} - ${widget.reservationDB[index].endTime.toString().substring(11, 16)}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  height: 1.5,
                                  color: Color(0xFF808080),
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.block, color: Color(0xFF808080)),
                                ],
                              ),
                            ],
                          ),
                          value: index,
                          groupValue: widget.selectedTimeSlot,
                          onChanged: widget.hasRole ? widget.onChanged : null,
                          activeColor: Colors.white,
                          selectedTileColor: const Color(0xFFE17325),
                          controlAffinity: ListTileControlAffinity.trailing,
                        )
                      : widget.countNumOfReservation(
                                  widget.reservationDB[index].startTime) ==
                              widget.reservationDB[index].capacity
                          ? RadioListTile(
                              secondary: widget.selectedTimeSlot == index
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(left: 15),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF808080),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.hasRole
                                            ? Colors.white
                                            : const Color(0xFF808080),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(0xFF808080),
                                        ),
                                      ),
                                    ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.reservationDB[index].startTime.toString().substring(11, 16)} - ${widget.reservationDB[index].endTime.toString().substring(11, 16)}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      height: 1.5,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.people),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$numOfReservation/${widget.reservationDB[index].capacity}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          height: 1.5,
                                          color: Color(0xFF808080),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              value: index,
                              groupValue: widget.selectedTimeSlot,
                              onChanged:
                                  widget.hasRole ? widget.onChanged : null,
                              activeColor: Colors.white,
                              selectedTileColor: const Color(0xFFE17325),
                              controlAffinity: ListTileControlAffinity.trailing,
                            )
                          : RadioListTile(
                              secondary: widget.selectedTimeSlot == index
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(left: 15),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE17325),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(left: 15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(0xFFE17325),
                                        ),
                                      ),
                                    ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.reservationDB[index].startTime.toString().substring(11, 16)} - ${widget.reservationDB[index].endTime.toString().substring(11, 16)}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      height: 1.5,
                                      color: Color(0xFFE17325),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.people),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$numOfReservation/${widget.reservationDB[index].capacity}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          height: 1.5,
                                          color: Color(0xFF808080),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              value: index,
                              groupValue: widget.selectedTimeSlot,
                              onChanged: widget.onChanged,
                              activeColor: Colors.white,
                              selectedTileColor: const Color(0xFFE17325),
                              controlAffinity: ListTileControlAffinity.trailing,
                            ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}