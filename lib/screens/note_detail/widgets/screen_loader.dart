import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_dimensions.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.size!.height,
      width: AppDimensions.size!.width,
      color: Colors.black38,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
