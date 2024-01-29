import 'package:flutter/material.dart';

Widget leftTitleWidget(String title, double size) {
  return SizedBox(
    width: double.infinity,
    child: Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
