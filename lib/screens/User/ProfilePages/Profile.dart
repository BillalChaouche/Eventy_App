import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  Future<List<Map<String, dynamic>>> fetchUserInfo() async {
    await DBUserOrganizer.service_sync_user();
    return await DBUserOrganizer.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    int bookedEvents =
        Provider.of<EventProvider>(context, listen: false).bookedEvent();
    int acceptedEvents =
        Provider.of<EventProvider>(context, listen: false).bookedEvent();
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to resolve
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // If an error occurs
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error.toString()}')),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // If no data is available
            return Scaffold(
              body: Center(child: Text('No data available')),
            );
          } else {
            // If data is available, build the profile UI
            Map<String, dynamic> userData = snapshot.data!.first;

            return Scaffold(
              appBar: PageAppBar(
                  title: 'Profile', context: context, backButton: true),
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          profileWidget(
                              100, 100, userData['imgPath'], true, () {}),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Container(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 190,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Adjust the radius as needed
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(6, 0, 0, 0)
                                              .withOpacity(0.05),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes the shadow position
                                        ),
                                      ]),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 5,
                                            width: (bookedEvents > 0)
                                                ? 200 *
                                                    (acceptedEvents /
                                                        bookedEvents)
                                                : 0,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 122, 122),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    const Color.fromARGB(
                                                        255, 102, 37, 73),
                                                    const Color.fromARGB(
                                                        255, 174, 68, 94),
                                                  ],
                                                  stops: [0.1, 0.9],
                                                )))
                                      ]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 218, 218,
                                            218), // Change the color as needed
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Adjust the spacing between the circle and text
                                    Text(
                                      'Total Booked:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            15, // Adjust font size as needed
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Adjust the spacing between the texts
                                    Text(
                                      bookedEvents.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Color.fromARGB(163, 0, 0,
                                              0) // Adjust font size as needed
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color.fromARGB(
                                            255,
                                            102,
                                            37,
                                            73), // Change the color as needed
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Adjust the spacing between the circle and text
                                    Text(
                                      'Total Accpeted:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            15, // Adjust font size as needed
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Adjust the spacing between the texts
                                    Text(
                                      acceptedEvents.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Color.fromARGB(163, 0, 0,
                                              0) // Adjust font size as needed
                                          ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    profileInfoCard(
                        title: 'Name', info: userData['name'], last: false),
                    profileInfoCard(title: 'Age', info: '19', last: false),
                    profileInfoCard(
                        title: 'Location',
                        info: userData['location'],
                        last: false),
                    profileInfoCard(
                        title: 'Phone Number',
                        info: userData['phone_number'],
                        last: false),
                    profileInfoCard(
                        title: 'Role', info: userData['role'], last: true),
                  ],
                ),
              ),
              /*
              floatingActionButton: flaotingButtonWidget(
                  title: '  Edit  ', buttonFunctionality: () {}),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
                  */
            );
          }
        });
  }
}

Widget profileInfoCard({
  required String title,
  required String info,
  required bool last,
}) {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      border: Border(
          top: BorderSide(
            color:
                Color.fromARGB(199, 245, 228, 228), // Choose your border color
            width: 2.0, // Adjust the width as needed
          ),
          bottom: (last)
              ? BorderSide(
                  color: Color.fromARGB(
                      199, 245, 228, 228), // Choose your border color
                  width: 2.0, // Adjust the width as needed
                )
              : BorderSide(color: Color.fromARGB(0, 238, 203, 203), width: 0)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 102, 37, 73)),
        ),
        Text(info,
            style: TextStyle(fontSize: 16, color: Color.fromARGB(163, 0, 0, 0)))
      ],
    ),
  );
}