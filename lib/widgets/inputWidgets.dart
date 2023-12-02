import 'package:flutter/material.dart';

Widget fullInput(String title, String hint, {String? defaultInput}) {
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
        controller: TextEditingController(text: defaultInput ?? null),
      ),
    ],
  );
}

