import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/screens/note_detail/message_holders/base_holder.dart';

class ImageMessageholder extends StatelessWidget {
  final MessageModal? message;
  final bool? isReordarable;
  const ImageMessageholder(
      {Key? key, this.message, required this.isReordarable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isArabic =
        EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
    return Padding(
      padding: Space.hf(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChatBubble(
                elevation: AppTheme.c! == AppTheme.light ? 2 : 0,
                padding: Space.all(0.3),
                clipper: ChatBubbleClipper4(
                  type: isArabic
                      ? BubbleType.receiverBubble
                      : BubbleType.sendBubble,
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
                  child: Hero(
                    tag: message!.messageTime!,
                    child: Image.file(
                      File(
                        message!.actualMessage!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (isReordarable!)
                Padding(
                  padding: Space.hf(0.3),
                  child: const Icon(
                    Icons.reorder,
                    color: Colors.grey,
                  ),
                )
            ],
          ),
          Space.yf(0.25),
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
