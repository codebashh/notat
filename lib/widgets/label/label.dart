import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/configs/space.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:provider/provider.dart';

class Label extends StatelessWidget {
  final String text;
  const Label({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Container(
      margin: const EdgeInsets.only(right: 4, top: 5, bottom: 5),
      padding: Space.all(0.8, 0.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: appProvider.isDark
            ? Colors.transparent.withOpacity(0.3)
            : Colors.grey[200],
      ),
      child: Center(
        child: Text(
          text,
          style: AppText.l1,
        ),
      ),
    );
  }
}
