import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/Providers/EventProvider.dart';

import 'package:eventy/screens/User/EventPages/AcceptedEvent.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';
import 'package:eventy/widgets/eventCard.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String choice = "Booked";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choice = "Booked";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      home: Scaffold(
        appBar:
            PageAppBar(title: 'Events', context: context, backButton: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              20,
              18,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(79, 199, 199, 199).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          choice = 'Booked';
                          setState(() {
                            choice;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor: (choice == "Booked")
                              ? Color.fromARGB(255, 102, 37, 73)
                              : Color.fromARGB(255, 255, 255, 255),
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                120), // Button 1 border radius
                          ),
                        ),
                        child: Text(
                          'Booked',
                          style: TextStyle(
                            color: (choice == "Booked")
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 102, 37, 73),
                          ),
                        ),
                      )),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          choice = 'Accepted';
                          setState(() {
                            choice;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor: (choice == "Accepted")
                              ? Color.fromARGB(255, 102, 37, 73)
                              : Color.fromARGB(255, 255, 255, 255),
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                120), // Button 1 border radius
                          ),
                        ),
                        child: Text(
                          'Accepted',
                          style: TextStyle(
                            color: (choice == "Accepted")
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 102, 37, 73),
                          ),
                        ),
                      )),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          choice = 'Saved';
                          setState(() {
                            choice;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor: (choice == "Saved")
                              ? Color.fromARGB(255, 102, 37, 73)
                              : Color.fromARGB(255, 255, 255, 255),
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                          ), // Padding here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                120), // Button 1 border radius
                          ),
                        ),
                        child: Text(
                          'Saved',
                          style: TextStyle(
                            color: (choice == "Saved")
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 102, 37, 73),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Provider.of<EventProvider>(context).events.length,
                  itemBuilder: (context, index) {
                    var event =
                        Provider.of<EventProvider>(context).events[index];
                    if (choice == 'Accepted' && event.accepted) {
                      return eventCard(
                        event: event,
                        choiceAccpeted: true,
                        buttonFunctionality: NavigateToAcceptedEventPage,
                      );
                    } else if (choice == 'Booked' && event.booked) {
                      return eventCard(
                        event: event,
                        choiceAccpeted: false,
                        buttonFunctionality: NavigateToEventPage,
                      );
                    } else if (choice == 'Saved' && event.saved) {
                      return eventCard(
                        event: event,
                        choiceAccpeted: false,
                        buttonFunctionality: NavigateToEventPage,
                      );
                    }
                    // If none of the conditions are met, return a placeholder widget or null
                    // return Placeholder(); // Example placeholder widget
                    return SizedBox(); // Return an empty SizedBox as a placeholder
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void NavigateToEventPage(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event(eventId: id)),
    );
  }

  void NavigateToAcceptedEventPage(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AcceptedEvent(eventId: id)),
    );
  }
}
