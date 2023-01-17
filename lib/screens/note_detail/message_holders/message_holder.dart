import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/screens/note_detail/message_holders/text_message_holder/text_message_holder.dart';
import 'package:noteapp/screens/note_detail/message_holders/video_message_holder/video_message_holder.dart';
import 'package:noteapp/translations/locale_keys.g.dart';

import '../../../app_navigations/custom_navigate.dart';
import '../../../cubits/note_page_cubit/cubit.dart';
import '../../../models/message_modal.dart';
import '../../../utils/enums.dart';
import '../../../widgets/text_fields/universal_text_field.dart';
import '../expanded_media_views/expanded_image.dart';
import '../expanded_media_views/expanded_video.dart';
import 'audio_message_holder/audio_message_holder.dart';
import 'image_message_holder/image_message_holder.dart';

class MessageHolder extends StatefulWidget {
  final MessageModal? message;
  final bool? isReordarable;
  final String? pageID;
  const MessageHolder(
      {Key? key,
      required this.isReordarable,
      required this.message,
      required this.pageID})
      : super(key: key);

  @override
  State<MessageHolder> createState() => _MessageHolderState();
}

class _MessageHolderState extends State<MessageHolder> {
  @override
  Widget build(BuildContext context) {
    switch (widget.message!.messageType) {
      case ChatMessageType.text:
        return widget.isReordarable!
            ? TextMessageHolder(
                message: widget.message,
                isReordarable: widget.isReordarable,
              )
            : GestureDetector(
                onLongPress: () => showEditDeleteSheet(widget.message!),
                child: TextMessageHolder(
                    isReordarable: widget.isReordarable,
                    message: widget.message));
      case ChatMessageType.image:
        return widget.isReordarable!
            ? InkWell(
                onTap: () {
                  CustomNavigate.navigateToClass(
                    context,
                    ExpandedImageView(
                      imagePath: widget.message!.actualMessage,
                      tagKey: widget.message!.messageTime!,
                    ),
                  );
                },
                child: ImageMessageholder(
                  isReordarable: widget.isReordarable,
                  message: widget.message,
                ),
              )
            : GestureDetector(
                onLongPress: () => showDeleteSheet(widget.message!),
                onTap: () {
                  CustomNavigate.navigateToClass(
                    context,
                    ExpandedImageView(
                      imagePath: widget.message!.actualMessage,
                      tagKey: widget.message!.messageTime!,
                    ),
                  );
                },
                child: ImageMessageholder(
                  isReordarable: widget.isReordarable,
                  message: widget.message,
                ),
              );
      case ChatMessageType.video:
        return widget.isReordarable!
            ? InkWell(
                onTap: () {
                  CustomNavigate.navigateToClass(
                    context,
                    ExpandedVideoView(
                      videoPath: widget.message!.actualMessage,
                    ),
                  );
                },
                child: VideoMessageHolder(
                  isReordarable: widget.isReordarable,
                  message: widget.message,
                ),
              )
            : GestureDetector(
                onLongPress: () => showDeleteSheet(widget.message!),
                onTap: () {
                  CustomNavigate.navigateToClass(
                    context,
                    ExpandedVideoView(
                      videoPath: widget.message!.actualMessage,
                    ),
                  );
                },
                child: VideoMessageHolder(
                  isReordarable: widget.isReordarable,
                  message: widget.message,
                ),
              );
      case ChatMessageType.audio:
        return AudioMessageHolder(
          isReordarable: widget.isReordarable,
          onDeleteCallBack: () =>
              widget.isReordarable! ? null : showDeleteSheet(widget.message!),
          message: widget.message,
        );
      default:
        return Text(widget.message!.actualMessage!);
    }
  }

  void showDeleteSheet(MessageModal note) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:  AppTheme.c!.background!,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Space.yf(0.5),
              ListTile(
                  onTap: () {
                    BlocProvider.of<NotepageCubit>(context)
                        .deleteMessage(note, widget.pageID);
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.delete_outline,
                  ),
                  title: const Text("Delete Message"),
                ),
                Space.yf(0.5),
            ],
          ),
        );
      },
    );
  }

  void showEditDeleteSheet(MessageModal note) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.c!.background!,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              note.messageType == ChatMessageType.text
                  ? ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        editMessage(note);
                      },
                      leading: const Icon(
                        Icons.edit,
                      ),
                      title: const Text("Edit Message"),
                    )
                  : Space.yf(0.1),
              ListTile(
                onTap: () {
                  BlocProvider.of<NotepageCubit>(context)
                      .deleteMessage(note, widget.pageID);
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Message Deleted");
                },
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text("Delete Message"),
              ),
            ],
          ),
        );
      },
    );
  }

  editMessage(MessageModal note) {
    String newText = note.actualMessage!;
    String currentText = note.actualMessage!;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: Space.all(),
            decoration: BoxDecoration(
              color: AppTheme.c!.background!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: AppDimensions.size!.height * 0.4,
            child: Column(
              children: [
                const Text("Edit Message"),
                UniversalTextField(
                  label: "Message Description",
                  onChange: (value) {
                    newText = value;
                  },
                  initialValue: currentText,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newText.isEmpty) {
                      Fluttertoast.showToast(
                          msg: LocaleKeys.allFieldsAreMandatory.tr());
                      return;
                    } else if (currentText == newText) {
                      Fluttertoast.showToast(msg: "No Changes Made");
                      Navigator.pop(context);
                    } else {
                      MessageModal message = MessageModal(
                        pageID: note.pageID,
                        actualMessage: newText,
                        messageTime: note.messageTime,
                        messageDate: note.messageDate,
                        messageType: note.messageType,
                      );
                      onUpdatePressed(message);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update"),
                )
              ],
            ),
          );
        });
  }

  void onUpdatePressed(MessageModal message) async {
    try {
      await BlocProvider.of<NotepageCubit>(context).editMessage(message);
      Fluttertoast.showToast(msg: "Message updated");
      setState(() {
        TextMessageHolder(
          isReordarable: widget.isReordarable,
          message: message,
        );
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Editing");
    }
  }
}
