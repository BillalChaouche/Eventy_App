import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ionicons/ionicons.dart';

class ProfileImageInput extends StatefulWidget {
  final String? DEF_IMG_PATH;
  final Function(String?)?
      onImageSelected; // Callback to pass the selected image path

  ProfileImageInput({this.DEF_IMG_PATH, this.onImageSelected});

  @override
  _ProfileImageInputState createState() => _ProfileImageInputState();
}

class _ProfileImageInputState extends State<ProfileImageInput> {
  String? userUploadedImagePath;
  String fileName = '';

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        userUploadedImagePath = result.files.single.path;
      });

      // Pass the selected image path to the parent widget using the callback
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(userUploadedImagePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF662549),
          ),
          borderRadius: BorderRadius.circular(200.0),
          image: userUploadedImagePath != null
              ? DecorationImage(
                  image: FileImage(File(userUploadedImagePath!)),
                  fit: BoxFit.cover,
                )
              : widget.DEF_IMG_PATH != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(widget.DEF_IMG_PATH!),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (userUploadedImagePath != null || widget.DEF_IMG_PATH != null)
              Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.person,
                  size: 80,
                  color: userUploadedImagePath != null ||
                          widget.DEF_IMG_PATH != null
                      ? const Color.fromARGB(0, 255, 255, 255)
                      : Color(0xFFBDBDBD),
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
