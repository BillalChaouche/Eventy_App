import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/databases/DBHelper.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/setting.dart';
import 'package:eventy/widgets/avatar.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/settingcart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsOrganizerScreen extends StatefulWidget {
  const SettingsOrganizerScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsOrganizerScreen> {
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
                  onTap: () {
                    // Handle logout
                    DBHelper.deleteDatabase();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
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
}
