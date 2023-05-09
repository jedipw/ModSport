import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class TimeSlotLoading extends StatelessWidget {
  const TimeSlotLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set the inactive radio button color
    final ThemeData theme = Theme.of(context).copyWith(
      unselectedWidgetColor: Colors.white,
    );

    // Builds a ListView of RadioListTile widgets
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      shrinkWrap: true,
      itemCount: 8, // increment by 1
      itemBuilder: (context, index) {
        // Builds a RadioListTile widget for each item in the list
        return Theme(
          data: theme,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
              selectedColor: primaryOrange,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: RadioListTile(
                    secondary: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: primaryGray,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 216, 216, 216),
                          highlightColor:
                              const Color.fromRGBO(173, 173, 173, 0.824),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            width: 150,
                            height: 20.0,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people,
                                color: primaryGray, size: 30),
                            const SizedBox(width: 4),
                            Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 216, 216, 216),
                              highlightColor:
                                  const Color.fromRGBO(173, 173, 173, 0.824),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                width: 50,
                                height: 20.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    value: index,
                    groupValue: const [1, 2, 3, 4, 5, 6, 7, 8],
                    onChanged: null,
                    activeColor: Colors.white,
                    selectedTileColor: primaryOrange,
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
