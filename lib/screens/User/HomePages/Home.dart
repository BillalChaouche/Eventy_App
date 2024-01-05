import 'dart:async';
import 'dart:io';

import 'package:eventy/RootPage.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/databases/DBevent.dart';
import 'package:eventy/screens/User/CategoryPages/Categories.dart';

import 'package:eventy/screens/User/FilterPages/Filter.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';

import 'package:eventy/widgets/categoryButtonWidget.dart';
import 'package:eventy/widgets/cirlceIconWidget.dart';
import 'package:eventy/widgets/eventWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Map<String, dynamic>>> _fetchCategories;
  late Future<List<Map<String, dynamic>>> _user;
  bool showText = false; // Default text for the AppBar
  double heightAppBar = 0;
  bool _isLoading = true;
  bool _isLoadingE = true;
  late Timer _timer;
  late RefreshController _refreshController;

  final Map<String, IconData> _iconDataMapping = {
    'home': Icons.home,
    'musical_notes': Ionicons.musical_note,
    'football': Ionicons.football,
    'aperture': Ionicons.aperture,
    'school': Ionicons.school,
    'default': Ionicons.star
  };
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    showText = false;
    heightAppBar = 0;
    _fetchCategories = fetchingCategories();
    _user = fetchUserInfo();
    _startLoading();
    Provider.of<EventProvider>(context, listen: false).getEvents();
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onRefresh() async {
    try {
      _startLoading();
      bool syncResultE = await DBEvent.service_sync_events();

      if (!syncResultE) {
        _refreshController.refreshFailed();
      }
      await DBCategory.service_sync_categories();
      _user = fetchUserInfo();
      print(_user);
      _fetchCategories = fetchingCategories();
      await Provider.of<EventProvider>(context, listen: false).emptyEvents();
      await Provider.of<EventProvider>(context, listen: false).getEvents();
      _refreshController.refreshCompleted();
      setState(() {});
    } catch (e) {}
  }

  void _onLoading() async {
    try {
      _startLoading();
      bool syncResultE = await DBEvent.service_sync_events();

      if (!syncResultE) {
        _refreshController.refreshFailed();
      }
      await DBCategory.service_sync_categories();
      await Provider.of<EventProvider>(context, listen: false).emptyEvents();
      await Provider.of<EventProvider>(context, listen: false).getEvents();
      _refreshController.loadComplete();
      setState(() {});
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> fetchUserInfo() async {
    await DBUserOrganizer.service_sync_user();
    return await DBUserOrganizer.getAllUsers();
  }

  Future<List<Map<String, dynamic>>> fetchingCategories() async {
    await Future.delayed(Duration(seconds: 4));
    List<Map<String, dynamic>> categories = await DBCategory.getAllCategories();
    // Create a new list with modified 'selected' property
    List<Map<String, dynamic>> modifiedCategories = [];
    for (int i = 0; i < categories.length; i++) {
      Map<String, dynamic> category = Map.from(categories[i]);
      if (i == 0) {
        category['selected'] = true;
      } else {
        category['selected'] = false;
      }
      modifiedCategories.add(category);
    }

    return modifiedCategories;
  }

  void _startLoading() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isLoading = !_isLoading;
          _isLoadingE = !_isLoadingE;
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
    _timer.cancel();
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
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _user,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError) {
                              return Text('Error fetching user data');
                            } else {
                              List<Map<String, dynamic>> userData =
                                  snapshot.data ?? [];
                              if (userData.isNotEmpty &&
                                  userData[0]['imgPath'] != null) {
                                return profileWidget(
                                    47,
                                    47,
                                    userData[0]['imgPath'],
                                    true,
                                    NavigateToProfilePage);
                              } else {
                                return Text('No profile image found');
                              }
                            }
                          },
                        ),
                        circleIconWidget(47, 47, Ionicons.notifications_outline,
                            () {
                          Navigator.pushNamed(context, '/Notifications');
                        }),
                      ],
                    ),
                    const SizedBox(height: 30),

                    searchBarWidget(
                        hintText: "Search for events",
                        filter: true,
                        buttonFunctionality: showFilter,
                        context: context),
                    const SizedBox(height: 25),
                    leftTitleWidget('Categories', 18),
                    // I want this elements which are categoires when they reach the top the main scrool stop
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 80,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Row(children: [
                                  categroyShadow(),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  categroyShadow(),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  categroyShadow(),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  categroyShadow(),
                                ]),
                              ],
                            ),
                          );
                          // Show a loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error fetching data'); // Show an error message if data fetch fails
                        } else {
                          List<Map<String, dynamic>> categories =
                              snapshot.data ?? [];
                          // Resetting function
                          void _resetOtherCategories(String selectedCategory) {
                            setState(() {
                              for (var category in categories) {
                                final categoryName = category['name'];
                                if (categoryName != selectedCategory) {
                                  category['selected'] = false;
                                } else {
                                  category['selected'] = true;
                                }
                              }
                            });
                          }

                          return Container(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Row(children: [
                                  for (var category in categories)
                                    categoryButtonWidget(
                                      icon: _iconDataMapping[
                                              category['icon'] ?? 'default'] ??
                                          Icons
                                              .error, // Accessing the icon from the mapping
                                      text: category['name'],
                                      isSelected: category['selected'],
                                      onCategorySelected: (isSelected) {
                                        setState(() {
                                          category['selected'] = isSelected;
                                          _resetOtherCategories(
                                              category['name']);
                                          Provider.of<EventProvider>(context,
                                                  listen: false)
                                              .getEventsByCategory(
                                                  category['name']);
                                        });
                                      },
                                    ),
                                ]),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    leftTitleWidget('Events', 18),
                    const SizedBox(height: 10),

                    // and the scroll become only here on events

                    Consumer<EventProvider>(
                        builder: (context, eventProvider, _) {
                      if (eventProvider.events.isEmpty &&
                          !eventProvider.noData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return eventShadow();
                          },
                        ); // Show a loader if events are being fetched
                      } else if (eventProvider.events.isEmpty &&
                          eventProvider.noData) {
                        return Container(
                            width: double.infinity,
                            height: 300,
                            child: Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 102, 37, 73),
                                    fontSize: 15),
                              ),
                            ));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: eventProvider.events.length,
                          itemBuilder: (context, index) {
                            var event = eventProvider.events[index];
                            return eventWidget(
                              // other parameters...
                              event: event,
                              buttonFunctionality: showEvent,
                              save: true,
                            );
                          },
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          )),
    );
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

  Widget categroyShadow() {
    return AnimatedContainer(
      height: 50,
      width: 90,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
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
          colors: _isLoadingE
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
}
