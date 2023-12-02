import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/widgets/notificationCard.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageAppBar(
            title: 'Notifications', context: context, backButton: true),
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
                      notificationCard(
                          title: 'Time Update',
                          des: 'The event UX/UI change it time to 21/02/2024',
                          date: "19/02/2024",
                          time: "10:45 AM",
                          imgPath: "assets/images/UIUXEvent.jpg",
                          urgent: true),
                      notificationCard(
                          title: 'Reminder',
                          des: 'The Gaming event start Tomorrow at 10:00AM',
                          date: "19/02/2024",
                          time: "11:13 AM",
                          imgPath: "assets/images/gamingEvent.jpg",
                          urgent: false)
                    ]))));
  }
}
