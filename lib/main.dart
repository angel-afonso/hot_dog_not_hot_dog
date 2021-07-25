import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hot_dog_not_hot_dog/camera_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(HotDogNotHotDog(cameras));
}

class HotDogNotHotDog extends StatelessWidget {
  final List<CameraDescription> cameras;

  HotDogNotHotDog(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: CameraView(
          cameras: cameras,
        ),
      ),
    );
  }
}
