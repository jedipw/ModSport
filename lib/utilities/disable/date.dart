import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modsport/utilities/disable/function.dart';
import 'package:modsport/utilities/disable/text_style.dart';
import 'package:shimmer/shimmer.dart';

class DateDetail extends StatelessWidget {
  final bool isReservationTimeLoaded;

  final List<Map<String, dynamic>> reservationTimes;

  const DateDetail({
    super.key,
    required this.isReservationTimeLoaded,
    required this.reservationTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text('Date: ', style: topTextStyle),
            const SizedBox(width: 26),
            isReservationTimeLoaded
                ? Text(
                    '${getDayOrdinal(reservationTimes.first['startTime'].day)} ${DateFormat('MMMM').format(reservationTimes.first['startTime'])} ${reservationTimes[0]['startTime'].year}',
                    style: inputTextStyle)
                : Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 216, 216, 216),
                    highlightColor: const Color.fromRGBO(173, 173, 173, 0.824),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(top: 5),
                      width: 150,
                      height: 25.0,
                    ),
                  ),
          ],
        )
      ],
    );
  }
}
