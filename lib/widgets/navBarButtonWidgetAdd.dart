import 'package:flutter/material.dart';

typedef FunctionallityButton = void Function(int id);
Widget navBarButtonWigetAdd({
  required String name,
  required IconData icon,
  required int id,
  required int selected,
  required FunctionallityButton functionallityButton,
}) {
  return GestureDetector(
    onTap: () {
      functionallityButton(id);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon,
            size: 30,
            color: id == selected
                ? const Color.fromARGB(255, 102, 37, 73)
                : Colors.white),
        if (id == selected) const SizedBox(height: 4),
        if (id == selected)
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 102, 37, 73)),
          ),
      ],
    ),
  );
}
