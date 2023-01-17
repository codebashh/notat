import 'package:flutter/material.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/screens/camera_screen/camera.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_buttons/record_button/record_button.dart';

class MediaBottons extends StatelessWidget {
  final Function? onRecordComplete;
  final String? pageID;
  final AnimationController? animationController;
  final VoidCallback? refreshState;
  const MediaBottons({
    Key? key,
    this.refreshState,
    this.animationController,
    required this.onRecordComplete,
    required this.pageID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          visualDensity: const VisualDensity(horizontal: -1, vertical: 0),
          splashRadius: 1,
          onPressed: () async {
            final result = await CustomNavigate.navigateToClass(
              context,
              Camera(
                pageID: pageID,
                onRecordComplete: onRecordComplete,
              ),
            );

            if (result != null && result) {
              refreshState!();
            }
          },
          icon: const Icon(
            Icons.camera_alt_outlined,
          ),
        ),
        RecordButton(
          controller: animationController!,
          onRecordComplete: onRecordComplete,
          pageID: pageID,
        )
      ],
    );
  }
}
