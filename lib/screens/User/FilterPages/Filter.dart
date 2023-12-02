import 'dart:ui';

import 'package:eventy/Components/pageAppBar.dart';
import 'package:eventy/Components/DropDown.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:eventy/widgets/timeButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> wilayas = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Alger",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane"
  ];
  // location and time
  String location = "Choose Wilaya";
  String time = "Any Time";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      home: Scaffold(
        extendBody: true,
        appBar: PageAppBar(
          title: 'Filter',
          context: context,
          backButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            20,
            18,
            0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                leftTitleWidget('Location', 18),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10), // Border radius
                    border: Border.all(
                        color: const Color.fromARGB(
                            255, 223, 223, 223)), // Grey border
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 53,
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8), // Border radius

                            color: const Color.fromARGB(255, 244, 220,
                                220), // Background color of the container
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10), // Border radius

                                color: const Color.fromARGB(255, 255, 255,
                                    255), // Background color of the container
                              ),
                              child: const Center(
                                child: Icon(
                                  Ionicons
                                      .location_outline, // Replace with your desired icon
                                  size: 20, // Icon size
                                  color: Color.fromARGB(
                                      255, 102, 37, 73), // Icon color
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(width: 20),
                      Dropdown(
                        options: wilayas,
                        selectedOption: location,
                        onChanged: updateSelectedOption,
                        indexing: true,
                        height: 300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                leftTitleWidget('Time', 18),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    timeButtonWidget(
                        title: "Any Time",
                        selected: time,
                        onTimeSelected: updateSelectedTime),
                    timeButtonWidget(
                        title: "Today",
                        selected: time,
                        onTimeSelected: updateSelectedTime),
                    timeButtonWidget(
                        title: "Tomorrow",
                        selected: time,
                        onTimeSelected: updateSelectedTime),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeButtonWidget(
                        title: "This Week",
                        selected: time,
                        onTimeSelected: updateSelectedTime),
                    const SizedBox(width: 10),
                    timeButtonWidget(
                        title: "This Month",
                        selected: time,
                        onTimeSelected: updateSelectedTime),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Add your action here
                    resetFilter();
                  },
                  child: Icon(Ionicons.refresh_outline),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    elevation: 0, // Shadow depth
                    primary: const Color.fromARGB(
                        255, 244, 220, 220), // Change FAB color
                  ),
                ),
              ]),
        ),
        floatingActionButton: flaotingButtonWidget(
            title: 'APPLY', buttonFunctionality: startFilter),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // callback implementation
  void updateSelectedOption(String newValue) {
    setState(() {
      location = newValue;
    });
  }

  void updateSelectedTime(String newValue) {
    setState(() {
      time = newValue;
    });
  }

  // functions
  void resetFilter() {
    setState(() {
      time = "Any Time";
      location = "Choose Wilaya";
    });
  }

  void startFilter() {
    // start the operation
    Navigator.pop(context);
  }
}
