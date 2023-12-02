import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isToggled,
      onChanged: (value) {
        setState(() {
          isToggled = value;
        });
      },
      activeColor: Color(0xFF562525), // Color when the switch is ON
      inactiveThumbColor: Colors.black, // Color when the switch is OFF
      inactiveTrackColor: Colors.grey, // Track color when the switch is OFF
    );
  }
}
