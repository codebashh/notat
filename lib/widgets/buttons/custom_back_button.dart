import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_dimensions.dart';

class CustomBackButton extends StatelessWidget {
  final void Function()? onPressed;
  const CustomBackButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: AppDimensions.normalize(10),
      onPressed: onPressed ?? () => Navigator.pop(context),
      icon: Platform.isIOS
          ? Icon(
              Icons.arrow_back_ios,
              size: AppDimensions.normalize(8),
            )
          : Icon(
              Icons.arrow_back,
              size: AppDimensions.normalize(9),
            ),
    );
  }
}
