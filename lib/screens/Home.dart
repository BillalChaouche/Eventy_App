import 'package:eventy/Components/BottomNavbar.dart';
import 'package:eventy/Providers/EventProvider.dart';

import 'package:eventy/screens/Filter.dart';
import 'package:eventy/screens/Event.dart';

import 'package:eventy/widgets/categoryButtonWidget.dart';
import 'package:eventy/widgets/cirlceIconWidget.dart';
import 'package:eventy/widgets/eventWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool showText = false; // Default text for the AppBar
  double heightAppBar = 0;

  // categories information simple
  Map<String, Map<String, dynamic>> categoryState = {
    'My feed': {'selected': true, 'icon': Icons.home},
    'Education': {'selected': false, 'icon': Icons.school},
    'Music': {'selected': false, 'icon': Ionicons.musical_notes},
    'Sport': {'selected': false, 'icon': Ionicons.football},
  };

  // events inforamtion simple

  Map<int, List<dynamic>> events = {
    1: [
      'UX/UI Tutorial Events',
      'Ensia School  -- 2023/01/21 4:50 PM',
      200,
      'assets/images/UIUXEvent.jpg'
    ],
    2: [
      'Gaming Tutorial Events',
      'Algiers  -- 2023/01/24 10:00 AM',
      300,
      'assets/images/gamingEvent.jpg'
    ],
    3: [
      "Quantum physics Events",
      "Algiers  -- 2023/01/24 10:00 AM",
      800,
      "assets/images/quantumEvent.jpg"
    ],
    4: [
      "Quantum physics Events",
      "Algiers  -- 2023/01/24 10:00 AM",
      800,
      "assets/images/quantumEvent.jpg"
    ]
    // Add more IDs and their associated values as needed
  };
  // Fetching events from the provider
  List<String> wilayas = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Alger",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane"
  ];
  // location and time
  String location = "Choose Wilaya";
  String time = "Any Time";
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
                      profileWidget(47, 47, 'assets/images/profile.jpg', true,
                          NavigateToProfilePage),
                      circleIconWidget(47, 47, Ionicons.notifications_outline,
                          () {
                        Navigator.pushNamed(context, '/Notifications');
                      }),
                    ],
                  ),
                  const SizedBox(height: 30),

                  searchBarWidget(
                      hintText: "Search for events",
                      buttonFunctionality: showFilter),
                  const SizedBox(height: 25),
                  leftTitleWidget('Categories', 18),
                  // I want this elements which are categoires when they reach the top the main scrool stop
                  Container(
                    height: 80, // Set the desired height
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: [
                            for (var entry in categoryState.entries)
                              categoryButtonWidget(
                                icon: entry.value['icon'],
                                text: entry.key,
                                isSelected: entry.value['selected'],
                                onCategorySelected: (isSelected) {
                                  setState(() {
                                    categoryState[entry.key]!['selected'] =
                                        isSelected;
                                    _resetOtherCategories(entry.key);
                                  });
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  leftTitleWidget('Events', 18),
                  const SizedBox(height: 6),

                  // and the scroll become only here on events
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        var event =
                            Provider.of<EventProvider>(context).events[index];
                        return eventWidget(
                          // other parameters...
                          event: event,
                          buttonFunctionality: showEvent,
                        );
                      }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavbar(
            currentIndex: 1,
            navigatorContext: context,
          )),
    );
  }

  void _resetOtherCategories(String selectedCategory) {
    for (var key in categoryState.keys) {
      if (key != selectedCategory) {
        categoryState[key]!['selected'] = false;
      }
    }
  }

  void showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            // Set a background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          // Set your desired height
          child: Filter(), // Replace with your FilterPage widget
        );
      },
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
          ), // Replace with your FilterPage widget
        );
      },
    );
  }

  void NavigateToProfilePage() {
    Navigator.pushNamed(context, '/Profile');
  }
}
