import 'dart:ui';

import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/entities/EventEntity.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

typedef ButtonFunctionality = void Function(int id);

Widget eventWidget({
  required EventEntity event,
  required ButtonFunctionality buttonFunctionality,
}) {
  return Consumer<EventProvider>(
    builder: (context, eventProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage(event.imgPath),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: const Color.fromARGB(0, 244, 67, 54),
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromARGB(0, 217, 218,
                              219), // Background color of the container
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              height: 25,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              color: const Color.fromARGB(131, 255, 255, 255)
                                  .withOpacity(
                                      0.3), // Adjust the opacity for the blur effect
                              child: Center(
                                child: Text(
                                  '${event.attendcees} attendees',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      blurButton(
                        icon: event.saved
                            ? Ionicons.bookmark
                            : Ionicons.bookmark_outline,
                        width: 30,
                        height: 30,
                        iconSize: 14,
                        color: Colors.white,
                        functionallityButton: () {
                          eventProvider.toggleEventSavedState(event.id - 1);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color.fromARGB(0, 244, 67, 54),
                    // Background color of the container
                  ),
                  width: double.infinity,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: double.infinity,
                        height: 50,
                        color: const Color.fromARGB(131, 255, 255, 255)
                            .withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 2, 10, 2),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 174, 68, 94),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${event.location} -- ${event.time}',
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              199, 255, 255, 255),
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(180.0),
                                color: const Color.fromARGB(255, 174, 68, 94),
                                // Background color of the container
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    buttonFunctionality(event.id);
                                  },
                                  icon: const Icon(
                                      Ionicons.arrow_forward_outline),
                                  color: Colors.white,
                                  iconSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      );
    },
  );
}
