import 'package:flutter/material.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/cubits/note_page_cubit/cubit.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/screens/note_detail/widgets/message_composer_field.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/attachement_button.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/media_buttons.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/send_button.dart';

class MessageComposer extends StatelessWidget {
  final NotepageState? state;
  final VoidCallback? unfocusKeyboard;
  final FocusNode? keboardFocus;
  final TextEditingController? noteController;
  final VoidCallback? refreshState;
  final Function? insertMessageCallBack;
  final AnimationController? animationController;
  final String? pageID;
  const MessageComposer({
    Key? key,
    this.state,
    this.unfocusKeyboard,
    required this.keboardFocus,
    required this.noteController,
    required this.refreshState,
    required this.insertMessageCallBack,
    required this.animationController,
    required this.pageID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: AppDimensions.maxContainerWidth,
        constraints: BoxConstraints(
          maxHeight: AppDimensions.normalize(45),
        ),
        color: AppProvider.state(context).isDark
            ? Colors.grey[900]
            : AppTheme.c!.background,
        child: Padding(
          padding: Space.all(0.4, 0.45),
          child: Row(
            children: [
              Space.xf(0.2),
              AttachmentButton(keyboardCallback: unfocusKeyboard),
              Space.xf(0.2),
              MessageComposerField(
                keyboardFocus: keboardFocus,
                noteController: noteController,
              ),
              state is NotePageHideSendButton
                  ? MediaBottons(
                      refreshState: refreshState,
                      animationController: animationController,
                      onRecordComplete: insertMessageCallBack,
                      pageID: pageID,
                    )
                  : state is NotePageShowSendButton
                      ? SendButton(
                          insertMessageCallBack: insertMessageCallBack,
                          noteController: noteController,
                          pageID: pageID,
                        )
                      : MediaBottons(
                          refreshState: refreshState,
                          animationController: animationController,
                          onRecordComplete: insertMessageCallBack,
                          pageID: pageID,
                        )
            ],
          ),
        ),
      ),
    );
  }
}
