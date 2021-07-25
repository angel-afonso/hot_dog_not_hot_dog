import 'package:flutter/material.dart';
import 'package:hot_dog_not_hot_dog/widgets/result_notification.dart';

Future<void> showNotification(BuildContext context, Result result) {
  final entry = OverlayEntry(
    builder: (context) {
      return ResultNotification(result);
    },
  );

  Navigator.of(context).overlay!.insert(entry);

  return Future.delayed(Duration(seconds: 4, milliseconds: 500), () {
    entry.remove();
  });
}
