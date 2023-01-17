part of 'cubit.dart';

abstract class CameraState extends Equatable {
  final bool? isRecording;
  final bool? isFlashOn;
  final bool? isFrontCameraOn;
  final CameraController? cameraController;
  final Future<void>? cameravalue;
  final String? media;
  final bool? controllerInitialized;

  const CameraState({
    this.isFlashOn = false,
    this.isFrontCameraOn = false,
    this.isRecording = false,
    this.cameraController,
    this.cameravalue,
    this.media,
    this.controllerInitialized = false,
  });

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraPropState extends CameraState {
  const CameraPropState({
    cameraController,
    cameravalue,
  }) : super(
          isFlashOn: false,
          isFrontCameraOn: false,
          isRecording: false,
          controllerInitialized: true,
          cameraController: cameraController,
          cameravalue: cameravalue,
        );
}

class CameraRecordingStarted extends CameraState {
  const CameraRecordingStarted(
    CameraController camera,
    Future<void> cameravalue,
  ) : super(
          isRecording: true,
          cameraController: camera,
          cameravalue: cameravalue,
          controllerInitialized: true,
        );
}

class CameraRecordingStoped extends CameraState {
  const CameraRecordingStoped(
    String media,
    CameraController cameraController,
    Future<void> cameravalue,
  ) : super(
          isRecording: false,
          media: media,
          cameraController: cameraController,
          cameravalue: cameravalue,
          controllerInitialized: true,
        );
}

class FlashOn extends CameraState {
  const FlashOn(CameraController camera, Future<void> cameraval)
      : super(
          isFlashOn: true,
          cameraController: camera,
          controllerInitialized: true,
          cameravalue: cameraval,
        );
}

class FlashOff extends CameraState {
  const FlashOff(CameraController camera, Future<void> cameraval)
      : super(
          isFlashOn: false,
          cameraController: camera,
          controllerInitialized: true,
          cameravalue: cameraval,
        );
}

class ToggleFrontCamera extends CameraState {
  const ToggleFrontCamera(
      CameraController cameraController, Future<void> cameraValue)
      : super(
          isFrontCameraOn: false,
          cameraController: cameraController,
          cameravalue: cameraValue,
          controllerInitialized: true,
        );
}

class ToggleBackCamera extends CameraState {
  const ToggleBackCamera(
      CameraController cameraController, Future<void> cameraValue)
      : super(
          isFrontCameraOn: true,
          cameraController: cameraController,
          cameravalue: cameraValue,
          controllerInitialized: true,
        );
}

class CameraInitialized extends CameraState {
  const CameraInitialized(
      CameraController cameraController, Future<void> cameraValues)
      : super(
          cameraController: cameraController,
          cameravalue: cameraValues,
          controllerInitialized: true,
        );
}

class NavigateToImageSelectedPage extends CameraState {
  const NavigateToImageSelectedPage(
      String image, CameraController cameraController, Future<void> camVal)
      : super(
          media: image,
          controllerInitialized: true,
          cameraController: cameraController,
          cameravalue: camVal,
        );
}

class ResetCameraController extends CameraState {
  const ResetCameraController() : super(controllerInitialized: false);
}
