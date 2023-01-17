import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:video_player/video_player.dart';

class ExpandedVideoView extends StatefulWidget {
  final String? videoPath;
  const ExpandedVideoView({Key? key, this.videoPath}) : super(key: key);

  @override
  State<ExpandedVideoView> createState() => _ExpandedVideoViewState();
}

class _ExpandedVideoViewState extends State<ExpandedVideoView> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoPath!.split("data:")[1]))
          ..initialize().then((value) {
            setState(() {});
          });

    _videoPlayerController.setLooping(true);
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
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            backgroundColor: Colors.black),
        body: Stack(
          children: [
            Center(
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : const CircularProgressIndicator(),
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
        ));
  }
}
