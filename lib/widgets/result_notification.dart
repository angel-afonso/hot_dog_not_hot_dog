import 'package:flutter/material.dart';

enum Result { HotDog, NotHotDog }

class ResultNotification extends StatefulWidget {
  final Result result;

  ResultNotification(this.result);

  @override
  State<StatefulWidget> createState() => _ResultNotificationState();
}

class _ResultNotificationState extends State<ResultNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    position = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward().whenComplete(() {
      Future.delayed(Duration(seconds: 1), () {
        controller.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: position,
          child: Container(
            color: widget.result == Result.HotDog
                ? Colors.green
                : Theme.of(context).errorColor,
            child: Padding(
              padding: EdgeInsets.only(top: 82.0),
              child: Container(
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        widget.result == Result.HotDog
                            ? Icon(Icons.check)
                            : Icon(Icons.cancel_outlined),
                        Text(widget.result == Result.HotDog
                            ? 'Hot dog'
                            : 'Not hot dog'),
                        Container(),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
