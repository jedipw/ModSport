// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:intl/intl.dart';

// Creating a StatefulWidget called ReservationView
class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  // Override method to create a State object
  @override
  State<ReservationView> createState() => _ReservationViewState();
}

// Creating a State object called _ReservationViewState
class _ReservationViewState extends State<ReservationView> {
  // Initializing two variables
  int _selectedDateIndex = 0; // Index of the selected date in DateList
  bool _isReserved =
      false; // Boolean indicating if a facility is reserved or not

  // Override method to build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up the app bar
      appBar: AppBar(title: const Text('Facility1')),
      // Setting up the body
      body: Container(
        // Adding padding to the container
        padding: const EdgeInsets.fromLTRB(8, 15, 0, 50),
        child: Column(
          children: [
            // Adding the DateList widget to the column
            DateList(
              selectedIndex: _selectedDateIndex,
              onSelected: (index) => setState(() {
                _selectedDateIndex = index;
              }),
            ),
            const SizedBox(height: 50),
            // Adding the TimeSlot widget to the column
            const Expanded(child: TimeSlot()),
            // Adding a row of buttons to the column
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Adding the ReserveButton widget to the row
                ReserveButton(
                  isReserved: _isReserved,
                  onPressed: () {
                    // If the facility is already reserved, show a confirmation dialog
                    if (_isReserved) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          actions: [
                            // Button to cancel the action
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            // Button to confirm the action
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isReserved = false;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // If the facility is not reserved, reserve it
                      setState(() {
                        _isReserved = true;
                      });
                    }
                  },
                ),
                const SizedBox(width: 75),
                // Adding the DisableButton widget to the row
                const DisableButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DateList extends StatelessWidget {
  final int
      selectedIndex; // The index of the currently selected date in the list.
  final ValueChanged<int>
      onSelected; // A callback function that is called when a date is selected.

  const DateList({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now(); // Get the current date.
    final endDate = today
        .add(const Duration(days: 30)); // Calculate the end date of the list.
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
                          ? Colors.orange
                          : Colors.grey[300], // Highlight the selected date.
                    ),
                  ),
                  onPressed: () => onSelected(
                      index), // Call the onSelected callback when a date is pressed.
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE').format(dateList[index]).substring(
                            0, 3), // Display the day of the week for the date.
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('d').format(dateList[
                            index]), // Display the day of the month for the date.
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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

// A StatefulWidget that creates a list of time slots as RadioListTile widgets
class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

// The State class for the TimeSlot widget
class _TimeSlotState extends State<TimeSlot> {
  // A list of time slots as strings
  final List<String> timeSlots = [
    '0.00 - 2.00',
    '2.00 - 4.00',
    '6.00 - 8.00',
    '8.00 - 10.00',
    '10.00 - 12.00',
    '12.00 - 14.00',
    '14.00 - 16.00',
    '16.00 - 18.00',
    '18.00 - 20.00',
    '20.00 - 22.00',
    '22.00 - 24.00',
  ];

  // The index of the selected time slot
  int _selectedTimeSlot = 0;

  @override
  Widget build(BuildContext context) {
    // Builds a ListView of RadioListTile widgets
    return ListView.builder(
      shrinkWrap: true,
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        // Builds a RadioListTile widget for each item in the list
        return RadioListTile(
          title: Text(timeSlots[index]),
          value: index,
          groupValue: _selectedTimeSlot,
          onChanged: (value) {
            // Sets the selected time slot to the one that was tapped
            setState(() {
              _selectedTimeSlot = value!;
            });
          },
        );
      },
    );
  }
}

class ReserveButton extends StatelessWidget {
  final bool
      isReserved; // Indicates if the button is for reserving or canceling a reservation
  final VoidCallback
      onPressed; // Callback function to execute when the button is pressed

  const ReserveButton({
    Key? key,
    required this.isReserved,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 125,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
              isReserved // Set the background color based on the isReserved value
                  ? MaterialStateProperty.all(Colors.red)
                  : MaterialStateProperty.all(Colors.green),
        ),
        onPressed: onPressed, // Assign the onPressed callback to the button
        child: Text(
          isReserved
              ? "Cancel"
              : "Reserve", // Set the button text based on the isReserved value
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class DisableButton extends StatelessWidget {
  const DisableButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 125,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.grey)), // Set the button background color to grey
        onPressed: () {
          Navigator.of(context).pushNamed(
            disableRoute, // Navigate to the disableRoute when the button is pressed
          );
        },
        child: const Text(
          "Disable", // Set the button text to "Disable"
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
