import 'package:flutter/material.dart';

Widget leftTitleWidget(String title, double size) {
  return Container(
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
