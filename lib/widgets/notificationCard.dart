import 'package:flutter/material.dart';

Widget notificationCard({
  required String title,
  required String des,
  required String date,
  required String time,
  required String imgPath,
  required bool urgent,
}) {
  return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: double.infinity,
      height: 80,
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
            child: Image.asset(
              imgPath,
              width: 80,
              height: 80,
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
                        title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: (urgent) ? Colors.red : Colors.blue),
                        softWrap: true,
                      ),
                      Text(
                        des,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ))),
          const SizedBox(
            width: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: (urgent)
                            ? Colors.red
                            : Colors
                                .blue, // Change color or add your content here
                      ))
                ]),
          )
        ],
      ));
}
