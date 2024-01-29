import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const ToggleSwitch({Key? key, this.onChanged}) : super(key: key);

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
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      activeColor: const Color(0xFF562525),
      inactiveThumbColor: Colors.black,
      inactiveTrackColor: Colors.grey,
    );
  }
}
