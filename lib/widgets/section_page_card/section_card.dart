import 'package:flutter/material.dart';

import '../../configs/app_theme.dart';
import '../../configs/app_typography.dart';
import '../../configs/space.dart';

class SectionCategoryCard extends StatelessWidget {
  final String? text;
  const SectionCategoryCard({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.c!.primary!.withOpacity(0.8),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text!,
              style: AppText.h3!.copyWith(color: Colors.white),
            ),
            Space.x!,
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
