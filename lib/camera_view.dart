import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hot_dog_not_hot_dog/widgets/camera_controls.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView({required this.cameras});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
        Expanded(child: CameraControls())
      ],
    );
  }
}
