import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:intl/intl.dart';

class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  @override
  State<ReservationView> createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  int _selectedDateIndex = 0;
  bool _isReserved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facility1')),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8, 15, 0, 50),
        child: Column(
          children: [
            DateList(
              selectedIndex: _selectedDateIndex,
              onSelected: (index) => setState(() {
                _selectedDateIndex = index;
              }),
            ),
            const SizedBox(height: 50),
            const Expanded(child: TimeSlot()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 125,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: _isReserved
                          ? MaterialStateProperty.all(Colors.red)
                          : MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      if (_isReserved) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
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
                        setState(() {
                          _isReserved = true;
                        });
                      }
                    },
                    child: Text(
                      _isReserved ? "Cancel" : "Reserve",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 75),
                SizedBox(
                  height: 60,
                  width: 125,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        disableRoute,
                      );
                    },
                    child: const Text(
                      "Disable",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DateList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DateList({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final endDate = today.add(const Duration(days: 30));
    final dateList = List.generate(
      endDate.difference(today).inDays,
      (index) => today.add(Duration(days: index)),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          dateList.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      selectedIndex == index ? Colors.orange : Colors.grey[300],
                    ),
                  ),
                  onPressed: () => onSelected(index),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE')
                            .format(dateList[index])
                            .substring(0, 3),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('d').format(dateList[index]),
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

class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
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

  int _selectedTimeSlot = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(timeSlots[index]),
          value: index,
          groupValue: _selectedTimeSlot,
          onChanged: (value) {
            setState(() {
              _selectedTimeSlot = value!;
            });
          },
        );
      },
    );
  }
}
