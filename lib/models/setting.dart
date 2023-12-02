import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting {
  final String title;
  final String route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: "Account",
    route: "/",
    icon: Icons.person,
  ),
  Setting(
    title: "Notifications",
    route: "/",
    icon: Icons.notification_important,
  ),
  Setting(
    title: "Preferences",
    route: "/",
    icon: Icons.favorite,
  ),
  Setting(
    title: "Help",
    route: "/",
    icon: Icons.help,
  ),
];

