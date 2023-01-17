import 'package:flutter/material.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/widgets/label/label.dart';

import '../../note_detail/note_detail.dart';
import '../../notes/notes.dart';

class SearchedItemTile<T> extends StatelessWidget {
  final SearchedTileType? type;
  final T? data;
  const SearchedItemTile({Key? key, this.type, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        onTap: () => handleTileClick(context),
        leading: CircleAvatar(child: Text((data as dynamic).title[0])),
        title: Text((data as dynamic).title),
        subtitle: Row(
          children: [
            Label(text: type == SearchedTileType.page ? "Page" : "Section"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
      const Divider(),
    ]);
  }

  handleTileClick(context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (type == SearchedTileType.page) {
      CustomNavigate.navigateToClass(
          context,
          NoteDetailScreen(
            pageID: (data as dynamic).id!,
            noteTitle: (data as dynamic).title,
          ));
    } else {
      CustomNavigate.navigateToClass(
        context,
        NotesScreen(
          sectionName: (data as dynamic).title,
          sectionId: (data as dynamic).id,
        ),
      );
    }
  }
}
