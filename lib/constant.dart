import 'package:flutter/material.dart';

const kNewziaRed = Color(0XFFFF2950);
const kNewziaBlue = Color(0XFF192E51);
const kNewziaLynch = Color(0XFF607698);
const kNewziaGray = Color(0XFFE9E9F0);
const kNewziaSurfaceWhite = Color(0xFFFFFBFA);
const kNewziaBackgroundWhite = Colors.white;
const kApiKey = '083d38bf174b49569452440e55835d68';

InputDecoration customInputDecoration() {
  return InputDecoration(
    hintText: '',
    hintStyle: const TextStyle(color: kNewziaBlue),
    fillColor: kNewziaGray,
    suffixIconColor: kNewziaLynch,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(15.0), // Adjust the value as needed
    ),
  );
}
