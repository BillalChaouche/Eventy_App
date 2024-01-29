import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildboxwidget({required TextEditingController controller}) {
  return SizedBox(
    height: 70,
    width: 65,
    child: TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 18, // Adjust the font size as needed
        fontWeight: FontWeight.bold, // Adjust the font weight as needed
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(20), // Adjust padding as needed
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15), // Adjust the border radius as needed
          ),
        ),
      ),
    ),
  );
}
