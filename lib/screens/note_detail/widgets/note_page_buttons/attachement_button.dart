import 'package:flutter/material.dart';
import 'package:noteapp/configs/app_dimensions.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback? keyboardCallback;
  const AttachmentButton({Key? key, this.keyboardCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showAttachmentSheet(context),
      icon: const Icon(
        Icons.add,
      ),
    );
  }

  void showAttachmentSheet(context) {
    keyboardCallback!();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: AppDimensions.normalize(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("~ Future Funtionalities - Attachments"),
            ],
          ),
        );
      },
    );
  }
}
