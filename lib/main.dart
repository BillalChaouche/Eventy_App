import 'package:eventy/RootPage.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/screens/Organizer/ProfilePages/Profile.dart';
import 'package:eventy/screens/User/EventPages/AcceptedEvent.dart';
import 'package:eventy/screens/User/CategoryPages/CategoryPage.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';
import 'package:eventy/screens/Common/IntroPages/Splash.dart';
import 'package:eventy/screens/User/CategoryPages/Categories.dart';
import 'package:eventy/screens/User/EventPages/Events.dart';
import 'package:eventy/screens/User/FilterPages/Filter.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:eventy/screens/User/NotificationsPages/Notifications.dart';
import 'package:eventy/screens/User/ProfilePages/Profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          EventProvider(), // Create an instance of EventProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/Splash',
        routes: {
          '/': (context) => RootPage(), // Wrap Home widget with EventProvider
          '/filter': (context) => Filter(),
          '/Events': (context) => Events(),
          '/Profile': (context) => Profile(),
          '/Categories': (context) => Categories(),
          '/Notifications': (context) => Notifications(),
          '/Splash': (context) => Splash(),
          '/home': (context) => HomeOrganizer(),
          '/ProfileOrg': (context) => ProfileOrg()
        },
      ),
    );
  }
}
