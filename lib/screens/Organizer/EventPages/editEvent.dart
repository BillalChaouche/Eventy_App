import 'dart:io';
import 'dart:typed_data';

import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/databases/DBeventOrg.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:flutter/material.dart';
import 'package:eventy/widgets/fileInputWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/inputWidgets.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;

class EditEvent extends StatefulWidget {
  final int eventId;

  const EditEvent({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late TextEditingController eventTitleController;
  late TextEditingController eventDescController;
  String? selectedEventType = '';
  late EventEntity event;
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  String imgURL = "";
  Uint8List uint8List = Uint8List.fromList([0]);
  bool isLoading = false;
  bool imageModified = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = DBCategory.getAllCategories();

    // Initialize controllers with existing data
    event =
        HomeOrganizer.events.firstWhere((event) => event.id == widget.eventId);

    eventTitleController = TextEditingController(text: event.title);
    eventDescController = TextEditingController(text: event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text(
                  "Event details:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF4F4F4F),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 24, 30, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fullInput(
                      "Event name:",
                      "Enter the event name",
                      eventTitleController,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Event type:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No categories available');
                        } else {
                          return customDropdownInput(snapshot);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Event description:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    descInput(eventDescController),
                    const SizedBox(height: 30),
                    const Text(
                      'Attached photo:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FileInputWidget(
                            DEF_IMG_PATH: event.imgPath,
                            onImageSelected: handleImageSelected),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF662549)),
                                strokeWidth: 2,
                              )
                            : PersonalizedButtonWidget(
                                context: context,
                                buttonText: "Save",
                                onClickListener: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Extract values from controllers
                                  String eventName = eventTitleController.text;
                                  String eventDescription =
                                      eventDescController.text;

                                  // Update the record in the database
                                  var res = false;
                                  if (imageModified == false) {
                                    res = await DBEventOrg.updateRecord(
                                        widget.eventId, {
                                      'title': eventName,
                                      'description': eventDescription,
                                      'category': selectedEventType,
                                      'flag': 1
                                    });
                                  } else {
                                    String imageURL =
                                        await uploadImageToFirebaseStorage(
                                            uint8List);

                                    res = await DBEventOrg.updateRecord(
                                        widget.eventId, {
                                      'title': eventName,
                                      'description': eventDescription,
                                      'category': selectedEventType,
                                      'imagePath': imageURL,
                                      'flag': 1
                                    });
                                  }
                                  await DBEventOrg.uploadModification();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (res) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Event updated successfully'),
                                      ),
                                    );
                                    //Navigator.of(context)
                                    //.popUntil((route) => route.isFirst);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDropdownInput(snapshot) {
    List<Map<String, dynamic>> categories = snapshot.data!.skip(1).toList();
    List<DropdownMenuItem<String>> dropdownItems =
        categories.map<DropdownMenuItem<String>>((category) {
      return DropdownMenuItem<String>(
        value: category['name'] as String,
        child: Text(category['name'] as String),
      );
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField(
              items: dropdownItems,
              onChanged: (value) {
                // Handle the selected value
                print('Selected value: $value');
                setState(() {
                  selectedEventType = value;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.transparent,
              ),
              decoration: const InputDecoration(
                hintText: 'Select an option',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFBDBDBD),
          ),
        ],
      ),
    );
  }

  TextField customInput() {
    return const TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: '  Enter the event name',
        hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF662549)),
        ),
      ),
    );
  }

  TextField descInput(TextEditingController inputController) {
    return TextField(
      controller: inputController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Enter the description',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF662549)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  void handleImageSelected(String? imagePath) async {
    setState(() {
      imageModified = true;
    });
    if (imagePath != null) {
      File imageFile = File(imagePath);

      if (await imageFile.exists()) {
        List<int> imageBytes = await imageFile.readAsBytes();

        // Upload image to Firebase Storage
        uint8List = Uint8List.fromList(imageBytes);
        uint8List = await reduceImageQuality(uint8List);
      }
    }
  }

  Future<Uint8List> reduceImageQuality(List<int> imageBytes) async {
    img.Image? originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
    if (originalImage != null) {
      // Reduce the image quality by encoding it with a lower quality
      Uint8List reducedQualityBytes = Uint8List.fromList(img.encodeJpg(
          originalImage,
          quality: 50)); // Adjust the quality as needed

      return reducedQualityBytes;
    } else {
      throw Exception('Failed to decode the image');
    }
  }

  Future<String> uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    String imageName =
        'event_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('event_images')
        .child(imageName);

    firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);

    await uploadTask;
    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }
}
