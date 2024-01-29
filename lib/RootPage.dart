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

  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

Future<String?> getChoice() async {
  return await SharedData.instance.getSharedVariable();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 1;
  final List<Widget> pagesUser = [
    const Home(),
    const Events(),
    const Categories(),
    const SettingsScreen(),
  ];
  final List<Widget> pagesOrganizer = [
    const HomeOrganizer(),
  ];
  late PageController _pageController;
  late Future<String?> choice;
  @override
  void initState() {
    super.initState();
    choice = getChoice();
    _currentIndex = 0; // Set the current index from the widget property

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: choice,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, you can return a loading indicator
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle error state
            return Text('Error: ${snapshot.error}');
          } else {
            // Once the future completes, use the value for comparison
            final String? choiceValue = snapshot.data;

            return Scaffold(
                extendBody: true,
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: (choiceValue == 'User')
                      ? [
                          const Home(), // Widgets that represent your different screens
                          const Events(),
                          const Categories(),
                          const SettingsScreen(),
                        ]
                      : [
                          const HomeOrganizer(),
                          const NotificationsOrganizer(),
                          const SettingsOrganizerScreen() // Widgets that represent your different screens
                        ],
                ),
                bottomNavigationBar: BottomAppBar(
                  color: const Color.fromARGB(0, 0, 0, 0),
                  elevation: 0,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 8.0,
                  surfaceTintColor: Colors.black,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 220, 220),
                      borderRadius: BorderRadius.circular(40),
// White background
                      // Border properties
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(76, 158, 158, 158)
                              .withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                    height: 63,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: (choiceValue == 'Organizer')
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
        });
  }

  void navigate(int id) {
    setState(() {
      _currentIndex = id; // Update the currentIndex
      _pageController.animateToPage(
        id,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void showAddEvent(int nothing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: const CreateEvent1(),
        );
      },
    );
  }
}
