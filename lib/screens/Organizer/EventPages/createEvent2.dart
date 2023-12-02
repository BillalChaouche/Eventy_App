import 'package:flutter/material.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent3.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/inputWidgets.dart';

import 'package:intl/intl.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent2 extends StatefulWidget {
  @override
  _CreateEvent2State createState() => _CreateEvent2State();
}

class _CreateEvent2State extends State<CreateEvent2> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

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
                    fullInput("Location", "Address"),
                    const SizedBox(height: 35),
                    fullInput("City", "Enter the city"),
                    const SizedBox(height: 35),
                    fullInput("Country", "Your country"),
                    const SizedBox(height: 35),
                    fullInput("Available places", "Number of places"),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PersonalizedButtonWidget(
                            context: context,
                            buttonText: "Next",
                            onClickListener: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateEvent3(),
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
