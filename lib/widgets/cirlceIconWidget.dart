import 'package:flutter/material.dart';

typedef FunctionallityButton = void Function();

Widget circleIconWidget(
  double width,
  double height,
  IconData iconData, // Parameter for the icon data)
  FunctionallityButton functionallityButton,
) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white, // White background
      // Border properties
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(76, 158, 158, 158).withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(2, 0),
        ),
      ],
    ),
    child: ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            functionallityButton();
          },
          child: Center(
            child: Icon(
              iconData,
              color: const Color.fromARGB(
                  255, 102, 37, 73), // Red color for the icon
              size: 25, // Adjust the size of the icon
            ),
          ),
        ),
      ),
    ),
  );
}
