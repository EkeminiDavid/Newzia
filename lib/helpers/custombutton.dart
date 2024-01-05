import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.onPress,
    required this.title,
    this.buttonHorizontalPadding = 50,
  });

  final String title;
  final Function() onPress;
  final double buttonHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 15.0, horizontal: buttonHorizontalPadding),
      child: Material(
        elevation: 0,
        color: kNewziaRed,
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: double.infinity,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(color: kNewziaBackgroundWhite),
          ),
        ),
      ),
    );
  }
}


