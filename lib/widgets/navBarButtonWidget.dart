import 'package:flutter/material.dart';

Widget navBarButtonWiget(
    {required String name,
    required IconData icon,
    required int id,
    required int selected,
    required String routeName,
    required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, routeName);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon,
            size: 30,
            color: id == selected
                ? Color.fromARGB(255, 102, 37, 73)
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
