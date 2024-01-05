import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  const TextLabel({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
      ),
    );
  }
}
