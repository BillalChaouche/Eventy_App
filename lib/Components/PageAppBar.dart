import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;
  final bool backButton;

  const PageAppBar(
      {Key? key,
      required this.title,
      required this.context,
      required this.backButton})
      : super(key: key);
  @override
  Widget build(context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: backButton
          ? IconButton(
              icon: Icon(Ionicons.chevron_back_outline),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
