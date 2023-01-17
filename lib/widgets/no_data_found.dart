import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import '../configs/space.dart';

class NoDataFound extends StatefulWidget {
  final String? message;
  final double? bottomPadding;
  const NoDataFound({Key? key, this.message, this.bottomPadding = 2})
      : super(key: key);

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              widget.message!,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isArabic() ? math.pi : 0),
              child: LottieBuilder.asset(
                  "assets/animations/arrow_animation.json")),
          Space.yf(widget.bottomPadding!)
        ],
      ),
    );
  }

  bool isArabic() =>
      EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
}
