import 'package:flutter/material.dart';
import 'package:modsport/utilities/types.dart';
import 'package:modsport/views/disable_view.dart';

class DisableButton extends StatelessWidget {
  const DisableButton(
      {Key? key,
      required this.isDisableMenu,
      required this.selectedTimeSlots,
      required this.zoneId,
      required this.reservations,
      required this.selectedDateIndex})
      : super(key: key);
  final bool isDisableMenu;
  final List<bool?> selectedTimeSlots;
  final String zoneId;
  final List<ReservationData> reservations;
  final int selectedDateIndex;

  @override
  Widget build(BuildContext context) {
    int numOfSelectedTimeSlots =
        selectedTimeSlots.where((element) => element == true).length;
    List<String> reservationIds = [];

    return SizedBox(
      height: 55,
      width: 140,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Color(0xFFCC0019),
              width: 3,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ), // Set the button background color to grey
        onPressed: () {
          reservationIds = [];
          selectedTimeSlots.asMap().forEach((index, isSelected) {
            if (isSelected!) {
              reservationIds.add(reservations[index].reservationId);
            }
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => DisableView(
                zoneId: zoneId,
                reservationIds: reservationIds,
                reason: '',
                selectedDateIndex: selectedDateIndex,
              ),
            ),
          );
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "DISABLE", // Set the button text to "Disable"
              style: TextStyle(
                color: Color(0xFFCC0019),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.normal,
                height: 1.5,
              ),
            ),
            if (isDisableMenu == true && numOfSelectedTimeSlots > 1) ...[
              Text(
                ' ($numOfSelectedTimeSlots)', // Set the button text to "Disable"
                style: const TextStyle(
                  color: Color(0xFFCC0019),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.normal,
                  height: 1.5,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
