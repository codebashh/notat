import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubits/note_page_cubit/cubit.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/utils/enums.dart';

class SendButton extends StatefulWidget {
  final TextEditingController? noteController;
  final String? pageID;
  final Function? insertMessageCallBack;
  const SendButton({
    Key? key,
    this.noteController,
    required this.insertMessageCallBack,
    required this.pageID,
  }) : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    final notePageCubit = BlocProvider.of<NotepageCubit>(context);

    return Row(
      children: [
        IconButton(
          onPressed: () {
            MessageModal m1 = MessageModal(
              actualMessage: widget.noteController!.text.trim(),
              messageDate: DateTime.now().toIso8601String(),
              messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
              pageID: widget.pageID,
              messageType: ChatMessageType.text,
            );

            widget.insertMessageCallBack!(m1);
            widget.noteController!.clear();
            notePageCubit.hideSendButton();
          },
          icon: const Icon(
            Icons.send,
          ),
        ),
      ],
    );
  }
}
