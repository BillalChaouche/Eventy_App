import 'package:flutter/material.dart';

Widget buildemailwidget(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20 , right: 20 , top: 20),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        label: const Text('Email'),
        hintText: 'Enter Email',
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
