import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class LocationName extends StatelessWidget {
  const LocationName(
      {super.key,
      required this.locationName,
      required this.isError,
      required this.isLocationLoaded});
  final String locationName;
  final bool isError;
  final bool isLocationLoaded;

  @override
  Widget build(BuildContext context) {
    List<String> parts = locationName.split(RegExp(r'\s+(?=-\s)'));
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: primaryGray,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: isError && locationName.isEmpty
              ? const Text(
                  '---',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.5, // 39/26 = 1.5
                    color: primaryGray,
                  ),
                )
              : !isLocationLoaded
                  ? Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 216, 216, 216),
                      highlightColor:
                          const Color.fromRGBO(173, 173, 173, 0.824),
                      child: Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ))
                  : RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5, // 21/14 = 1.5
                          color: primaryGray,
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
    );
  }
}
