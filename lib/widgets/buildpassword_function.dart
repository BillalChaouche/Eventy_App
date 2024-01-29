import 'package:flutter/material.dart';

Widget buildpasswordwidget(String text , TextEditingController controller , TextEditingController passwordController , formKey) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: text,
              hintText: 'Enter password',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              // Validate the password confirmation
              if (text.toLowerCase().contains('confirm') && value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null; // Return null if the validation passes
            },
          ),
        ),
        if (text.toLowerCase().contains('confirm'))  // Display error text only for Confirm Password field
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
            child: Text(
              formKey.currentState?.fields[text]?.errorText ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
  

