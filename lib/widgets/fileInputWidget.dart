
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileInputWidget extends StatefulWidget {
  final String? DEF_IMG_PATH;

  FileInputWidget({this.DEF_IMG_PATH});

  @override
  _FileInputWidgetState createState() => _FileInputWidgetState();
}

class _FileInputWidgetState extends State<FileInputWidget> {
  String? userUploadedImagePath;
  String fileName = '';

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        userUploadedImagePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFBDBDBD),
          ),
          borderRadius: BorderRadius.circular(8.0),
          image: userUploadedImagePath != null
              ? DecorationImage(
                  image: FileImage(File(userUploadedImagePath!)),
                  fit: BoxFit.cover,
                )
              : widget.DEF_IMG_PATH != null
                  ? DecorationImage(
                      image: AssetImage(widget.DEF_IMG_PATH!),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (userUploadedImagePath != null || widget.DEF_IMG_PATH != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 40,
                  color: userUploadedImagePath != null ||
                          widget.DEF_IMG_PATH != null
                      ? Colors.white
                      : Color(0xFFBDBDBD),
                ),
                SizedBox(height: 8),
                Text(
                  fileName.isEmpty ? 'Choose file' : fileName,
                  style: TextStyle(
                    color: userUploadedImagePath != null ||
                            widget.DEF_IMG_PATH != null
                        ? Colors.white
                        : Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
