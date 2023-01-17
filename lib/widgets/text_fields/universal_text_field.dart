import 'package:flutter/material.dart';
import 'package:noteapp/configs/configs.dart';

class UniversalTextField extends StatelessWidget {
  final double? elevation;
  final String? label;
  final EdgeInsets? horizontalMargin;
  final int? maxLines;
  final Function(String)? onChange;
  final String? initialValue;
  const UniversalTextField({
    Key? key,
    this.elevation,
    this.label,
    this.horizontalMargin,
    this.maxLines,
    this.onChange,
    this.initialValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Space.all(0.4),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChange!,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UIProps.radius),
            borderSide: BorderSide(
              color: AppTheme.c!.text!.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UIProps.radius),
            borderSide: BorderSide(
              color: AppTheme.c!.text!,
            ),
          ),
        ),
        maxLines: maxLines ?? 1,
      ),
    );
  }
}
