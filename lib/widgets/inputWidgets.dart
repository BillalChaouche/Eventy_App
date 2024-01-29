import 'package:flutter/material.dart';

Widget fullInput(String title, String hint, TextEditingController inputController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF363636),
          fontWeight: FontWeight.bold,
        ),
      ),
      TextField(
        controller : inputController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF662549)),
          ),
        ),
      ),
    ],
  );
}

