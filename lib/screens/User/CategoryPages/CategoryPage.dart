import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/Providers/EventProvider.dart';

import 'package:eventy/screens/User/FilterPages/Filter.dart';
import 'package:eventy/screens/User/EventPages/Event.dart';

import 'package:eventy/widgets/eventWidget.dart';

import 'package:eventy/widgets/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  _CategoryPage createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> {
  // categories information simple
  Map<String, Map<String, dynamic>> categoryState = {
    'My feed': {'selected': true, 'icon': Icons.home},
    'Education': {'selected': false, 'icon': Icons.school},
    'Music': {'selected': false, 'icon': Ionicons.musical_notes},
    'Sport': {'selected': false, 'icon': Ionicons.football},
  };

  // events inforamtion simple

  // Fetching events from the provider
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      home: Scaffold(
        extendBody: true,
        appBar: PageAppBar(
            title: widget.categoryName, context: context, backButton: true),
        // here all screen scroll
        body: SingleChildScrollView(
          child: Padding(
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
                const SizedBox(height: 30),

                searchBarWidget(
                    hintText: "Search for events",
                    filter: true,
                    buttonFunctionality: showFilter,
                    context: context),

                const SizedBox(height: 30),

                // and the scroll become only here on events
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Provider.of<EventProvider>(context).events.length,
                  itemBuilder: (context, index) {
                    var event =
                        Provider.of<EventProvider>(context).events[index];
                    if (event.categories.contains(widget.categoryName)) {
                      return eventWidget(
                          // other parameters...
                          event: event,
                          buttonFunctionality: showEvent,
                          save: true);
                    }
                    // If the condition is not met, return an empty Container or SizedBox
                    // You can replace Container/SizedBox with any other widget that fits your layout
                    return SizedBox(); // or SizedBox(height: 0);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            // Set a background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          // Set your desired height
          child: Filter(), // Replace with your FilterPage widget
        );
      },
    );
  }

  void showEvent(int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: Event(
            eventId: id,
          ), // Replace with your FilterPage widget
        );
      },
    );
  }

  void NavigateToProfilePage() {
    Navigator.pushNamed(context, '/Profile');
  }
}
