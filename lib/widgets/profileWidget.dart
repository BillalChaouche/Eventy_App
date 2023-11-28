import 'package:eventy/widgets/blurButton.dart';
import 'package:flutter/material.dart';

typedef FunctionallityButton = void Function();
Widget profileWidget(double width, double height, String imageSrc, bool shadow,
    FunctionallityButton functionallityButton) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
          color: const Color.fromARGB(255, 102, 37, 73),
          width: 2.0), // Border properties
      boxShadow: [
        if (shadow)
          BoxShadow(
            color: const Color.fromARGB(120, 158, 158, 158)
                .withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: Offset(2, 2), // Shadow position
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
          child: Ink.image(
            image: AssetImage(imageSrc), // Your image path
            fit: BoxFit.cover, // Image fit inside the button
          ),
        ),
      ),
    ),
  );
}
