import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noteapp/configs/app_directories.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/record_button/widgets/flow_shader.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/record_button/widgets/lottie_animation.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  final Function? onRecordComplete;
  final String? pageID;
  const RecordButton(
      {Key? key,
      required this.controller,
      required this.onRecordComplete,
      required this.pageID})
      : super(key: key);

  final AnimationController controller;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 48;
  bool isRecording = false;
  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  Record record = Record();

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth = AppDimensions.size!.width - 8;
    timerAnimation = Tween<double>(begin: timerWidth + 8, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation = Tween<double>(begin: lockerHeight + 8, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  bool initialized = false;
  @override
  void dispose() {
    if (initialized) {
      record.dispose();
    }
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  bool isArabic() =>
      EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value * 1.2,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: AppTheme.c!.backgroundSub,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FaIcon(FontAwesomeIcons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
                direction: Axis.vertical,
                flowColors: AppTheme.c! == AppTheme.light
                    ? [
                        AppTheme.dark.background!,
                        AppTheme.light.background!,
                      ]
                    : [
                        AppTheme.dark.background!,
                        AppTheme.light.background!,
                      ],
                child: Column(
                  children: const [
                    Icon(Icons.keyboard_arrow_up),
                    Icon(Icons.keyboard_arrow_up),
                    Icon(Icons.keyboard_arrow_up),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: isArabic() ? null : -timerAnimation.value,
      left: isArabic() ? -timerAnimation.value : null,
      child: Container(
        height: size,
        width: timerWidth - AppDimensions.normalize(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: AppTheme.c!.backgroundSub,
        ),
        child: Padding(
          padding: Space.h1!,
          child: Row(
            children: [
              showLottie ? const LottieAnimation() : Text(recordDuration),
              Space.xm!,
              FlowShader(
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
                child: Row(
                  children: [
                    isArabic()
                        ? const Icon(Icons.keyboard_arrow_right)
                        : const Icon(Icons.keyboard_arrow_left),
                    const Text("Slide to cancel"),
                  ],
                ),
              ),
              Space.x2!,
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: isArabic() ? null : 0,
      left: isArabic() ? 0 : null,
      child: Container(
        height: size,
        width: timerWidth - AppDimensions.normalize(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: AppTheme.c!.backgroundSub,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Vibrate.feedback(FeedbackType.success);
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";

              await Record().stop().then((filePath) {
                saveRecording(filePath);
              });

              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(recordDuration),
                FlowShader(
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                  child: const Text("Tap lock to stop"),
                ),
                const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: const SizedBox(
          height: size,
          width: size,
          child: Icon(
            Icons.mic_outlined,
          ),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        if (mounted) {
          setState(() {
            isRecording = true;
          });
        }
        widget.controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");

        if (isCancelled(details.localPosition, context)) {
          Vibrate.feedback(FeedbackType.heavy);

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          if (mounted) {
            setState(() {
              showLottie = true;
            });
          }

          Timer(const Duration(milliseconds: 1440), () async {
            widget.controller.reverse();
            debugPrint("Cancelled recording");

            var filePath = await record.stop();
            debugPrint(filePath);
            File(filePath!).delete();
            debugPrint("Deleted $filePath");
            showLottie = false;
          });
        } else if (checkIsLocked(details.localPosition)) {
          widget.controller.reverse();

          Vibrate.feedback(FeedbackType.heavy);
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          widget.controller.reverse().whenComplete(() => setState(() {
                isRecording = false;
              }));

          Vibrate.feedback(FeedbackType.success);

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          await Record().stop().then((filePath) {
            saveRecording(filePath);
          });
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        widget.controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        Vibrate.feedback(FeedbackType.success);

        record = Record();
        // if (await record.hasPermission()) {
        await record.start(
          path:
              "${AppDirectories.audiosDirectory!.path}audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
          encoder: AudioEncoder.AAC,
          bitRate: 128000,
          samplingRate: 44100,
        );
        startTime = DateTime.now();
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          final minDur = DateTime.now().difference(startTime!).inMinutes;
          final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
          String min = minDur < 10 ? "0$minDur" : minDur.toString();
          String sec = secDur < 10 ? "0$secDur" : secDur.toString();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              recordDuration = "$min:$sec";
            });
          });
        });
        // }

        initialized = true;
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return isArabic()
        ? (offset.dx > MediaQuery.of(context).size.width * 0.2)
        : (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }

  void saveRecording(
    String? filePath,
  ) {
    MessageModal mm = MessageModal(
        actualMessage: filePath,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        messageType: ChatMessageType.audio,
        pageID: widget.pageID);
    widget.onRecordComplete!(mm);
    debugPrint(filePath);
  }
}
