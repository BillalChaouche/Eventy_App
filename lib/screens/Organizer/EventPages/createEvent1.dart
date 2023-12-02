import 'package:flutter/material.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent2.dart';
import 'package:eventy/widgets/fileInputWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/widgets/inputWidgets.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PageAppBar(title: "Create Event"),
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              CircleStepRow(step: 1),
              const SizedBox(height: 35),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: const Text("Event details:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF4F4F4F),
                      ))),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 24, 30, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fullInput("Event name:", "Enter the event name"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Event type:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customDropdownInput(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Event description:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    descInput(),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Attached photo:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [FileInputWidget()],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PersonalizedButtonWidget(
                            context: context,
                            buttonText: "Next",
                            onClickListener: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateEvent2(),
                              ));
                            }),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  Widget customDropdownInput() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFBDBDBD), // Set the bottom border color
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField(
              items: const [
                DropdownMenuItem(
                  value: 'option1',
                  child: Text('Option 1'),
                ),
                DropdownMenuItem(
                  value: 'option2',
                  child: Text('Option 2'),
                ),
                DropdownMenuItem(
                  value: 'option3',
                  child: Text('Option 3'),
                ),
              ],
              onChanged: (value) {},
              icon: const Icon(
                Icons.arrow_drop_down, // Use a custom caret icon
                color: Colors.transparent, // Set the caret color to transparent
              ),
              decoration: const InputDecoration(
                hintText: 'Select an option',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFBDBDBD), // Set the color of the caret
          ),
        ],
      ),
    );
  }

  TextField customInput() {
    return const TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: '  Enter the event name',
        hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF662549)),
        ),
      ),
    );
  }

  TextField descInput() {
    return TextField(
      maxLines:
          5, // Set the maximum number of lines to make it a multiline input
      decoration: InputDecoration(
        hintText: 'Enter the description',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the border radius as needed
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF662549)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0), // Adjust padding as needed
      ),
    );
  }
}
