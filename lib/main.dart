import 'package:cron/cron.dart';
import 'package:eventy/Providers/UserBookedProvider.dart';
import 'package:eventy/RootPage.dart';
import 'package:eventy/Providers/EventProvider.dart';

import 'package:eventy/databases/DBevent.dart';
import 'package:eventy/databases/DBeventOrg.dart';
import 'package:eventy/screens/Common/RegistrationPages/enter_code.dart';
import 'package:eventy/screens/Common/RegistrationPages/forgot_password.dart';

import 'package:eventy/screens/Common/RegistrationPages/login.dart';
import 'package:eventy/screens/Common/RegistrationPages/reset_password.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // I added this
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //DBCategory.service_sync_categories();
  //DBEvent.service_sync_events();
  final cron = Cron();
  DBCategory.service_sync_categories();
  DBEvent.service_sync_events();
  DBEventOrg.service_sync_events();
  cron.schedule(Schedule.parse('*/5 * * * *'), () async {
    DBCategory.service_sync_categories();
    DBEvent.service_sync_events();
    DBEventOrg.service_sync_events();
  });
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation
        .portraitUp, // or portraitDown, landscapeLeft, landscapeRight
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => UserBookedProvider()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/Splash',
        routes: {
          '/': (context) =>
              const RootPage(), // Wrap Home widget with EventProvider
          '/filter': (context) => const Filter(),
          '/Events': (context) => const Events(),
          '/Profile': (context) => const Profile(),
          '/Categories': (context) => const Categories(),
          '/Notifications': (context) => const Notifications(),
          '/Splash': (context) => const Splash(),
          '/home': (context) => const Home(),
          '/homeOrg': (context) => const HomeOrganizer(),
          '/login': (context) => const Login(),

          '/Settings': (context) => const SettingsScreen(),

          '/SetupProfile': (context) => SetupProfile(),
          '/forgotpassword': (context) => const ForgotPassword(),
          '/entercode': (context) => const EnterCode(),
          '/resetpassword': (context) => const ResetPassword()
        },
      ),
    );
  }
}
