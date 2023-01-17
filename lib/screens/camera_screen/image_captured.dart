import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/utils/enums.dart';

class ImageCaptured extends StatefulWidget {
  final String? image;
  final String? pageID;
  final Function? onRecordComplete;

  const ImageCaptured({
    Key? key,
    this.image,
    this.pageID,
    this.onRecordComplete,
  }) : super(key: key);

  @override
  State<ImageCaptured> createState() => _ImageCapturedState();
}

class _ImageCapturedState extends State<ImageCaptured> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveImageToDatabase(context);
        },
        child: const Icon(Icons.check_rounded),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: AppDimensions.size!.height,
            width: AppDimensions.size!.width,
            child: Image.file(
              File(widget.image!),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: AppDimensions.normalize(15),
            left: AppDimensions.normalize(5),
            child: InkWell(
              onTap: () {
                deleteFileAndGoBack(context);
              },
              child: CircleAvatar(
                radius: AppDimensions.normalize(10),
                backgroundColor: AppTheme.c!.shadow,
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    color: AppTheme.c!.background,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void deleteFileAndGoBack(context) {
    File(widget.image!).delete();
    Navigator.pop(context, false);
  }

  void saveImageToDatabase(BuildContext context) async {
    MessageModal mm = MessageModal(
        actualMessage: widget.image!,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        messageType: ChatMessageType.image,
        pageID: widget.pageID!);

    await widget.onRecordComplete!(mm)
        .then((bool saved) => Navigator.pop(context, true));
  }
}
