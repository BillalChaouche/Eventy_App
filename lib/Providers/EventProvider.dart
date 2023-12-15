import 'package:eventy/databases/DBevent.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventProvider extends ChangeNotifier {
  List<EventEntity> events = [];
  bool noData = false;
  Future<void> getEvents() async {
    try {
      await Future.delayed(Duration(seconds: 4));
      List<Map<String, dynamic>> maps = await DBEvent.getAllEvents();
      events = convertToEventsList(maps);
      if (events.isEmpty) {
        noData = true;
      } else {
        noData = false;
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getEventsByCategory(String category) async {
    try {
      List<Map<String, dynamic>> maps =
          await DBEvent.getAllEventsByCategory(category);
      events = convertToEventsList(maps);
      if (events.isEmpty) {
        noData = true;
      } else {
        noData = false;
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getEventsByName(String name) async {
    try {
      List<Map<String, dynamic>> maps =
          await DBEvent.getAllEventsByKeyword(name);
      events = convertToEventsList(maps);
      if (events.isEmpty) {
        noData = true;
      } else {
        noData = false;
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getEventsByFilter(String date, String location) async {
    try {
      List<Map<String, dynamic>> maps =
          await DBEvent.getAllEventsByFilter(date, location);
      events = convertToEventsList(maps);
      if (events.isEmpty) {
        noData = true;
      } else {
        noData = false;
      }
      notifyListeners();
    } catch (e) {}
  }

  /*Future<void> getEventsByFilter(String location, String time) async {
    try {
      List<Map<String, dynamic>> maps =
          await DBEvent.getAllEventsByFilter(location, time);
      events = convertToEventsList(maps);
      print(events);
      notifyListeners();
    } catch (e) {}
  }
  */
  Future<void> emptyEvents() async {
    events = [];
    notifyListeners();
  }

  List<EventEntity> convertToEventsList(List<Map<String, dynamic>> maps) {
    return maps.map((map) {
      return EventEntity(
          map['id'] as int,
          map['title'] as String,
          map['location'] as String,
          map['date'] as String,
          map['time'] as String,
          map['imagePath'] as String,
          map['attendees'] as int, // Set a default value if null
          map['description'] as String,
          map['saved'] as int,
          map['booked'] as int,
          map['accepted'] as int,
          map['organizer'] as String,
          [map['category'] as String] // Convert category to a list
          );
    }).toList();
  }
  /*
  List<EventEntity> events = [
    EventEntity(
        1,
        'UX/UI Tutorial Events',
        'Ensia School',
        '2023/01/21',
        '4:50 PM',
        'assets/images/UIUXEvent.jpg',
        200,
        "Is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
        true,
        false,
        false,
        'Ashraf', [
      'Education',
      'Learning',
      'IT'
    ]), // Example events; you may have a list of actual events here
    EventEntity(
        2,
        'Gaming Tutorial Events',
        'Algiers',
        '2023/01/24',
        '10:00 AM',
        'assets/images/gamingEvent.jpg',
        300,
        '',
        true,
        false,
        false,
        'Ashraf', [
      'Art',
      'IT'
    ]), // Example events; you may have a list of actual events here
    EventEntity(
        3,
        'Quantum physics Events',
        'Algiers',
        '2023/01/24',
        ' 10:00 AM',
        'assets/images/quantumEvent.jpg',
        800,
        '',
        true,
        true,
        false,
        'Ashraf', [
      'Art',
      'Education'
    ]), // Example events; you may have a list of actual events here // Example events; you may have a list of actual events here
    EventEntity(
        4,
        'Quantum physics Events',
        'Algiers',
        '2023/01/24',
        ' 10:00 AM',
        'assets/images/quantumEvent.jpg',
        800,
        '',
        false,
        false,
        true,
        'Ashraf', [
      'Art',
      'Education'
    ]), // Example events; you may have a list of actual events here // Example events; you may have a list of actual events here

    // Add more events as needed
  ];
  */

  Future<void> toggleEventSavedState(int id) async {
    await DBEvent.updateSpecific(id, 'saved');
    await DBEvent.uploadModification();
    EventEntity foundEvent = events.firstWhere((event) => event.id == id);
    foundEvent.toggleSaved();
    notifyListeners();
  }

  Future<void> toggleEventBookedState(int id) async {
    await DBEvent.updateSpecific(id, 'booked');
    await DBEvent.uploadModification();
    EventEntity foundEvent = events.firstWhere((event) => event.id == id);
    foundEvent.toggleBooked();
    notifyListeners();
  }
}
