import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCaptured extends StatefulWidget {
  final String? video;
  final String? pageID;
  final Function? onRecordComplete;
  final double? scale;
  const VideoCaptured({
    Key? key,
    this.video,
    this.pageID,
    this.onRecordComplete,
    this.scale,
  }) : super(key: key);

  @override
  State<VideoCaptured> createState() => _VideoCapturedState();
}

class _VideoCapturedState extends State<VideoCaptured> {
  late VideoPlayerController _videoPlayerController;
  late String thumbnail;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(widget.video!))
      ..initialize().then((value) {
        setState(() {});
      });

    _videoPlayerController.setLooping(true);
    getVideoThumnail(context);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveVideoToDatabase(context);
        },
        child: const Icon(Icons.check_rounded),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _videoPlayerController.value.isInitialized
                ? Center(
                    child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController)),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
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
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _videoPlayerController.value.isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  radius: 30,
                  child: Icon(
                    _videoPlayerController.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: AppDimensions.normalize(20),
                    color: AppTheme.c!.background,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteFileAndGoBack(context) {
    File(widget.video!).delete();
    Navigator.pop(context, false);
  }

  Future<void> saveVideoToDatabase(BuildContext context) async {
    String paths = "data:${widget.video}data:$thumbnail";

    MessageModal mm = MessageModal(
        actualMessage: paths,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        messageType: ChatMessageType.video,
        pageID: widget.pageID!);

    await widget.onRecordComplete!(mm);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> getVideoThumnail(context) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.video!,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );

    debugPrint(fileName);
    thumbnail = fileName!;
  }
}
