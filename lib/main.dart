import 'package:cron/cron.dart';
import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/RootPage.dart';
import 'package:eventy/Providers/EventProvider.dart';

import 'package:eventy/databases/DBevent.dart';
import 'package:eventy/databases/DBeventOrg.dart';
import 'package:eventy/firebase.dart';

import 'package:eventy/screens/Common/RegistrationPages/login.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent1.dart';
import 'package:eventy/screens/Organizer/ProfilePages/Profile.dart';
import 'package:eventy/screens/User/EventPages/AcceptedEvent.dart';
import 'package:eventy/screens/User/CategoryPages/CategoryPage.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';
import 'package:eventy/screens/Common/IntroPages/Splash.dart';
import 'package:eventy/screens/User/CategoryPages/Categories.dart';
import 'package:eventy/screens/User/EventPages/Events.dart';
import 'package:eventy/screens/User/FilterPages/Filter.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:eventy/screens/User/HomePages/Home.dart';
import 'package:eventy/screens/User/NotificationsPages/Notifications.dart';
import 'package:eventy/screens/User/ProfilePages/Profile.dart';
import 'package:eventy/screens/User/ProfilePages/setupProfile.dart';
import 'package:eventy/screens/User/SettingsPages/Settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DBCategory.service_sync_categories();
  //DBEvent.service_sync_events();
  final cron = Cron();
  cron.schedule(Schedule.parse('*/5 * * * *'), () async {
    DBCategory.service_sync_categories();
    DBEvent.service_sync_events();
    DBEventOrg.service_sync_events();
  });

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
          '/home': (context) => Home(),
          '/homeOrg': (context) => HomeOrganizer(),
          '/login': (context) => Login(),

          '/Settings': (context) => SettingsScreen(),

          '/ProfileOrg': (context) => ProfileOrg(),
          '/SetupProfile': (context) => SetupProfile(),
        },
      ),
    );
  }
}
