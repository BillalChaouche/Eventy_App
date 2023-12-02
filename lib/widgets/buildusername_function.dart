import 'package:flutter/material.dart';

Widget buildusernamewidget() {
  return Padding(
    padding: const EdgeInsets.only(left: 20 , right: 20 , top: 20),
    child: TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        label: Text('Full Name'),
        hintText: 'Enter Full Name',
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
