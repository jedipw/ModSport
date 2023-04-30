import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/types.dart';
import 'package:modsport/utilities/reservation/function.dart';

typedef OnChangedCallback = void Function(int index, bool? value);

class TimeSlotDisable extends StatelessWidget {
  const TimeSlotDisable({
    super.key,
    required this.reservation,
    required this.userReservation,
    required this.disabledReservation,
    required this.selectedTimeSlots,
    required this.onChanged,
  });
  final List<DisableData> disabledReservation;
  final List<ReservationData> reservation;
  final List<UserReservationData> userReservation;
  final List<bool?> selectedTimeSlots;

  final OnChangedCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      itemCount: reservation.length,
      itemBuilder: (context, index) {
        final int numOfReservation = countNumOfReservation(
            reservation[index].startTime, userReservation);
        return GestureDetector(
          onTap: () {
            if (!isDisable(reservation[index].startTime, disabledReservation)) {
              onChanged(index, !selectedTimeSlots[index]!);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  activeColor: primaryOrange,
                  value: isDisable(
                          reservation[index].startTime, disabledReservation)
                      ? !selectedTimeSlots[index]!
                      : selectedTimeSlots[index],
                  onChanged: (bool? value) {
                    if (!isDisable(
                        reservation[index].startTime, disabledReservation)) {
                      onChanged(index, value);
                    }
                  },
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return primaryOrange;
                      }
                      return isDisable(
                              reservation[index].startTime, disabledReservation)
                          ? primaryGray
                          : primaryOrange;
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity:
                      const VisualDensity(horizontal: 1, vertical: 1),
                  hoverColor: primaryOrange.withOpacity(0.04),
                  focusColor: primaryOrange.withOpacity(0.12),
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
                          '${reservation[index].startTime.toString().substring(11, 16)} - ${reservation[index].endTime.toString().substring(11, 16)}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: isDisable(reservation[index].startTime,
                                    disabledReservation)
                                ? primaryGray
                                : primaryOrange,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            isDisable(reservation[index].startTime,
                                    disabledReservation)
                                ? const Icon(
                                    Icons.block,
                                    color: primaryGray,
                                    size: 35,
                                  )
                                : Row(
                                    children: [
                                      const Icon(Icons.people,
                                          color: primaryGray, size: 30),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$numOfReservation/${reservation[index].capacity}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          height: 1.5,
                                          color: primaryGray,
                                        ),
                                      ),
                                    ],
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
