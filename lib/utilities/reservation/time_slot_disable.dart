import 'package:flutter/material.dart';
import 'package:modsport/utilities/types.dart';

typedef CountNumOfReservationCallback = int Function(DateTime? startTime);
typedef OnChangedCallback = void Function(int index, bool? value);
typedef IsDisableCallback = bool Function(DateTime? startTime);

class TimeSlotDisable extends StatefulWidget {
  const TimeSlotDisable({
    super.key,
    required this.reservation,
    required this.userReservation,
    required this.countNumOfReservation,
    required this.disabledReservation,
    required this.selectedTimeSlots,
    required this.onChanged,
    required this.isDisable,
  });
  final List<DisableData> disabledReservation;
  final List<ReservationData> reservation;
  final List<UserReservationData> userReservation;
  final CountNumOfReservationCallback countNumOfReservation;
  final List<bool?> selectedTimeSlots;
  final IsDisableCallback isDisable;

  final OnChangedCallback onChanged;

  @override
  State<TimeSlotDisable> createState() => _TimeSlotDisableState();
}

class _TimeSlotDisableState extends State<TimeSlotDisable> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      itemCount: widget.reservation.length,
      itemBuilder: (context, index) {
        final int numOfReservation =
            widget.countNumOfReservation(widget.reservation[index].startTime);
        return GestureDetector(
          onTap: () {
            if (!widget.isDisable(widget.reservation[index].startTime)) {
              widget.onChanged(index, !widget.selectedTimeSlots[index]!);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.fromLTRB(5, 18, 5, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  activeColor: const Color(0xFFE17325),
                  value: widget.isDisable(widget.reservation[index].startTime)
                      ? !widget.selectedTimeSlots[index]!
                      : widget.selectedTimeSlots[index],
                  onChanged: (bool? value) {
                    if (!widget
                        .isDisable(widget.reservation[index].startTime)) {
                      widget.onChanged(index, value);
                    }
                  },
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFFE17325);
                      }
                      return widget
                              .isDisable(widget.reservation[index].startTime)
                          ? const Color(0xFF808080)
                          : const Color(0xFFE17325);
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity:
                      const VisualDensity(horizontal: 1, vertical: 1),
                  hoverColor: const Color(0xFFE17325).withOpacity(0.04),
                  focusColor: const Color(0xFFE17325).withOpacity(0.12),
                ),
                const SizedBox(
                  width: 9,
                ), // Add some space between the checkbox and the text
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.reservation[index].startTime.toString().substring(11, 16)} - ${widget.reservation[index].endTime.toString().substring(11, 16)}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: widget.isDisable(
                                    widget.reservation[index].startTime)
                                ? const Color(0xFF808080)
                                : const Color(0xFFE17325),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people, color: Color(0xFF808080)),
                            const SizedBox(width: 8),
                            widget.isDisable(
                                    widget.reservation[index].startTime)
                                ? const Icon(
                                    Icons.block,
                                    color: Color(0xFF808080),
                                    size: 35,
                                  )
                                : Text(
                                    '$numOfReservation/${widget.reservation[index].capacity}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      height: 1.5,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                            const SizedBox(width: 13),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
