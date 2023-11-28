import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/screens/AcceptedEvent.dart';
import 'package:eventy/screens/CategoryPage.dart';
import 'package:eventy/screens/Event.dart';
import 'package:eventy/screens/Categories.dart';
import 'package:eventy/screens/Events.dart';
import 'package:eventy/screens/Filter.dart';
import 'package:eventy/screens/Home.dart';
import 'package:eventy/screens/Notifications.dart';
import 'package:eventy/screens/Profile.dart';
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
        initialRoute: '/',
        routes: {
          '/': (context) => Home(), // Wrap Home widget with EventProvider
          '/filter': (context) => Filter(),
          '/Events': (context) => Events(),
          '/Profile': (context) => Profile(),
          '/Categories': (context) => Categories(),
          '/Notifications': (context) => Notifications(),
        },
      ),
    );
  }
}
