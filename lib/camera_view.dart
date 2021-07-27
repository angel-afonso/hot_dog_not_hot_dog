import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hot_dog_not_hot_dog/widgets/camera_controls.dart';
import 'package:hot_dog_not_hot_dog/widgets/result_notification.dart';
import 'package:image/image.dart' as image;
import 'package:hot_dog_not_hot_dog/util/notification.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView({required this.cameras});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  static const platform = const MethodChannel('hotdog_model');

  initialize() {
    super.initState();

    final camera = widget.cameras.first;

    _controller = CameraController(camera, ResolutionPreset.max);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();

    initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onCapture() async {
    final file = await _controller.takePicture();

    final result = await platform.invokeMethod(
        'predict',
        image
            .decodeImage(new File(file.path).readAsBytesSync())!
            .getBytes(format: image.Format.rgb)) as Float64List;

    print(result);

    showNotification(
        context, result[0].round() == 0 ? Result.HotDog : Result.NotHotDog);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Expanded(
            child: CameraControls(
          onCapture: onCapture,
        ))
      ],
    );
  }
}
