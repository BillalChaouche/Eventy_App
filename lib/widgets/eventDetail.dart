import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Widget eventDetail({
  required String firstTitle,
  required String secondTitle,
  required String need,
}) {
  Widget iconOrImage() {
    if (need == 'location') {
      return const Icon(
        Ionicons.location,
        size: 22,
        color: Color.fromARGB(255, 102, 37, 73),
      );
    } else if (need == 'image') {
      return Image.asset(
        'assets/images/profile.jpg',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (need == 'date') {
      return const Icon(
        Ionicons.calendar,
        size: 22,
        color: Color.fromARGB(255, 102, 37, 73),
      );
    }
    return Container(); // Return an empty container for other cases or default
  }

  return Container(
    height: 50,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 234, 220, 220),
          ),
          child: Center(child: iconOrImage()),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              firstTitle,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              secondTitle,
              style:
                  const TextStyle(color: Color.fromARGB(95, 0, 0, 0), fontSize: 12),
            ),
          ],
        )
      ],
    ),
  );
}
