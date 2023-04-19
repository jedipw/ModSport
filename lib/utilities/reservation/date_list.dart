import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateList extends StatelessWidget {
  final int
      selectedIndex; // The index of the currently selected date in the list.
  final ValueChanged<int>
      onSelected; // A callback function that is called when a date is selected.
  final bool hasRole;
  final bool isDisableMenu;
  const DateList({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
    required this.hasRole,
    required this.isDisableMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int numOfDay = hasRole && isDisableMenu ? 30 : 7;
    final today = DateTime.now(); // Get the current date.
    final endDate = today
        .add(Duration(days: numOfDay)); // Calculate the end date of the list.
    final dateList = List.generate(
      endDate
          .difference(today)
          .inDays, // Generate a list of dates between the current date and the end date.
      (index) => today.add(Duration(days: index)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis
          .horizontal, // Allows the user to scroll horizontally through the list.
      child: Row(
        children: List.generate(
          dateList
              .length, // Generate a list of widgets for each date in the list.
          (index) => Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 8), // Add some spacing between the dates.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      selectedIndex == index
                          ? const Color(0xFFE17325)
                          : Colors.white, // Highlight the selected date.
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Color(0xFFE17325), // Set the border color here.
                        width: 1, // Set the border width here.
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Set the border radius here.
                      ),
                    ),
                  ),
                  onPressed: () => onSelected(
                    index,
                  ), // Call the onSelected callback when a date is pressed.
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE').format(dateList[index]).substring(
                            0, 3), // Display the day of the week for the date.
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: selectedIndex == index
                              ? Colors.white
                              : const Color(0xFFE17325),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('d').format(dateList[
                            index]), // Display the day of the month for the date.
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: selectedIndex == index
                              ? Colors.white
                              : const Color(0xFFE17325),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
