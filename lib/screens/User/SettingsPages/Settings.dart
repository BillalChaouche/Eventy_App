import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/databases/DBHelper.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/models/setting.dart';
import 'package:eventy/widgets/avatar.dart';
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
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _user,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('Error fetching user data');
                  } else {
                    List<Map<String, dynamic>> userData = snapshot.data ?? [];
                    if (userData.isNotEmpty && userData[0]['imgPath'] != null) {
                      return profileWidget(
                          100, 100, userData[0]['imgPath'], true, () {});
                    } else {
                      return Text('No profile image found');
                    }
                  }
                },
              ),
              SizedBox(
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    String? currentProfile =
                        await SharedData.instance.getSharedVariable();
                    if (currentProfile == 'User') {
                      List userData = await DBUserOrganizer.getUser();
                      //unsubscribe from events (topics)
                      List<String>? topics =
                          await endpoint_getUserTopics(userData[0]['email']);

                      print(topics);
                      if (topics != null) {
                        unsubscribeUserToHisTopics(topics);
                        print("User UNsubscribed succefully from his topics");
                      }
                    }

                    // Handle logout
                    DBHelper.deleteDatabase();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.power,
                        color: Colors.red,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> unsubscribeUserToHisTopics(List<String> topics) async {
    for (String topic in topics) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }
}
