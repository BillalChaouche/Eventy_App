import 'package:eventy/models/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Setting setting;
  const SettingTile({
    super.key,
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {}, // Navigation
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                setting.icon,
                color: Colors.black,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              setting.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_forward,
              color: Colors.grey.shade600,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
