import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

typedef ButtonFunctionality = void Function();

Widget searchBarWidget(
    {required String hintText,
    required bool filter,
    required ButtonFunctionality buttonFunctionality}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
    height: 55,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: const Color.fromARGB(90, 228, 228, 228),
      // Border properties
      borderRadius: BorderRadius.circular(160),
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
      children: [
        const Icon(Icons.search,
            color: Color.fromARGB(255, 102, 37, 73) // Search icon color
            ),
        const SizedBox(
            width: 13), // Add space between search icon and input field
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              fillColor: Colors.grey,
              hintText: hintText, // Placeholder text
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
              border: InputBorder.none, // Remove input field border
            ),
          ),
        ),
        const SizedBox(
            width: 10), // Add space between input field and filter icon
        (filter)
            ? GestureDetector(
                onTap: () {
                  buttonFunctionality();
                },
                child: const Icon(
                  Ionicons.filter_outline,
                  color: Color.fromARGB(255, 102, 37, 73),
                ),
              )
            : Container()
      ],
    ),
  );
}
