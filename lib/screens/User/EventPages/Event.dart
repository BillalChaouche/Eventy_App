import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:eventy/widgets/categoryType.dart';
import 'package:eventy/widgets/eventDetail.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Event extends StatefulWidget {
  final int eventId;

  const Event({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext contex) {
    EventEntity event = Provider.of<EventProvider>(context)
        .events
        .firstWhere((event) => event.id == widget.eventId);
    return Consumer<EventProvider>(builder: (context, eventProvider, _) {
      return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  // Optional: Add border radius
                  image: DecorationImage(
                    image: (event.imgPath[0] == 'h')
                        ? CachedNetworkImageProvider(event.imgPath)
                        : CachedNetworkImageProvider(
                            AppConfig.backendBaseUrlImg +
                                event.imgPath), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            blurButton(
                                icon: Ionicons.chevron_back_outline,
                                width: 40,
                                height: 40,
                                iconSize: 18,
                                color: Colors.white,
                                functionallityButton: () =>
                                    {Navigator.pop(context)})
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            blurButton(
                                icon: (event.saved == 1)
                                    ? Ionicons.bookmark
                                    : Ionicons.bookmark_outline,
                                width: 40,
                                height: 40,
                                iconSize: 16,
                                color: Colors.white,
                                functionallityButton: () {
                                  eventProvider.toggleEventSavedState(event.id);
                                }),
                            SizedBox(width: 10),
                            blurButton(
                                icon: Ionicons.share_social_outline,
                                width: 40,
                                height: 40,
                                iconSize: 17,
                                color: Colors.white,
                                functionallityButton: () => {})
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        width: double.infinity,
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
                              leftTitleWidget("${event.title}", 25),
                              SizedBox(height: 10),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    categoryType(title: event.categories[0]),
                                  ]),
                              SizedBox(height: 30),
                              eventDetail(
                                  firstTitle: event.date,
                                  secondTitle: event.time,
                                  need: "date"),
                              SizedBox(height: 15),
                              eventDetail(
                                  firstTitle: "${event.location}",
                                  secondTitle: "Oran center ville",
                                  need: "location"),
                              SizedBox(height: 15),
                              eventDetail(
                                  firstTitle: "${event.organizer}",
                                  secondTitle: "Organizer",
                                  need: "Image"),
                              SizedBox(height: 20),
                              leftTitleWidget('About Event', 18),
                              SizedBox(height: 10),
                              Text(
                                "   ${event.description}",
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: Color.fromARGB(141, 0, 0, 0),
                                ),
                              ),
                              SizedBox(height: 20),
                            ]))),
              )
            ]),
        bottomNavigationBar: Container(
          height: 80, // Set the height of the bottom navbar
          decoration: BoxDecoration(
            // Set background color to white
            boxShadow: [
              BoxShadow(
                color: Colors.white, // Set shadow color to white
                blurRadius: 15, // Adjust the blur radius
                offset: Offset(0, -20), // Set shadow offset
              ),
            ],
          ),
          child: Center(
            child: flaotingButtonWidget(
                title: (event.booked == 1) ? 'ALREADY BOOKED' : 'BOOK A TICKET',
                buttonFunctionality: () => {
                      if (event.booked == 0)
                        {eventProvider.toggleEventBookedState(event.id)}
                    }),
          ),
        ),
      ); // Add elevation (shadow));
    });
  }
}
