import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../configs/app_theme.dart';
import '../../configs/app_typography.dart';
import '../../configs/space.dart';
import '../../providers/app_provider.dart';

class ActiveLabel extends StatefulWidget {
  final String text;
  final int? id;
  final Function(int, bool)? onChanged;
  const ActiveLabel({
    Key? key,
    required this.text,
    required this.onChanged,
    this.id,
  }) : super(key: key);

  @override
  State<ActiveLabel> createState() => _ActiveLabelState();
}

class _ActiveLabelState extends State<ActiveLabel> {
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return InkWell(
      onTap: () {
        setState(() {
          isActive = !isActive;
          widget.onChanged!(widget.id!, isActive);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4, top: 5, bottom: 5),
        padding: Space.all(0.8, 0.3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isActive
              ? Colors.blue
              : appProvider.isDark
                  ? Colors.transparent.withOpacity(0.3)
                  : Colors.grey[200],
        ),
        child: Center(
          child: Row(
            children: [
              Text(
                widget.text,
                style: AppText.l1!.copyWith(
                    color: isActive ? Colors.white : AppTheme.c!.textSub),
              ),
              Visibility(
                  visible: isActive,
                  child: Row(
                    children: [
                      Space.x1!,
                      const CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 12,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
