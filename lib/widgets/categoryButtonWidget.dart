import 'package:flutter/material.dart';

typedef OnCategorySelected = void Function(bool isSelected);

Widget categoryButtonWidget({
  required IconData icon,
  required String text,
  required bool isSelected,
  required OnCategorySelected onCategorySelected,
}) {
  return GestureDetector(
    onTap: () {
      onCategorySelected(!isSelected);
    },
    child: Container(
      height: 50,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isSelected
            ? const Color.fromARGB(255, 102, 37, 73)
            : const Color.fromARGB(255, 255, 255, 255), // Border properties
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(0, 176, 176, 176)
                .withOpacity(0.1), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(-2, -2), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 102, 37, 73),
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 102, 37, 73),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
