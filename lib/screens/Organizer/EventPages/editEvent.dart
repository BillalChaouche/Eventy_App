import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:flutter/material.dart';
import 'package:eventy/widgets/fileInputWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/inputWidgets.dart';
import 'package:eventy/models/EventEntity.dart';

class EditEvent extends StatelessWidget {
  final int eventId;
  const EditEvent({
    Key? key,
    required this.eventId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EventEntity event =
        HomeOrganizer.events.firstWhere((event) => event.id == eventId);
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 70),
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
                fullInput("Event name:", "Enter the event name",
                    defaultInput: event.title),
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
                descInput(defaultDesc: event.description),
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
                  children: [FileInputWidget(DEF_IMG_PATH: event.imgPath)],
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PersonalizedButtonWidget(
                        context: context,
                        buttonText: "Save",
                        onClickListener: () {}),
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

  TextField descInput({String? defaultDesc}) {
    return TextField(
      controller: TextEditingController(text: defaultDesc),
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
