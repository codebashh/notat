import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class TextMessageHolder extends StatelessWidget {
  final MessageModal? message;
  final bool? isReordarable;
  const TextMessageHolder({Key? key, this.message, required this.isReordarable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isArabic =
        EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
    return Padding(
      padding: Space.vf(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChatBubble(
                elevation: 0,
                clipper: ChatBubbleClipper4(
                  type: isArabic
                      ? BubbleType.receiverBubble
                      : BubbleType.sendBubble,
                  nipSize: 0.0,
                ),
                backGroundColor: AppTheme.c!.primary,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: AppDimensions.size!.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message!.actualMessage!,
                        style: AppText.b1!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Space.yf(0.25),
                    ],
                  ),
                ),
              ),
              isReordarable!
                  ? Padding(
                      padding: Space.h!,
                      child: const Icon(
                        Icons.reorder,
                        color: Colors.grey,
                      ),
                    )
                  : Space.x!
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat(" hh:mm a").format(
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
