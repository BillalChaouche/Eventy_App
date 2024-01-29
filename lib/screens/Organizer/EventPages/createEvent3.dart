import 'package:eventy/databases/DBeventOrg.dart';
import 'package:flutter/material.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/widgets/toggleWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent3 extends StatefulWidget {
  final Map<String, dynamic> createdEvent;

  const CreateEvent3({Key? key, required this.createdEvent}) : super(key: key);

  @override
  _CreateEvent3State createState() => _CreateEvent3State();
}

class _CreateEvent3State extends State<CreateEvent3> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool acceptDirectly = false;
    bool deleteAfterDeadline = false;
    return Scaffold(
      appBar: const PageAppBar(title: "Create Event"),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            const CircleStepRow(step: 3),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text("Other options:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF4F4F4F),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  toggleElement(
                    context,
                    "Accept directly",
                    (value) => acceptDirectly = value,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  toggleElement(
                    context,
                    "Delete after the deadline",
                    (value) => deleteAfterDeadline = value,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            isLoading
                ? const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                    strokeWidth: 2,
                  )
                : PersonalizedButtonWidget(
                    context: context,
                    buttonText: "Finish",
                    onClickListener: () async {
                      setState(() {
                        isLoading = true;
                      });
                      print("GOING TO INSERT EVENT IN LOCAL");

                      // Insert the event into the EventsOrg table
                      await DBEventOrg.insertRecord({
                        'title': widget.createdEvent['eventName'],
                        'imagePath': widget.createdEvent[
                            'imagePath'], // Add the imagePath if available
                        'start_date': widget.createdEvent['startDate'],
                        'start_time': widget.createdEvent['startTime'],
                        'end_date': widget.createdEvent['endDate'],
                        'end_time': widget.createdEvent['endTime'],
                        'description': widget.createdEvent['eventDescription'],
                        'location': widget.createdEvent['location'],
                        'category': widget.createdEvent['eventType'],
                        'attendees': widget.createdEvent['availablePlaces'],
                        'flag': 1,
                        'create_date': DateTime.now().toString(),
                        'accept_directly': acceptDirectly,
                        'delete_after_deadline': deleteAfterDeadline
                      });

                      print("Event inserted SUCCESSFULLY IN LOCAL DB");
                      setState(() {
                        isLoading = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New event inserted successfully'),
                        ),
                      );

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }

  Container toggleElement(
      BuildContext context, String text, Function(bool) onChanged) {
    bool isSwitched = false;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 14.0,
            height: 14.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF562525),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ToggleSwitch(
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
