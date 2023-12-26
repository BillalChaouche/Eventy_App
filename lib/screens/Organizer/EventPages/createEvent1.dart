import 'package:flutter/material.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent2.dart';
import 'package:eventy/widgets/fileInputWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/widgets/inputWidgets.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent1 extends StatefulWidget {
  @override
  _CreateEvent1State createState() => _CreateEvent1State();
}

class _CreateEvent1State extends State<CreateEvent1> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  String? _selectedEventType = '';
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = DBCategory.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: "Create Event"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CircleStepRow(step: 1),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text(
                  "Event details:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF4F4F4F),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 24, 30, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fullInput("Event name:", "Enter the event name",
                        _eventNameController),
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
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No categories available');
                        } else {
                          return customDropdownInput(snapshot);
                        }
                      },
                    ),
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
                    descInput(_eventDescriptionController),
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
                            // Capture values from input fields
                            String eventName = _eventNameController.text;
                            String? eventType = _selectedEventType;
                            String eventDescription =
                                _eventDescriptionController.text;

                            // Create the map
                            Map<String, dynamic> createdEvent = {
                              'eventName': eventName,
                              'eventType': eventType,
                              'eventDescription': eventDescription,
                            };

                            print(createdEvent);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CreateEvent2(createdEvent: createdEvent),
                            ));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customDropdownInput(snapshot) {
    List<Map<String, dynamic>> categories = snapshot.data!;
    List<DropdownMenuItem<String>> dropdownItems =
        categories.map<DropdownMenuItem<String>>((category) {
      return DropdownMenuItem<String>(
        value: category['name'] as String,
        child: Text(category['name'] as String),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField(
              items: dropdownItems,
              onChanged: (value) {
                // Handle the selected value
                print('Selected value: $value');
                setState(() {
                  _selectedEventType = value;
                });
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.transparent,
              ),
              decoration: InputDecoration(
                hintText: 'Select an option',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFBDBDBD),
          ),
        ],
      ),
    );
  }

  TextField customInput(TextEditingController inputController) {
    return TextField(
      controller: inputController,
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

  TextField descInput(TextEditingController inputController) {
    return TextField(
      controller: inputController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Enter the description',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF662549)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}
