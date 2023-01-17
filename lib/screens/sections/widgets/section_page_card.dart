import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';

import 'package:noteapp/models/note.dart';
import 'package:noteapp/screens/note_detail/note_detail.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/utils/constants.dart';

import '../../../widgets/label/label.dart';
import '../../../widgets/section_page_card/section_card.dart';

class SectionPageNoteCard extends StatefulWidget {
  final List<Note>? allNotes;
  const SectionPageNoteCard({Key? key, this.allNotes}) : super(key: key);

  @override
  State<SectionPageNoteCard> createState() => _SectionPageNoteCardState();
}

class _SectionPageNoteCardState extends State<SectionPageNoteCard> {
  late int remainingLabels;
  List<String> initialLabels = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionCategoryCard(
            text: LocaleKeys.pages.tr(),
          ),
          const Divider(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.allNotes!.length, (index) {
              initLabels(widget.allNotes![index]);

              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: widget.allNotes!.length - 1 == index
                      ? Colors.transparent
                      : Theme.of(context).dividerColor,
                ))),
                child: ListTile(
                  onTap: () {
                    CustomNavigate.navigateToClass(
                        context,
                        NoteDetailScreen(
                          pageID: widget.allNotes![index].id,
                          noteTitle: widget.allNotes![index].title,
                        ));
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200]!.withOpacity(0.4),
                    child: Center(
                      child: Icon(
                        Icons.bookmark,
                        color: getRandomColor(),
                      ),
                    ),
                  ),
                  title: Text(widget.allNotes![index].title),
                  subtitle: Row(
                    children: [
                      if (initialLabels.isNotEmpty) ...[
                        ...initialLabels.map((e) => Label(text: e)),
                        Label(text: '+$remainingLabels')
                      ] else
                        ...widget.allNotes![index].labels
                            .map((e) => Label(text: e)),
                    ],
                  ),
                  trailing:const  Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  initLabels(Note note) {
    if (note.labels.length > 2) {
      initialLabels = List.generate(2, (index) => note.labels[index]);
      remainingLabels = note.labels.length - 2;
    }
  }
}
