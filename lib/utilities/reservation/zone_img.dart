import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class ZoneImg extends StatelessWidget {
  final bool isError;

  final String imgUrl;

  const ZoneImg({
    super.key,
    required this.isError,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 216, 216, 216),
          highlightColor: const Color.fromRGBO(173, 173, 173, 0.824),
          child: Container(
            width: double.infinity,
            height: 240,
            color: primaryGray,
          ),
        ),
        isError && imgUrl.isEmpty
            ? Container(
                width: double.infinity,
                height: 240,
                color: primaryGray,
              )
            : FutureBuilder(
                future: Future(() {}),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Image.network(
                    imgUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Container();
                    },
                  );
                },
              ),
      ],
    );
  }
}
