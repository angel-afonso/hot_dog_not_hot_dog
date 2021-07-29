import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hot_dog_not_hot_dog/widgets/camera_controls.dart';
import 'package:hot_dog_not_hot_dog/widgets/result_notification.dart';
import 'package:image/image.dart' as image;
import 'package:hot_dog_not_hot_dog/util/utils.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView({required this.cameras});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static const platform = const MethodChannel('hotdog_model');

  late Future<void> _initializeControllerFuture;
  late CameraController _controller;

  int cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onCapture() async {
    final entry = showLoading(context);

    final file = await _controller.takePicture();

    final result = await platform.invokeMethod(
        'predict',
        image
            .decodeImage(new File(file.path).readAsBytesSync())!
            .getBytes(format: image.Format.rgb)) as Float64List;

    entry.remove();

    showNotification(
        context, result[0].round() == 0 ? Result.HotDog : Result.NotHotDog);
  }

  switchCamera() {
    cameraIndex = cameraIndex < widget.cameras.length - 1 ? cameraIndex + 1 : 0;

    setState(() {
      _controller =
          CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Expanded(flex: 6, child: CameraPreview(_controller)),
            Expanded(
              child: CameraControls(
                onCapture: onCapture,
                onSwitch: switchCamera,
              ),
            )
          ],
        );
      },
    );
  }
}
