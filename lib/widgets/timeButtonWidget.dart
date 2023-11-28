import 'package:flutter/material.dart';

typedef OnTimeSelected = void Function(String selected);

Widget timeButtonWidget({
  required String title,
  required String selected,
  required OnTimeSelected onTimeSelected,
}) {
  return ElevatedButton(
    onPressed: () {
      onTimeSelected(title);
    },
    style: ElevatedButton.styleFrom(
      // Disable highlight effect
      elevation: 0,
      backgroundColor: (title == selected)
          ? const Color.fromARGB(255, 102, 37, 73)
          : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Border radius
        side: const BorderSide(
            color: Color.fromARGB(255, 232, 232, 232)), // Border color
      ),
      splashFactory: NoSplash.splashFactory, // Remove ripple effect
    ),
    child: Text(
      title,
      style: TextStyle(
          color: (title == selected)
              ? Colors.white
              : const Color.fromARGB(255, 125, 125, 125),
          fontSize: 14),
    ),
  );
}
