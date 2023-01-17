import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/models/section.dart';

import '../../../app_navigations/custom_navigate.dart';
import '../../notes/notes.dart';

class SectionCard extends StatefulWidget {
  final Section? section;
  const SectionCard({Key? key, this.section}) : super(key: key);

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              CustomNavigate.navigateToClass(
                context,
                NotesScreen(
                  sectionName: widget.section!.title,
                  sectionId: widget.section!.id,
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                child: Text(
                  widget.section!.title[0],
                  style: AppText.h2!.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(widget.section!.title),
            subtitle: Text(
              widget.section!.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(isArabic()
                ? Icons.arrow_circle_left_rounded
                : Icons.arrow_circle_right_rounded),
          ),
        ],
      ),
    );
  }

  bool isArabic() =>
      EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
}
