import 'package:flutter/material.dart';
import 'package:modsport/utilities/reservation/typeclass.dart';
import 'package:shimmer/shimmer.dart';

typedef OnChangedCallback = void Function(int? value);
typedef CountNumOfReservationCallback = int Function(DateTime? startTime);
typedef IsDisableCallback = bool Function(DateTime? startTime);

// A StatefulWidget that creates a list of time slots as RadioListTile widgets
class TimeSlotLoading extends StatefulWidget {
  const TimeSlotLoading({
    super.key,
  });

  @override
  State<TimeSlotLoading> createState() => _TimeSlotLoadingState();
}

// The State class for the TimeSlot widget
class _TimeSlotLoadingState extends State<TimeSlotLoading> {
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
      itemCount: 5, // increment by 1
      itemBuilder: (context, index) {
        // Builds a RadioListTile widget for each item in the list
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
                  child: RadioListTile(
                    secondary: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF808080),
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 216, 216, 216),
                            highlightColor:
                                const Color.fromRGBO(173, 173, 173, 0.824),
                            child: Container(
                              width: 150,
                              height: 30.0,
                              color: Colors.white,
                            )),
                        Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 8),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 216, 216, 216),
                                highlightColor:
                                    const Color.fromRGBO(173, 173, 173, 0.824),
                                child: Container(
                                  width: 60,
                                  height: 30.0,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                    value: index,
                    groupValue: const [1, 2, 3, 4, 5],
                    onChanged: null,
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