import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/databases/DBHelper.dart';
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
              profileWidget(
                  100, 100, "assets/images/profile.jpg", false, () {}),
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
