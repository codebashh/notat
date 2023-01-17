import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/models/message_modal.dart';

class AudioMessageHolder extends StatefulWidget {
  final MessageModal? message;
  final VoidCallback? onDeleteCallBack;
  final bool? isReordarable;
  const AudioMessageHolder(
      {Key? key,
      required this.message,
      this.onDeleteCallBack,
      this.isReordarable})
      : super(key: key);

  @override
  State<AudioMessageHolder> createState() => _AudioMessageHolderState();
}

class _AudioMessageHolderState extends State<AudioMessageHolder> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    if (widget.isReordarable!) {
      player.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    player.setFilePath(widget.message!.actualMessage!).then((value) {
      setState(() {
        debugPrint(
            "Audio Player initiated for : ${widget.message!.actualMessage}");
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.isReordarable!
                    ? body()
                    : GestureDetector(
                        onLongPress: () {
                          player.stop();
                          widget.onDeleteCallBack!();
                        },
                        child: body(),
                      ),
                (widget.isReordarable!)
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
                  DateFormat(" hh:mm a").format(
                    DateTime.parse(
                      widget.message!.messageDate!,
                    ),
                  ),
                  style: AppText.l1,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget body() => Container(
        height: AppDimensions.normalize(25),
        width: AppDimensions.size!.width * 0.75,
        padding: Space.all(),
        margin: Space.vf(0.15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.c!.primary,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  );
                } else if (playing != true) {
                  return GestureDetector(
                    onTap: player.play,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return GestureDetector(
                    onTap: player.pause,
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return GestureDetector(
                    child: const Icon(
                      Icons.replay,
                      color: Colors.white,
                    ),
                    onTap: () => player.seek(Duration.zero),
                  );
                }
              },
            ),
            Space.xf(0.5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Space.yf(0.5),
                  StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.c!.accent!,
                              ),
                              value: snapshot.data!.inMilliseconds /
                                  (duration?.inMilliseconds ?? 1),
                            ),
                            Space.yf(0.25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prettyDuration(snapshot.data! == Duration.zero
                                      ? duration ?? Duration.zero
                                      : snapshot.data!),
                                  style: AppText.l1!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return "$min:$sec";
  }
}
