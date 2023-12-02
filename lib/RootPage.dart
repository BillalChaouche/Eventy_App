import 'package:eventy/models/SharedData.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent1.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:eventy/screens/Organizer/NotificationsPages/Notifications.dart';
import 'package:eventy/screens/Organizer/SettingsPages/Settings.dart';
import 'package:eventy/screens/User/CategoryPages/Categories.dart';
import 'package:eventy/screens/User/EventPages/Events.dart';
import 'package:eventy/screens/User/HomePages/Home.dart';
import 'package:eventy/screens/User/SettingsPages/Settings.dart';
import 'package:eventy/widgets/navBarButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RootPage extends StatefulWidget {
  // Define a property to hold the current index

  RootPage({
    Key? key,
  }) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 1;
  final List<Widget> pagesUser = [
    Home(),
    Events(),
    Categories(),
    SettingsScreen(),
  ];
  final List<Widget> pagesOrganizer = [
    HomeOrganizer(),
  ];
  late PageController _pageController;
  late String choice = SharedData.instance.sharedVariable;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0; // Set the current index from the widget property
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: (SharedData.instance.sharedVariable == 'User')
              ? [
                  Home(), // Widgets that represent your different screens
                  Events(),
                  Categories(),
                  SettingsScreen(),
                ]
              : [
                  HomeOrganizer(),
                  NotificationsOrganizer(),
                  SettingsOrganizerScreen() // Widgets that represent your different screens
                ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(0, 0, 0, 0),
          elevation: 0,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          surfaceTintColor: Colors.black,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 244, 220, 220),
              borderRadius: BorderRadius.circular(40),
// White background
              // Border properties
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(76, 158, 158, 158).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 4),
            height: 63,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (SharedData.instance.sharedVariable == 'Organizer')
                  ? [
                      navBarButtonWiget(
                          name: 'Events',
                          icon: Ionicons.calendar,
                          id: 0,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Followers',
                          icon: Ionicons.people,
                          id: 5,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Add',
                          icon: Ionicons.add_circle,
                          id: 20,
                          selected: _currentIndex,
                          functionallityButton: showAddEvent),
                      navBarButtonWiget(
                          name: 'Notifications',
                          icon: Ionicons.notifications,
                          id: 1,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Settings',
                          icon: Ionicons.settings,
                          id: 2,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                    ]
                  : [
                      navBarButtonWiget(
                          name: 'Explore',
                          icon: Ionicons.compass,
                          id: 0,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Events',
                          icon: Ionicons.calendar,
                          id: 1,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Categories',
                          icon: Ionicons.apps,
                          id: 2,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                      navBarButtonWiget(
                          name: 'Settings',
                          icon: Ionicons.settings,
                          id: 3,
                          selected: _currentIndex,
                          functionallityButton: navigate),
                    ],
            ),
          ),
        ));
  }

  void navigate(int id) {
    setState(() {
      _currentIndex = id; // Update the currentIndex
      _pageController.animateToPage(
        id,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void showAddEvent(int nothing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: CreateEvent1(),
        );
      },
    );
  }
}
