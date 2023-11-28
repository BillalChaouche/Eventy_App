import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Dropdown extends StatefulWidget {
  final bool indexing;
  final double height;
  final List<String> options;
  String selectedOption;
  // callback function
  final Function(String) onChanged;

  Dropdown(
      {required this.options,
      required this.selectedOption,
      required this.onChanged,
      required this.indexing,
      required this.height});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(
        widget.selectedOption,
        style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedOption = newValue!;
          widget.onChanged(
              newValue); // Invoke the callback // Update selected option when changed
        });
      },
      underline: Container(
        height: 2,
        color: const Color.fromARGB(0, 210, 236, 255),
      ),
      iconSize: 0,
      dropdownColor: const Color.fromARGB(255, 102, 37, 73),
      elevation: 0,
      menuMaxHeight: widget.height,
      borderRadius: BorderRadius.circular(10.0),
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        if (index == widget.options.length && widget.indexing) {
          index = 0;
        }
        if (widget.indexing) {
          index++;
        }
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.indexing)
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    index.toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
