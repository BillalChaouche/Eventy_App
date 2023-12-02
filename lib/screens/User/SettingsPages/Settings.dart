import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/models/setting.dart';
import 'package:eventy/widgets/avatar.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:eventy/widgets/settingcart.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
            ],
          ),
        ),
      ),
    );
  }
}
