import 'package:flutter/material.dart';

typedef FunctionallityButton = void Function();

class buildbutton extends StatelessWidget {
  const buildbutton({
    Key? key,
    required this.text,
    required this.functionallityButton,
  }) : super(key: key);
  final String text;
  final FunctionallityButton functionallityButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x00662549).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Set the desired border radius
          ),
          padding: const EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20)),
      onPressed: () {
        functionallityButton();
      },
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
