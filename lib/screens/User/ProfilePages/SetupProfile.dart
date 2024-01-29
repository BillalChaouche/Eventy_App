import 'dart:io';

import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/profileImageInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

typedef FunctionallityButton = void Function(String? value);

class SetupProfile extends StatefulWidget {
  SetupProfile({Key? key}) : super(key: key);

  @override
  _SetupProfileState createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedRoleType = '';
  String imgURL = "";
  late Uint8List uint8List;
  bool isLoading = false;

  Future<void> _selectDate(
      BuildContext context, TextEditingController? controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      controller?.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        backButton: false,
        context: context,
        title: 'Profile Setup',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileImageInput(
                    onImageSelected: handleImageSelected,
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fullInput("First name:", "Enter your First name",
                      _firstNameController, 150, true),
                  fullInput("Second name:", "Enter your Second name",
                      _secondNameController, 150, true),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              fullInput("Location:", "Enter your location", _locationController,
                  300, true),
              const SizedBox(
                height: 35,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ICONFullInput(
                  "Birthday",
                  const Icon(Icons.calendar_today),
                  _birthDateController,
                  () => _selectDate(context, _birthDateController),
                ),
                fullInput("Phone number:", "  0-  --  --  --  --",
                    _phoneNumberController, 150, false),
              ]),
              const SizedBox(
                height: 35,
              ),
              customDropdownInput((value) {
                _selectedRoleType = value;
              }),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                          strokeWidth: 2,
                        )
                      : PersonalizedButtonWidget(
                          context: context,
                          buttonText: "Done",
                          onClickListener: () async {
                            setState(() {
                              isLoading = true;
                            });
                            // get the user ID

                            String firstName = _firstNameController.text;
                            String secondName = _secondNameController.text;
                            String location = _locationController.text;
                            String birthDate = _birthDateController.text;
                            String phoneNumber = _phoneNumberController.text;
                            String? role = _selectedRoleType;
                            if (firstName.isEmpty ||
                                secondName.isEmpty ||
                                location.isEmpty ||
                                birthDate.isEmpty ||
                                phoneNumber.isEmpty ||
                                role == null ||
                                role.isEmpty ||
                                uint8List.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please fill all the information'),
                                  backgroundColor:
                                      Color.fromARGB(255, 246, 110, 73),
                                ),
                              );
                            } else {
                              List<Map<String, dynamic>> user =
                                  await DBUserOrganizer.getUser();

                              await DBUserOrganizer.deleteUser(user[0]['id']);
                              print(user[0]);
                              await DBUserOrganizer.insertUser({
                                'name': "$firstName $secondName",
                                'role': role,
                                'birth_date': birthDate,
                                'location': location,
                                'phone_number': phoneNumber,
                                'email': user[0]['email'],
                                'verified': user[0]['verified'],
                                'flag': 1,
                              });

                              String imageURL =
                                  await uploadImageToFirebaseStorage(uint8List);
                              print(imageURL);

                              var res =
                                  await DBUserOrganizer.uploadModification(
                                      imageURL);
                              setState(() {
                                isLoading = true;
                              });
                              if (res) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('profile saved successfully'),
                                    backgroundColor:
                                        Color.fromARGB(255, 54, 244, 63),
                                  ),
                                );

                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('something went wrong '),
                                    backgroundColor:
                                        Color.fromARGB(255, 246, 110, 73),
                                  ),
                                );
                              }
                            }
                          }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fullInput(String title, String hint,
      TextEditingController inputController, double width, bool text) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF363636),
              fontSize: 14,
            ),
          ),
          (text)
              ? TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF662549)),
                    ),
                  ),
                )
              : TextField(
                  controller: inputController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF662549)),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget ICONFullInput(String title, Icon myIcon,
      TextEditingController controller, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF363636),
            fontSize: 14,
          ),
        ),
        customICONInput(myIcon, controller, onPressed),
      ],
    );
  }

  Widget customICONInput(
      Icon myIcon, TextEditingController controller, VoidCallback onPressed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: GestureDetector(
            onTap: onPressed,
            child: TextField(
              readOnly: true,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: 'yyyy-MM-dd',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF662549)),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: myIcon,
          iconSize: 20,
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget customDropdownInput(FunctionallityButton function) {
    List<String> items = ['Student', 'Worker', 'Teacher', 'else'];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
          ),
        ),
      ),
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are',
              style: TextStyle(
                color: Color(0xFF363636),
                fontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      function(value);
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.transparent,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Choose a role',
                      hintStyle: TextStyle(
                        fontSize: 13,
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
          ],
        ),
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
        'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(imageName);

    firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);

    await uploadTask;
    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }
}
