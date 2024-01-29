import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/databases/DBHelper.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/models/setting.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/settingcart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<List<Map<String, dynamic>>> _user;
  Future<List<Map<String, dynamic>>> fetchUserInfo() async {
    await DBUserOrganizer.service_sync_user();
    return await DBUserOrganizer.getAllUsers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PageAppBar(title: "Settings", context: context, backButton: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _user,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching user data');
                  } else {
                    List<Map<String, dynamic>> userData = snapshot.data ?? [];
                    if (userData.isNotEmpty && userData[0]['imgPath'] != null) {
                      return profileWidget(
                          100, 100, userData[0]['imgPath'], true, () {});
                    } else {
                      return const Text('No profile image found');
                    }
                  }
                },
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                children: List.generate(
                  settings.length,
                  (index) => SettingTile(setting: settings[index]),
                ),
              ),
              // Logout GestureDetector
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF662549)),
                              strokeWidth: 2,
                            ),
                          );
                        },
                        barrierDismissible: false,
                      );

                      handleLogout();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.power,
                          color: Colors.red,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogout() async {
    try {
      String? currentProfile = await SharedData.instance.getSharedVariable();

      if (currentProfile == 'User') {
        List userData = await DBUserOrganizer.getUser();

        // Unsubscribe from events (topics)
        List<String>? topics =
            await endpoint_getUserTopics(userData[0]['email']);

        print(topics);

        if (topics != null) {
          unsubscribeUserToHisTopics(topics);
          print("User unsubscribed successfully from his topics");
        } else {
          print("TOPICS are NULL, no unsubscribe!");
        }
      }

      // Handle logout
      await DBHelper.deleteDatabase();
      Navigator.pop(context); // Close the loading dialog
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print("Error during logout: $error");
      // Handle error as needed
      Navigator.pop(context); // Close the loading dialog
    }
  }

  Future<void> unsubscribeUserToHisTopics(List<String> topics) async {
    for (String topic in topics) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }
}
