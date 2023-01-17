import 'dart:io';

import 'package:flutter/material.dart';

class ExpandedImageView extends StatelessWidget {
  final String? imagePath;
  final String? tagKey;
  const ExpandedImageView({Key? key, this.imagePath, this.tagKey})
      : super(key: key);

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
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: tagKey!,
          child: Image.file(
            File(imagePath!),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
