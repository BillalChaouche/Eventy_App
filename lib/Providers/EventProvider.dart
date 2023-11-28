import 'package:eventy/entities/EventEntity.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
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

  void toggleEventSavedState(int index) {
    events[index].toggleSaved();
    print("${index} -- ${events[index].saved}");
    notifyListeners();
  }
}
