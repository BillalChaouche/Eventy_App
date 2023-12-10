import 'dart:ui';

import 'package:eventy/models/EventEntity.dart';
import 'package:eventy/screens/Organizer/EventPages/editEvent.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:eventy/widgets/LikeTableWidget.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:eventy/widgets/categoryType.dart';
import 'package:eventy/widgets/eventDetail.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

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
  bool isManagingSelected = false;

  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contex) {
    EventEntity event =
        HomeOrganizer.events.firstWhere((event) => event.id == widget.eventId);

    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
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
                    image: AssetImage(
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
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  overviewPage(event),
                  managingPage(),
                ],
              )),
            ]),
        Positioned(
          bottom: 400.0,
          left: (MediaQuery.of(context).size.width / 5),
          // Adjust 50.0 based on the width of your widget
          child:
              topPageViewButtons(), // Replace YourWidget with your actual widget
        ),
      ]),
      bottomNavigationBar:
          isManagingSelected ? bottomScanButton() : bottomEditButton(event.id),
    );
  }

  Widget bottomEditButton(int eventId) {
    return Container(
      height: 60, // Set the height of the bottom navbar
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
            title: 'EDIT', buttonFunctionality: () => {showEDITEvent(eventId)}),
      ),
    );
  }

  Widget bottomScanButton() {
    return Container(
      height: 60, // Set the height of the bottom navbar
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
        child:
            flaotingButtonWidget(title: 'SCAN', buttonFunctionality: () => {}),
      ),
    );
  }

  void showEDITEvent(int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: EditEvent(
            eventId: id,
          ),
        );
      },
    );
  }

  Widget managingPage() {
    return SingleChildScrollView(child: LikeTableWidget());
  }

  Widget overviewPage(EventEntity event) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            18,
            40,
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
                      categoryType(title: 'IT'),
                      categoryType(title: 'Gaming'),
                    ]),
                SizedBox(height: 30),
                eventDetail(
                    firstTitle: "29 October, 2023",
                    secondTitle: "10:00AM - 12:00AM",
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
              ])),
    );
  }

  Widget topPageViewButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(220, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      clipBehavior: Clip.hardEdge,
      width: MediaQuery.of(context).size.width * 0.6,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                color:
                    isManagingSelected ? Colors.transparent : Color(0xFF662549),
              ),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Color(0xFFCE99A3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    onTap: () {
                      setState(() {
                        isManagingSelected = false;
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    },
                    child: Center(
                      child: Text(
                        "Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isManagingSelected
                              ? Color(0xFF662549)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color:
                    isManagingSelected ? Color(0xFF662549) : Colors.transparent,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Color(0xFFCE99A3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                  onTap: () {
                    setState(() {
                      isManagingSelected = true;
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  child: Center(
                    child: Text(
                      "Managing",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isManagingSelected
                            ? Colors.white
                            : Color(0xFF662549),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
