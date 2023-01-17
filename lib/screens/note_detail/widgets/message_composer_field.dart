import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/cubits/note_page_cubit/cubit.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/translations/locale_keys.g.dart';

class MessageComposerField extends StatelessWidget {
  final FocusNode? keyboardFocus;
  final TextEditingController? noteController;
  const MessageComposerField(
      {Key? key, this.keyboardFocus, this.noteController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notePageCubit = BlocProvider.of<NotepageCubit>(context);
    return Expanded(
      child: Container(
        margin: Space.hf(0.25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppProvider.state(context).isDark
                ? Colors.grey
                : AppTheme.c!.shadow!,
          ),
        ),
        padding: Space.h,
        child: TextField(
          focusNode: keyboardFocus,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 5,
          minLines: 1,
          style: AppText.b1,
          onChanged: (val) {
            if (val.isEmpty) {
              notePageCubit.hideSendButton();
            } else {
              notePageCubit.showSendButton();
            }
          },
          controller: noteController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: Space.all(),
            hintText: LocaleKeys.typeHere.tr(),
            hintStyle: AppText.b2!.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
