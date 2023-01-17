import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/screens/camera_screen/image_captured.dart';
import 'package:noteapp/screens/camera_screen/video_captured.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

late List<CameraDescription> cameras;

class Camera extends StatefulWidget {
  final Function? onRecordComplete;
  final String? pageID;
  const Camera({Key? key, this.pageID, this.onRecordComplete})
      : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  double scale = 0;
  CameraController? controller;
  bool isFrontCameraOn = true;
  bool isFlashOn = false;
  bool isRecording = false;
  XFile? imageFile;
  XFile? videoFile;
  final stopWatchTimer = StopWatchTimer();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(cameras[0]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    //scale = getScale(state);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          controller != null
              ? Transform.scale(
                  scale: scale == 0 ? 16 / 9 : scale,
                  child: Center(
                    child: CameraPreview(controller!),
                  ))
              : Container(
                  color: Colors.black,
                  height: AppDimensions.size!.height,
                  width: AppDimensions.size!.height,
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.black,
                width: AppDimensions.size!.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Space.y!,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (isFrontCameraOn) {
                              return;
                            }

                            toggleFlash();
                          },
                          icon: Icon(
                            isFlashOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color:
                                isFrontCameraOn ? Colors.black : Colors.white,
                            size: AppDimensions.normalize(9),
                          ),
                        ),
                        GestureDetector(
                            onLongPress: () async {
                              toggleRecording();
                            },
                            onLongPressUp: () async {
                              toggleRecording();
                            },
                            onTap: () {
                              takePhoto();
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) =>
                                      ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                              child: controller != null &&
                                      controller!.value.isRecordingVideo
                                  ? Icon(
                                      key: const ValueKey(1),
                                      Icons.radio_button_checked_rounded,
                                      color: Colors.red,
                                      size: AppDimensions.normalize(20),
                                    )
                                  : Icon(
                                      key: const ValueKey(2),
                                      Icons.panorama_fish_eye_rounded,
                                      color: Colors.white,
                                      size: AppDimensions.normalize(20),
                                    ),
                            )),
                        IconButton(
                          onPressed: () => toggleCamera(),
                          icon: Icon(
                            Icons.cameraswitch_rounded,
                            color: Colors.white,
                            size: AppDimensions.normalize(9),
                          ),
                        )
                      ],
                    ),
                    Space.y!,
                    Text(
                      LocaleKeys.cameraLabel.tr(),
                      style: AppText.b2!.copyWith(
                          color: Colors.white,
                          fontSize: AppDimensions.normalize(4)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    Space.y!,
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: AppDimensions.normalize(20),
            left: EasyLocalization.of(context)!.currentLocale ==
                    const Locale('ar', 'SA')
                ? null
                : AppDimensions.normalize(5),
            right: EasyLocalization.of(context)!.currentLocale ==
                    const Locale('ar', 'SA')
                ? AppDimensions.normalize(5)
                : null,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black38,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Visibility(
              visible: controller != null && controller!.value.isRecordingVideo,
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Builder(builder: (context) {
                          return const SizedBox(
                            height: 24,
                            width: 24,
                            child: SpinKitDoubleBounce(
                              size: 20,
                              color: Colors.red,
                            ),
                          );
                        })),
                    StreamBuilder<int>(
                      stream: stopWatchTimer.rawTime,
                      initialData: 0,
                      builder: (context, snap) {
                        final value = snap.data;

                        final displayTime = StopWatchTimer.getDisplayTime(
                            value!,
                            milliSecond: false);
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggleCamera() {
    onNewCameraSelected(cameras[isFrontCameraOn ? 0 : 1]);
  }

  void takePhoto() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile file = await cameraController.takePicture();
      File imageFile = File(file.path);
      moveToImageCaptureScreen(imageFile.path);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void toggleRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isRecordingVideo) {
      try {
        videoFile = await cameraController.stopVideoRecording();
        File video = File(videoFile!.path);
        moveToVideoCapturedScreen(video.path);
        return;
      } on CameraException catch (e) {
        _showCameraException(e);
        return;
      }
    }

    try {
      await cameraController.startVideoRecording();
      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      stopWatchTimer.onExecute.add(StopWatchExecute.start);

      setState(() {});
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void toggleFlash() async {
    try {
      await controller!
          .setFlashMode(isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void moveToImageCaptureScreen(String imagePath) async {
    if (isFlashOn) {
      controller!.setFlashMode(FlashMode.off);
    }
    bool? result = await CustomNavigate.navigateToClass(
        context,
        ImageCaptured(
          image: imagePath,
          pageID: widget.pageID,
          onRecordComplete: widget.onRecordComplete,
        ));
    if (result != null && result) {
      goBackToMessageScreen();
    }
  }

  void moveToVideoCapturedScreen(String videoPath) async {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    if (isFlashOn) {
      controller!.setFlashMode(FlashMode.off);
    }
    final result = await CustomNavigate.navigateToClass(
        context,
        VideoCaptured(
            video: videoPath,
            pageID: widget.pageID,
            onRecordComplete: widget.onRecordComplete,
            scale: scale));
    if (result!) {
      goBackToMessageScreen();
    }
  }

  void goBackToMessageScreen() {
    Navigator.pop(context, true);
  }

  Future<double> getScale(cameraController) async {
    double scale = 0;

    scale =
        AppDimensions.size!.aspectRatio * cameraController!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return scale;
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        debugPrint("Camera Initialized : onNewCamera()");
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      scale = await getScale(cameraController);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }
    isFrontCameraOn = !isFrontCameraOn;

    if (mounted) {
      setState(() {});
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _logError(String code, String? message) {
    if (message != null) {
      debugPrint('Error: $code\nError Message: $message');
    } else {
      debugPrint('Error: $code');
    }
  }
}
