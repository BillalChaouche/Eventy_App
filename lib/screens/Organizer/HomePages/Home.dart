import 'dart:async';

import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/databases/DBeventOrg.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeOrganizer extends StatefulWidget {
  static late List<EventEntity> events = [];
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomeOrganizer> {
  bool _isLoading = true;
  late Timer _timer;
  late RefreshController _refreshController;
  final ScrollController _scrollController = ScrollController();
  bool showText = false; // Default text for the AppBar
  double heightAppBar = 0;
  Future<bool> getEvents() async {
    try {
      await Future.delayed(Duration(seconds: 4));
      await DBEventOrg.service_sync_events();
      List<Map<String, dynamic>> maps = await DBEventOrg.getAllEvents();
      print(maps);
      HomeOrganizer.events = convertToEventsList(maps);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<EventEntity> convertToEventsList(List<Map<String, dynamic>> maps) {
    return maps.map((map) {
      return EventEntity(
          map['id'] as int,
          map['title'] as String,
          map['location'] as String,
          map['start_date'] as String,
          map['start_time'] as String,
          map['imagePath'] as String,
          map['attendees'] as int, // Set a default value if null
          map['description'] as String,
          0,
          0,
          0,
          '',
          [map['category'] as String] // Convert category to a list
          );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    showText = false;
    heightAppBar = 0;
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onRefresh() async {
    try {
      bool syncResultE = await DBEventOrg.service_sync_events();

      if (!syncResultE) {
        _refreshController.refreshFailed();
      }
      await getEvents();
      _refreshController.refreshCompleted();
      setState(() {});
    } catch (e) {}
  }

  void _onLoading() async {
    try {
      bool syncResultE = await DBEventOrg.service_sync_events();

      if (!syncResultE) {
        _refreshController.refreshFailed();
      }
      await getEvents();
      _refreshController.loadComplete();
      setState(() {});
    } catch (e) {}
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isLoading = !_isLoading;
        });
      }
    });
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
    //_timer.cancel();
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
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: ClassicHeader(
              refreshingIcon: const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                ),
              ),
              idleIcon: const Icon(
                Icons.refresh,
                color: Color(0xFF662549),
              ),
              releaseIcon: const Icon(
                Icons.refresh,
                color: Color(0xFF662549),
              ),
              completeIcon: const Icon(
                Ionicons.checkmark_circle_outline,
                color: Color.fromARGB(255, 135, 244, 138),
              ),
              failedIcon: const Icon(Icons.error,
                  color: const Color.fromARGB(255, 239, 92, 92)),
              idleText: '',
              releaseText: '',
              refreshingText: '',
              completeText: '',
              failedText: 'Refresh failed',
              textStyle: TextStyle(
                  color: const Color.fromARGB(
                      255, 239, 92, 92)), // Change the text color here
            ),
            child: SingleChildScrollView(
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
                        profileWidget(47, 47, 'assets/images/OrgProfile.jpg',
                            true, NavigateToProfilePage),
                        circleIconWidget(47, 47, Ionicons.notifications_outline,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotificationsOrganizerPage()),
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
                    // Replace this part of your code with the corrected FutureBuilder
                    FutureBuilder<bool>(
                      future:
                          getEvents(), // Use the getEvents() function that returns a Future<bool>
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return eventShadow();
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Show error if Future fails
                        } else if (!snapshot.hasData || !snapshot.data!) {
                          return Text(
                              'No events available.'); // Show message when no events are retrieved
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: HomeOrganizer.events.length,
                            itemBuilder: (context, index) {
                              var event = HomeOrganizer.events[index];
                              return eventWidget(
                                // Other parameters...
                                event: event,
                                buttonFunctionality: showEvent,
                                save: false,
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
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

  Widget eventShadow() {
    return AnimatedContainer(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      width: double.infinity,
      height: 170,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isLoading
              ? [
                  const Color.fromARGB(255, 221, 221, 221),
                  const Color.fromARGB(255, 244, 244, 244)
                ]
              : [
                  const Color.fromARGB(255, 244, 244, 244),
                  const Color.fromARGB(255, 221, 221, 221)
                ],
        ),
      ),
    );
  }

  void NavigateToProfilePage() {
    Navigator.pushNamed(context, '/ProfileOrg');
  }
}
