import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final List<Widget>? overlayWidgets;
  const Screen({
    Key? key,
    required this.child,
    this.overlayWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ...overlayWidgets ?? [],
      ],
    );
  }
}
