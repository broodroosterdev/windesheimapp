import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  final void Function() onBack;
  final void Function() onForward;
  final String text;

  const BottomNavigator(
      {Key? key,
      required this.onBack,
      required this.onForward,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: TextButton(
              onPressed: onBack,
              child: const Icon(Icons.chevron_left, size: 48))),
      Expanded(
          flex: 4,
          child: Text(
            text,
            textAlign: TextAlign.center,
          )),
      Expanded(
          flex: 1,
          child: TextButton(
              onPressed: onForward,
              child: const Icon(Icons.chevron_right, size: 48)))
    ]);
  }
}
