import 'package:flutter/material.dart';

Widget buildpasswordwidget(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 20 , right: 20 , top: 20),
    child: TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        label: Text(text),
        hintText: 'Enter password',
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
