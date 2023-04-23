import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/types.dart';
import 'package:modsport/utilities/reservation/function.dart';

typedef OnChangedCallback = void Function(int? value);
typedef IsDisableCallback = bool Function(DateTime? startTime);

// A StatefulWidget that creates a list of time slots as RadioListTile widgets
class TimeSlotReserve extends StatelessWidget {
  const TimeSlotReserve({
    super.key,
    required this.reservation,
    required this.disabledReservation,
    required this.userReservation,
    required this.selectedDateIndex,
    required this.selectedTimeSlot,
    required this.isReserved,
    required this.onChanged,
  });

  final List<ReservationData> reservation;
  final List<DisableData> disabledReservation;
  final List<UserReservationData> userReservation;
  final int selectedDateIndex;
  final int selectedTimeSlot;
  final bool isReserved;
  final OnChangedCallback onChanged;

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
      itemCount: reservation.length, // increment by 1
      itemBuilder: (context, index) {
        // Builds a RadioListTile widget for each item in the list
        final int numOfReservation = countNumOfReservation(
            reservation[index].startTime, userReservation);
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
              selectedColor: primaryOrange,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: RadioListTile(
                    secondary: selectedTimeSlot == index
                        ? Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(left: 15),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryOrange,
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
                                color: isReserved ? primaryGray : primaryOrange,
                              ),
                            ),
                          ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${reservation[index].startTime.toString().substring(11, 16)} - ${reservation[index].endTime.toString().substring(11, 16)}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            height: 1.5,
                            color: !isReserved ||
                                    (isReserved && index == selectedTimeSlot)
                                ? primaryOrange
                                : primaryGray,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people, color: primaryGray),
                            const SizedBox(width: 8),
                            Text(
                              '$numOfReservation/${reservation[index].capacity}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                height: 1.5,
                                color: primaryGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    value: index,
                    groupValue: selectedTimeSlot,
                    onChanged: isReserved ? null : onChanged,
                    activeColor: Colors.white,
                    selectedTileColor: primaryOrange,
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
