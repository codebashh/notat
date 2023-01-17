import 'package:flutter/material.dart';
import 'package:noteapp/configs/configs.dart';

class BaseHolder extends StatelessWidget {
  final Widget? child;
  final BoxConstraints? boxConstraints;
  const BaseHolder({Key? key, this.child, this.boxConstraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: boxConstraints,
      decoration: BoxDecoration(
        color: AppTheme.c!.primary!.withOpacity(0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: child,
      ),
    );
  }
}
