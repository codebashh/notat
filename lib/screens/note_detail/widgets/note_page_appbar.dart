import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:noteapp/configs/app_typography.dart';

class NotePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? reorderCallBack;
  const NotePageAppBar({Key? key, this.title, this.reorderCallBack})
      : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      shadowColor: AppTheme.c!.shadow,
      elevation: 2,
      title: Text(
        title!,
        style: AppText.b1,
      ),
      centerTitle: true,
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          tooltip: "Reorder notes",
          onPressed: () {
            reorderCallBack!();
          },
          icon: const Icon(
            Icons.swipe_vertical_sharp,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
