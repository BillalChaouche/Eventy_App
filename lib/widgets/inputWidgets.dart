import 'package:flutter/material.dart';

Widget fullInput(String title, String hint, TextEditingController inputController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Color(0xFF363636),
          fontWeight: FontWeight.bold,
        ),
      ),
      TextField(
        controller : inputController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF662549)),
          ),
        ),
      ),
    ],
  );
}

