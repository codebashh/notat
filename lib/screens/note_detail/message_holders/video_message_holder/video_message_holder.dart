import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/screens/note_detail/message_holders/base_holder.dart';

class VideoMessageHolder extends StatelessWidget {
  final MessageModal? message;
  final bool? isReordarable;
  const VideoMessageHolder(
      {Key? key, this.message, required this.isReordarable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Space.vf(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChatBubble(
                elevation: AppTheme.c! == AppTheme.light ? 2 : 0,
                padding: Space.all(0.3),
                clipper: ChatBubbleClipper4(
                  type: BubbleType.sendBubble,
                  nipSize: 0.0,
                ),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 20),
                backGroundColor: AppTheme.c!.primary,
                child: BaseHolder(
                  boxConstraints: BoxConstraints(
                    maxWidth: AppDimensions.size!.width * 0.7,
                    maxHeight: AppDimensions.size!.height * 0.5,
                  ),
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Image.file(
                        File(message!.actualMessage!.split("data:")[2]),
                        fit: BoxFit.cover,
                      ),
                      const Positioned(
                        bottom: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white38,
                          child: Center(
                            child: Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              (isReordarable!)
                  ? Padding(
                      padding: Space.h!,
                      child: const Icon(
                        Icons.reorder,
                        color: Colors.grey,
                      ),
                    )
                  : Space.xf(0.4)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat("hh:mm a").format(
                  DateTime.parse(
                    message!.messageDate!,
                  ),
                ),
                style: AppText.l1,
              ),
            ],
          )
        ],
      ),
    );
  }
}
