import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/configs/space.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/screens/notes/notes.dart';
import 'package:noteapp/screens/sections/sections.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/widgets/label/label.dart';
import 'package:provider/provider.dart';

import '../../screens/note_detail/note_detail.dart';
import '../../utils/enums.dart';

class NoteCard<T> extends StatefulWidget {
  final T? note;

  final NoteCardType? noteCardType;

  const NoteCard({Key? key, this.note, this.noteCardType}) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late String id;
  late String title;
  late String body = '';
  Color color = Colors.yellow;

  late int remainingLabels;
  List<String> initialLabels = [];
  @override
  void initState() {
    super.initState();
    initializeCard();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return InkWell(
      onTap: handleNoteCardTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: Space.vf(0.35),
        padding: Space.all(1),
        decoration: BoxDecoration(
          color: appProvider.isDark
              ? color.withOpacity(0.5)
              : color.withOpacity(0.75),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space.yf(0.3),
            Text(
              appProvider.view
                  ? title
                  : title.length > 12
                      ? '${title.substring(0, 12)}...'
                      : title,
              style: AppText.h3b,
              overflow: TextOverflow.ellipsis,
            ),
            Space.y!,
            Visibility(
              visible: widget.noteCardType != NoteCardType.notes,
              child: Text(
                body,
                style: AppText.b2,
                maxLines: appProvider.view ? 3 : 2,
              ),
            ),
            Space.y1!,
            Row(
              children: [
                if (widget.noteCardType == NoteCardType.notes)
                  if (initialLabels.isNotEmpty) ...[
                    ...initialLabels.map((e) => Label(text: e)),
                    Label(text: '+$remainingLabels')
                  ],
                if (widget.noteCardType == NoteCardType.section)
                  Label(
                      text: '${LocaleKeys.notes.tr()}: ${widget.note!.notes}'),
                if (widget.noteCardType == NoteCardType.notebook) ...[
                  const Spacer(),
                  Container(
                    padding: Space.all(),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appProvider.isDark
                          ? Colors.transparent.withOpacity(0.3)
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: Platform.isIOS
                        ? Icon(
                            Icons.arrow_forward_ios,
                            size: AppDimensions.normalize(8),
                          )
                        : Icon(
                            Icons.arrow_forward,
                            size: AppDimensions.normalize(8),
                          ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  void initializeCard() {
    if (widget.noteCardType != NoteCardType.notes) {
      body = widget.note!.body;
      color = widget.note!.color!;
    }
    id = widget.note!.id;
    title = widget.note!.title;

    if (widget.noteCardType == NoteCardType.notes &&
        widget.note!.labels.length > 2) {
      initialLabels = List.generate(2, (index) => widget.note!.labels[index]);
      remainingLabels = widget.note!.labels.length - 2;
    }
  }

  void handleNoteCardTap() {
    switch (widget.noteCardType) {
      case NoteCardType.notebook:
        CustomNavigate.navigateToClass(
          context,
          SectionsScreen(
            noteBookName: widget.note.title,
            notebookId: widget.note.id,
          ),
        );
        break;
      case NoteCardType.section:
        CustomNavigate.navigateToClass(
          context,
          NotesScreen(
            sectionName: widget.note.title,
            sectionId: widget.note.id,
          ),
        );
        break;
      case NoteCardType.notes:
        CustomNavigate.navigateToClass(
          context,
          NoteDetailScreen(
            pageID: widget.note.id!,
            noteTitle: widget.note.title,
          ),
        );
        break;
      default:
    }
  }
}
