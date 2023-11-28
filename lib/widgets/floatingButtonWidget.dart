import 'package:flutter/material.dart';

typedef ButtonFunctionality = void Function();
Widget flaotingButtonWidget({
  required String title,
  required ButtonFunctionality buttonFunctionality,
}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    height: 50,
    child: FloatingActionButton.extended(
      backgroundColor: const Color.fromARGB(255, 102, 37, 73),
      elevation: 0,
      extendedPadding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
      onPressed: () {
        // the action preformed on this call function
        buttonFunctionality();
      },
      label: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
