import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class ZoneName extends StatelessWidget {
  const ZoneName(
      {super.key,
      required this.isError,
      required this.zoneName,
      required this.isZoneLoaded});
  final bool isError;
  final String zoneName;
  final bool isZoneLoaded;

  @override
  Widget build(BuildContext context) {
    return isError && zoneName.isEmpty
        ? const Text(
            '---',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 26,
              height: 1.5, // 39/26 = 1.5
              color: primaryOrange,
            ),
          )
        : !isZoneLoaded
            ? Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 216, 216, 216),
                highlightColor: const Color.fromRGBO(173, 173, 173, 0.824),
                child: Container(
                  width: 150,
                  height: 30.0,
                  color: Colors.white,
                ))
            : Text(
                zoneName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  height: 1.5, // 39/26 = 1.5
                  color: primaryOrange,
                ),
              );
  }
}
