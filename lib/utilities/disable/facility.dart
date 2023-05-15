import 'package:flutter/material.dart';
import 'package:modsport/utilities/disable/text_style.dart';
import 'package:shimmer/shimmer.dart';

class FacilityName extends StatelessWidget {
  final bool isZoneNameLoaded;

  final String zoneName;

  const FacilityName({
    super.key,
    required this.isZoneNameLoaded,
    required this.zoneName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facility: ', style: topTextStyle),
        isZoneNameLoaded
            ? Expanded(
                child: Text(zoneName, style: inputTextStyle),
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
