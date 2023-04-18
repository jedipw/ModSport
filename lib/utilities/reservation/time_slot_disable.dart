import 'package:flutter/material.dart';
import 'package:modsport/utilities/reservation/typeclass.dart';

typedef CountNumOfReservationCallback = int Function(DateTime startTime);
typedef OnChangedCallback = void Function(int index, bool? value);

class TimeSlotDisable extends StatefulWidget {
  const TimeSlotDisable(
      {super.key,
      required this.reservationDB,
      required this.userReservation,
      required this.countNumOfReservation,
      required this.selectedTimeSlots,
      required this.onChanged});
  final List<ReservationData> reservationDB;
  final List<UserReservationData> userReservation;
  final CountNumOfReservationCallback countNumOfReservation;
  final List<bool?> selectedTimeSlots;

  final OnChangedCallback onChanged;

  @override
  State<TimeSlotDisable> createState() => _TimeSlotDisableState();
}

class _TimeSlotDisableState extends State<TimeSlotDisable> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      itemCount: widget.reservationDB.length,
      itemBuilder: (context, index) {
        final int numOfReservation =
            widget.countNumOfReservation(widget.reservationDB[index].startTime);
        return GestureDetector(
          onTap: () {
            widget.onChanged(index, !widget.selectedTimeSlots[index]!);
          },
          child: Row(
            children: [
              Checkbox(
                value: widget.selectedTimeSlots[index],
                onChanged: (bool? value) {
                  widget.onChanged(index, value);
                },
              ),
              const SizedBox(
                  width: 8), // Add some space between the checkbox and the text
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${widget.reservationDB[index].startTime.toString().substring(11, 16)} - ${widget.reservationDB[index].endTime.toString().substring(11, 16)}'),
                    Row(
                      children: [
                        const Icon(Icons.people),
                        Text(
                            '$numOfReservation/${widget.reservationDB[index].capacity}')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
