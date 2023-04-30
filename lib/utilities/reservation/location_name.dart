import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class LocationName extends StatelessWidget {
  const LocationName({
    super.key,
    required this.locationName,
    required this.isError,
    required this.isLocationLoaded,
    required this.isSwipingUp,
  });
  final String locationName;
  final bool isError;
  final bool isLocationLoaded;
  final bool isSwipingUp;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSwipingUp ? 0.33 : 1,
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: primaryGray,
          ),
          const SizedBox(
            width: 5,
          ),
          isError && locationName.isEmpty
              ? const Text(
                  '---',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.5, // 39/26 = 1.5
                    color: primaryGray,
                  ),
                )
              : !isLocationLoaded
                  ? Flexible(
                      child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 216, 216, 216),
                          highlightColor:
                              const Color.fromRGBO(173, 173, 173, 0.824),
                          child: Container(
                            width: double.infinity,
                            height: 10.0,
                            color: Colors.white,
                          )),
                    )
                  : Flexible(
                      child: Text(
                        locationName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.5, // 21/14 = 1.5
                          color: primaryGray,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
          const SizedBox(width: 100),
        ],
      ),
    );
  }
}
