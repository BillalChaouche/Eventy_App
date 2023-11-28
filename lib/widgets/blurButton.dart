import 'dart:ui';
import 'package:flutter/material.dart';

typedef FunctionallityButton = void Function();

Widget blurButton({
  required IconData icon,
  required double width,
  required double height,
  required double iconSize,
  required Color color,
  required FunctionallityButton functionallityButton,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: const Color.fromARGB(0, 217, 218, 219),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 30,
          width: 30,
          color: const Color.fromARGB(131, 255, 255, 255).withOpacity(0.3),
          child: Center(
            child: GestureDetector(
              onTap: () {
                functionallityButton();
              },
              child: Icon(
                icon,
                color: color,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
