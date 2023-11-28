import 'package:flutter/material.dart';

Widget categoryType({required String title}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(30, 6, 30, 6),
    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 244, 220, 220),
      shape: BoxShape.rectangle, // Border properties
      borderRadius: BorderRadius.circular(100),
    ),
    child: Center(
        child: Text(
      title,
      style: TextStyle(color: Colors.white),
    )),
  );
}
