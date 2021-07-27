import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final Function onCapture;

  CameraControls({required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            child: IconButton(
              padding: EdgeInsets.all(26.0),
              onPressed: () {
                onCapture();
              },
              icon: Icon(Icons.camera),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.cameraswitch)),
          ),
        ),
      ],
    );
  }
}
