import 'package:flutter/material.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent3.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/inputWidgets.dart';

import 'package:intl/intl.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent2 extends StatefulWidget {
  final Map<String, dynamic> createdEvent;

  const CreateEvent2({Key? key, required this.createdEvent}) : super(key: key);

  @override
  _CreateEvent2State createState() => _CreateEvent2State();
}

class _CreateEvent2State extends State<CreateEvent2> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController availablePlacesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController? controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      controller?.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController? controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      controller?.text = selectedTime.format(context);
    }
  }

  String convertTo24Format(String time) {
    List<String> components = time.split(' ');

    String hourMinute = components[0];
    String amPm = components[1];

    List<String> hourMinuteParts = hourMinute.split(':');
    int hour = int.parse(hourMinuteParts[0]);
    int minute = int.parse(hourMinuteParts[1]);

    if (amPm.toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    } else if (amPm.toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    return '$hour:${minute.toString().padLeft(2, '0')}:00';
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
              const CircleStepRow(step: 2),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text(
                  "Event date and time:",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ICONFullInput(
                            "Start date",
                            const Icon(Icons.calendar_today),
                            startDateController,
                            () => _selectDate(context, startDateController)),
                        ICONFullInput(
                            "End date",
                            const Icon(Icons.calendar_today),
                            endDateController,
                            () => _selectDate(context, endDateController)),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ICONFullInput(
                            "Start time",
                            const Icon(Icons.access_time),
                            startTimeController,
                            () => _selectTime(context, startTimeController)),
                        ICONFullInput(
                            "End time",
                            const Icon(Icons.access_time),
                            endTimeController,
                            () => _selectTime(context, endTimeController)),
                      ],
                    ),
                    const SizedBox(height: 35),
                    fullInput("Location", "Address", locationController),
                    const SizedBox(height: 35),
                    fullInput("Available places", "Number of places",
                        availablePlacesController),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PersonalizedButtonWidget(
                            context: context,
                            buttonText: "Next",
                            onClickListener: () {
                              // Append input info to createdEvent map
                              widget.createdEvent['startDate'] =
                                  startDateController.text;
                              widget.createdEvent['endDate'] =
                                  endDateController.text;
                              widget.createdEvent['startTime'] =
                                  convertTo24Format(startTimeController.text);
                              widget.createdEvent['endTime'] =
                                  convertTo24Format(endTimeController.text);
                              widget.createdEvent['location'] =
                                  locationController.text;
                              widget.createdEvent['availablePlaces'] =
                                  int.parse(availablePlacesController.text);

                              print(widget.createdEvent);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateEvent3(
                                    createdEvent: widget.createdEvent),
                              ));
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ICONFullInput(String title, Icon myIcon,
      TextEditingController controller, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF363636),
            fontWeight: FontWeight.bold,
          ),
        ),
        customICONInput(myIcon, controller, onPressed),
      ],
    );
  }

  Widget customICONInput(
      Icon myIcon, TextEditingController controller, VoidCallback onPressed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.27,
          child: GestureDetector(
            onTap: onPressed,
            child: TextField(
              readOnly: true,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: 'Select here',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF662549)),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: myIcon,
          iconSize: 20,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
