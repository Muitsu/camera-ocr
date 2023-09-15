import 'dart:typed_data';

import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final Uint8List imgBytes;
  const ViewImage({super.key, required this.imgBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.memory(imgBytes, fit: BoxFit.cover),
    );
  }
}
