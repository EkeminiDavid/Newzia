import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';

class CustomNotificationDisplay extends StatelessWidget {
  const CustomNotificationDisplay({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: kNewziaGray, borderRadius: BorderRadius.circular(20)),
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: kNewziaBlue, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
