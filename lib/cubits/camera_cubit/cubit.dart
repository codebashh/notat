import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/screens/camera_screen/camera.dart';

part 'state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraInitial());

  static CameraCubit cubit(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<CameraCubit>(context, listen: listen);

  Future<void> initCamera() async {
    emit(const ResetCameraController());
    CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    Future<void> cameravalue = cameraController.initialize();
    cameravalue.whenComplete(
      () => emit(
        CameraInitialized(
          cameraController,
          cameravalue,
        ),
      ),
    );
  }

  void toggleFlash(
      bool flashVal, CameraController camera, Future<void> values) async {
    await camera.setFlashMode(flashVal ? FlashMode.torch : FlashMode.off);

    if (flashVal) {
      emit(FlashOn(camera, values));
    } else {
      emit(FlashOff(camera, values));
    }
  }

  Future<void> toggleRecording(
      bool recordingVal,
      CameraController cameraController,
      Future<void> cameravalue,
      bool isFrontCameraOn) async {
    if (recordingVal) {
      await cameraController.startVideoRecording();
      emit(CameraRecordingStarted(
        cameraController,
        cameravalue,
      ));
    } else {
      XFile video = await cameraController.stopVideoRecording();
      File videoFile = File(video.path);

      emit(
        CameraRecordingStoped(
          videoFile.path,
          cameraController,
          cameravalue,
        ),
      );
    }
  }

  Future<void> toggleCamera(bool camera, CameraController cameraController,
      Future<void> cameraValue) async {
    if (camera) {
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
      Future<void> cameraVal = cameraController.initialize();
      cameraVal.whenComplete(
          () => emit(ToggleFrontCamera(cameraController, cameraVal)));
    } else {
      cameraController = CameraController(cameras[1], ResolutionPreset.high);
      Future<void> cameraVal = cameraController.initialize();
      cameraVal.whenComplete(
        () => emit(
          ToggleBackCamera(cameraController, cameraVal),
        ),
      );
    }
  }

  void takePhoto(CameraController cameraController, Future<void> camVal,
      String pageID) async {
    XFile file = await cameraController.takePicture();
    File? image = File(file.path);

    emit(NavigateToImageSelectedPage(image.path, cameraController, camVal));
  }

  void resetState(CameraState state) {
    emit(CameraPropState(
      cameraController: state.cameraController,
      cameravalue: state.cameravalue,
    ));
  }
}
