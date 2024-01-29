import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/databases/DBHelper.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/setting.dart';
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

  bool isLoading = false;

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
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                        strokeWidth: 2,
                      )
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          // Handle logout
                          await DBHelper.deleteDatabase();
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
