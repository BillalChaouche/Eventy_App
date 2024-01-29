import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/screens/Organizer/EventPages/createEvent2.dart';
import 'package:eventy/widgets/fileInputWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/widgets/inputWidgets.dart';
import 'package:eventy/widgets/appBar.dart';

typedef FunctionallityButton = void Function(String? value);

class CreateEvent1 extends StatefulWidget {
  const CreateEvent1({super.key});

  @override
  _CreateEvent1State createState() => _CreateEvent1State();
}

class _CreateEvent1State extends State<CreateEvent1> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  String? _selectedEventType = '';
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  String imgURL = "";
  late Uint8List uint8List;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = DBCategory.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: "Create Event"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CircleStepRow(step: 1),
              const SizedBox(height: 35),
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
                    fullInput("Event name:", "Enter the event name",
                        _eventNameController),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Event description:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    descInput(_eventDescriptionController),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Attached photo:',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FileInputWidget(
                          onImageSelected: handleImageSelected,
                        )
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
                                buttonText: "Next",
                                onClickListener: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Capture values from input fields
                                  String imageURL =
                                      await uploadImageToFirebaseStorage(
                                          uint8List);
                                  String eventName = _eventNameController.text;
                                  String? eventType = _selectedEventType;
                                  String eventDescription =
                                      _eventDescriptionController.text;

                                  // Create the map
                                  Map<String, dynamic> createdEvent = {
                                    'eventName': eventName,
                                    'eventType': eventType,
                                    'eventDescription': eventDescription,
                                    'imagePath': imageURL,
                                  };

                                  print(createdEvent);
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CreateEvent2(
                                        createdEvent: createdEvent),
                                  ));
                                },
                              ),
                      ],
                    )
                  ],
                ),
              )
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
                  _selectedEventType = value;
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

  TextField customInput(TextEditingController inputController) {
    return TextField(
      controller: inputController,
      decoration: const InputDecoration(
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
