import 'package:eventy/widgets/navBarButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex; // Define a property to hold the current index
  late BuildContext navigatorContext;

  BottomNavbar(
      {Key? key, required this.currentIndex, required this.navigatorContext})
      : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavbar> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.currentIndex; // Set the current index from the widget property
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              color: const Color.fromARGB(76, 158, 158, 158).withOpacity(0.4),
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
          children: [
            navBarButtonWiget(
                name: 'Explore',
                icon: Ionicons.compass,
                id: 1,
                selected: _currentIndex,
                context: widget.navigatorContext,
                routeName: '/'),
            navBarButtonWiget(
                name: 'Events',
                icon: Ionicons.calendar,
                id: 2,
                selected: _currentIndex,
                context: widget.navigatorContext,
                routeName: '/Events'),
            navBarButtonWiget(
                name: 'Categories',
                icon: Ionicons.apps,
                id: 3,
                selected: _currentIndex,
                context: widget.navigatorContext,
                routeName: '/Categories'),
            navBarButtonWiget(
                name: 'Settings',
                icon: Ionicons.settings,
                id: 4,
                selected: _currentIndex,
                context: widget.navigatorContext,
                routeName: '/Settings'),
          ],
        ),
      ),
    );
  }
}
