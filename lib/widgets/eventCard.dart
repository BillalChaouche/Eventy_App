import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

typedef ButtonFunctionality = void Function(int id);
Widget eventCard({
  required EventEntity event,
  required bool choiceAccpeted,
  required ButtonFunctionality buttonFunctionality,
}) {
  return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(79, 199, 199, 199).withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), // Radius for top-left corner
              bottomLeft: Radius.circular(15), // Radius for bottom-left corner
            ),
            child: Image.network(
              AppConfig.backendBaseUrlImg + event.imgPath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${event.date} -- ${event.time}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 102, 37, 73)),
                      ),
                      Text(
                        event.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Ionicons.location,
                            color: Color.fromARGB(255, 102, 37, 73),
                            size: 12,
                          ),
                          const SizedBox(
                              width: 5), // Add some space between icon and text

                          Text(
                            event.location,
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(80, 0, 0, 0)),
                          ),
                        ],
                      )
                    ],
                  ))),
          const SizedBox(
            width: 12,
          ),
          Container(
            width: 37,
            height: 37,
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180.0),
              color: (choiceAccpeted)
                  ? Colors.white
                  : const Color.fromARGB(255, 174, 68, 94),
              border: Border.all(
                color: const Color.fromARGB(
                    255, 174, 68, 94), // Set the border color
                width: 1.0, // Set the border width
              ),
              // Background color of the container
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  buttonFunctionality(event.id);
                },
                icon: (choiceAccpeted)
                    ? const Icon(Ionicons.ticket_outline)
                    : const Icon(Ionicons.arrow_forward_outline),
                color: (choiceAccpeted)
                    ? const Color.fromARGB(255, 174, 68, 94)
                    : Colors.white,
                iconSize: 14,
              ),
            ),
          ),
        ],
      ));
}
