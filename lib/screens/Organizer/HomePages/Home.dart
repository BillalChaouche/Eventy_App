import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/screens/Organizer/EventPages/Event.dart';
import 'package:eventy/screens/Organizer/NotificationsPages/NotificationsPage.dart';
import 'package:eventy/widgets/cirlceIconWidget.dart';
import 'package:eventy/widgets/eventWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:eventy/models/EventEntity.dart';

class HomeOrganizer extends StatefulWidget {
  static List<EventEntity> events = [
    EventEntity(
        1,
        'UX/UI Tutorial Events',
        'Ensia School',
        '2023/01/21',
        '4:50 PM',
        'assets/images/UIUXEvent.jpg',
        200,
        "Is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
        1,
        0,
        0,
        'Ashraf', [
      'Education',
      'Learning',
      'IT'
    ]), // Example events; you may have a list of actual events here
    EventEntity(
        2,
        'Gaming Tutorial Events',
        'Algiers',
        '2023/01/24',
        '10:00 AM',
        'assets/images/gamingEvent.jpg',
        300,
        '',
        1,
        0,
        0,
        'Ashraf',
        ['Art', 'IT'])
  ];
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomeOrganizer> {
  final ScrollController _scrollController = ScrollController();
  bool showText = false; // Default text for the AppBar
  double heightAppBar = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    showText = false;
    heightAppBar = 0;
  }

  void _onScroll() {
    if (_scrollController.offset > 250 && _scrollController.offset < 310) {
      setState(() {
        showText = true;
        heightAppBar = _scrollController.offset - 250;
      });
    } else if (_scrollController.offset > 310) {
      setState(() {
        showText = true;
        heightAppBar = 50;
      });
    } else {
      setState(() {
        showText = false;
        heightAppBar = 0;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: heightAppBar,
          elevation: 0,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          title: Center(
            child: AnimatedOpacity(
              opacity: showText
                  ? 1.0
                  : 0.0, // Change opacity based on showText value
              duration: const Duration(milliseconds: 300),
              child: const Text(
                  "Events", // Dynamic text based on scroll position
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromARGB(255, 102, 37, 73))),
            ),
          ),
        ),
        // here all screen scroll
        body: SingleChildScrollView(
          controller: _scrollController,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profileWidget(47, 47, 'assets/images/OrgProfile.jpg', true,
                        NavigateToProfilePage),
                    circleIconWidget(47, 47, Ionicons.notifications_outline,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsOrganizerPage()),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 30),

                searchBarWidget(
                    hintText: "Search for events",
                    filter: false,
                    buttonFunctionality: () {},
                    context: context),
                const SizedBox(height: 25),

                leftTitleWidget('Events', 18),
                const SizedBox(height: 6),

                // and the scroll become only here on events
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: HomeOrganizer.events.length,
                    itemBuilder: (context, index) {
                      var event = HomeOrganizer.events[index];
                      return eventWidget(
                        // other parameters...
                        event: event,
                        buttonFunctionality: showEvent,
                        save: false,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showEvent(int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: Event(
            eventId: id,
          ),
        );
      },
    );
  }

  void NavigateToProfilePage() {
    Navigator.pushNamed(context, '/ProfileOrg');
  }
}
