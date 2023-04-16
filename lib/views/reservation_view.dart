// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:intl/intl.dart';

bool hasRole = true;

final int numOfDay = hasRole ? 30 : 7;

// Creating a StatefulWidget called ReservationView
class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  // Override method to create a State object
  @override
  State<ReservationView> createState() => _ReservationViewState();
}

// Creating a State object called _ReservationViewState
class _ReservationViewState extends State<ReservationView> {
  int _selectedDateIndex = 0;
  bool _isReserved = false;

  @override
  Widget build(BuildContext context) {
    String buildingName =
        'King Mongkut\'s 190th Anniversary Memorial Building - 3rd Floor';
    List<String> parts = buildingName.split(RegExp(r'\s+(?=-\s)'));

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Use a Stack widget to position the arrow button on top of the image
            Stack(
              children: [
                Image.asset(
                  'assets/images/badmintoncourt1.jpg',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE17325),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                            fixedSize: const Size.fromRadius(25),
                          ),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 200),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: const [
                    Text(
                      'Badminton Court 1',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        height: 1.5, // 39/26 = 1.5
                        color: Color(0xFFE17325),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0x99000000),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5, // 21/14 = 1.5
                        color: Color(0x99000000),
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(text: '${parts[0]} '),
                        TextSpan(text: parts.sublist(1).join(' - ')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DateList(
                    selectedIndex: _selectedDateIndex,
                    onSelected: (index) => setState(() {
                      _selectedDateIndex = index;
                    }),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: const TimeSlot(),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: const Color.fromRGBO(255, 255, 255, 0.75),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_selectedDateIndex < 7)
                            ReserveButton(
                              isReserved: _isReserved,
                              onPressed: () {
                                if (_isReserved) {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.white.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: const [
                                                SizedBox(height: 40),
                                                Text(
                                                  'Are you sure\nyou want to\ncancel ?',
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFCC0019),
                                                    height: 1.3,
                                                    letterSpacing: 0.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 30),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 84,
                                                      height: 43,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _isReserved = false;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            const Color(
                                                                0xFF009900),
                                                          ),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Colors.white,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20.0,
                                                            height: 1.2,
                                                            letterSpacing: 0.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 34.0),
                                                    SizedBox(
                                                      width: 84,
                                                      height: 43,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            const Color(
                                                                0xFFCC0019),
                                                          ),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Colors.white,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20.0,
                                                            height: 1.2,
                                                            letterSpacing: 0.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    _isReserved = true;
                                  });
                                }
                              },
                            ),
                          if (hasRole) ...[
                            const DisableButton(),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

class TimeSlotData {
  final String timeSlot;
  final int reservedSeats;
  final int maxSeats;

  TimeSlotData({
    required this.timeSlot,
    required this.reservedSeats,
    required this.maxSeats,
  });
}

// A StatefulWidget that creates a list of time slots as RadioListTile widgets
class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

// The State class for the TimeSlot widget
class _TimeSlotState extends State<TimeSlot> {
  // A list of time slots as TimeSlotData objects
  final List<TimeSlotData> timeSlots = [
    TimeSlotData(timeSlot: '13.00 - 13.59', reservedSeats: 3, maxSeats: 4),
    TimeSlotData(timeSlot: '14.00 - 14.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '15.00 - 15.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '16.00 - 16.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '17.00 - 17.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '18.00 - 18.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '19.00 - 19.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '20.00 - 20.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '21.00 - 21.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '22.00 - 22.59', reservedSeats: 0, maxSeats: 4),
    TimeSlotData(timeSlot: '23.00 - 23.59', reservedSeats: 0, maxSeats: 4),
  ];

  // The index of the selected time slot
  int _selectedTimeSlot = 0;

  @override
  Widget build(BuildContext context) {
    // Set the inactive radio button color
    final ThemeData theme = Theme.of(context).copyWith(
      unselectedWidgetColor: Colors.white,
    );

    // Builds a ListView of RadioListTile widgets
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 70),
      shrinkWrap: true,
      itemCount: timeSlots.length,
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
                    secondary: _selectedTimeSlot == index
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeSlots[index].timeSlot,
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
                              '${timeSlots[index].reservedSeats}/${timeSlots[index].maxSeats}',
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
                    groupValue: _selectedTimeSlot,
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeSlot = value!;
                      });
                    },
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
      height: 55,
      width: 140,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(
              color: isReserved
                  ? const Color(0xFFCC0019)
                  : const Color(0xFFE17325),
              width: 3,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: onPressed, // Assign the onPressed callback to the button
        child: Text(
          isReserved
              ? "CANCEL"
              : "RESERVE", // Set the button text based on the isReserved value
          style: TextStyle(
            color:
                isReserved ? const Color(0xFFCC0019) : const Color(0xFFE17325),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.normal,
            height: 1.5,
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
          Navigator.of(context).pushNamed(
            disableRoute, // Navigate to the disableRoute when the button is pressed
          );
        },

        child: const Text(
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
      ),
    );
  }
}
