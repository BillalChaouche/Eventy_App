import 'dart:async';

import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/databases/DBevent.dart';

import 'package:eventy/screens/User/EventPages/AcceptedEvent.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';
import 'package:eventy/widgets/eventCard.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String choice = "Booked";
  bool _isLoadingE = true;
  late Timer _timer;
  late RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choice = "Booked";
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
      await Provider.of<EventProvider>(context, listen: false).emptyEvents();
      await Provider.of<EventProvider>(context, listen: false).getEvents();
      _refreshController.loadComplete();
      setState(() {});
    } catch (e) {}
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isLoadingE = !_isLoadingE;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // Set this property to false
        home: Scaffold(
          appBar:
              PageAppBar(title: 'Events', context: context, backButton: false),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: const ClassicHeader(
              refreshingIcon: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                ),
              ),
              idleIcon: Icon(
                Icons.refresh,
                color: Color(0xFF662549),
              ),
              releaseIcon: Icon(
                Icons.refresh,
                color: Color(0xFF662549),
              ),
              completeIcon: Icon(
                Ionicons.checkmark_circle_outline,
                color: Color.fromARGB(255, 135, 244, 138),
              ),
              failedIcon: Icon(Icons.error,
                  color: Color.fromARGB(255, 239, 92, 92)),
              idleText: '',
              releaseText: '',
              refreshingText: '',
              completeText: '',
              failedText: 'Refresh failed',
              textStyle: TextStyle(
                  color: Color.fromARGB(
                      255, 239, 92, 92)), // Change the text color here
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  6,
                  18,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(79, 199, 199, 199)
                                .withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
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
                                  ? const Color.fromARGB(255, 102, 37, 73)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(
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
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 102, 37, 73),
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
                                  ? const Color.fromARGB(255, 102, 37, 73)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(
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
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 102, 37, 73),
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
                                  ? const Color.fromARGB(255, 102, 37, 73)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(
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
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 102, 37, 73),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Consumer<EventProvider>(
                        builder: (context, eventProvider, _) {
                      if (eventProvider.events.isEmpty &&
                          !eventProvider.noData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return eventCardShadow();
                          },
                        ); // Show a loader if events are being fetched
                      } else if (eventProvider.events.isEmpty &&
                          eventProvider.noData) {
                        return const SizedBox(
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
                          itemCount:
                              Provider.of<EventProvider>(context).events.length,
                          itemBuilder: (context, index) {
                            var event = Provider.of<EventProvider>(context)
                                .events[index];
                            if (choice == 'Accepted' && event.accepted == 1) {
                              return eventCard(
                                event: event,
                                choiceAccpeted: true,
                                buttonFunctionality:
                                    NavigateToAcceptedEventPage,
                              );
                            } else if (choice == 'Booked' &&
                                event.booked == 1) {
                              return eventCard(
                                event: event,
                                choiceAccpeted: false,
                                buttonFunctionality: NavigateToEventPage,
                              );
                            } else if (choice == 'Saved' && event.saved == 1) {
                              return eventCard(
                                event: event,
                                choiceAccpeted: false,
                                buttonFunctionality: NavigateToEventPage,
                              );
                            }
                            // If none of the conditions are met, return a placeholder widget or null
                            // return Placeholder(); // Example placeholder widget
                            return const SizedBox(); // Return an empty SizedBox as a placeholder
                          },
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ));
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

  Widget eventCardShadow() {
    return AnimatedContainer(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      width: double.infinity,
      height: 100,
      duration: const Duration(milliseconds: 500),
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
