import 'package:flutter/material.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/utilities/disable/text_style.dart';
import 'package:shimmer/shimmer.dart';

class TimeDetail extends StatelessWidget {
  final bool isReservationTimeLoaded;

  final List<Map<String, dynamic>> reservationTimes;

  const TimeDetail({
    super.key,
    required this.isReservationTimeLoaded,
    required this.reservationTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time: ', style: topTextStyle),
        const SizedBox(width: 23),
        isReservationTimeLoaded
            ? Column(
                children: reservationTimes
                    .map(
                      (text) => Text(
                          '${text[startTimeField].toString().substring(11, 16)} - ${text[endTimeField].toString().substring(11, 16)}',
                          style: inputTextStyle),
                    )
                    .toList(),
                // Text(widget.reservationIds[index]);
              )
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
    );
  }
}
