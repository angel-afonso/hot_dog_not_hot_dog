import 'package:flutter/material.dart';
import 'package:hot_dog_not_hot_dog/util/notification.dart';
import 'package:hot_dog_not_hot_dog/widgets/result_notification.dart';

class CameraControls extends StatelessWidget {
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
                print('press');
                showNotification(context, Result.HotDog);
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
