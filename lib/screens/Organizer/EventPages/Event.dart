import 'dart:ui';

import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:eventy/EndPoints/userBookedEndpoints.dart';
import 'package:eventy/Providers/UserBookedProvider.dart';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:eventy/screens/Organizer/EventPages/editEvent.dart';
import 'package:eventy/screens/Organizer/HomePages/Home.dart';
import 'package:eventy/widgets/LikeTableWidget.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:eventy/widgets/categoryType.dart';
import 'package:eventy/widgets/eventDetail.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/leftTitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Event extends StatefulWidget {
  final int eventId;

  const Event({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool isManagingSelected = false;
  late var data;

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Request camera permission
    var status = await Permission.camera.request();
    if (status.isGranted) {
      cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
    } else {
      // Handle the case where the user denied camera permission
      print('Camera permission denied');
    }
  }

  int scannedCode = 0;

  Future<void> scanBarcode() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        scannedCode = int.parse(barcode.rawContent);
      });
      print(barcode.rawContent);
    } catch (e) {
      setState(() {
        scannedCode = 0;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contex) {
    EventEntity event =
        HomeOrganizer.events.firstWhere((event) => event.id == widget.eventId);

    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                // Optional: Add border radius
                image: DecorationImage(
                  image: (event.imgPath[0] == 'h')
                      ? CachedNetworkImageProvider(event.imgPath)
                      : CachedNetworkImageProvider(AppConfig.backendBaseUrlImg +
                          event.imgPath), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          blurButton(
                              icon: Ionicons.chevron_back_outline,
                              width: 40,
                              height: 40,
                              iconSize: 18,
                              color: Colors.white,
                              functionallityButton: () =>
                                  {Navigator.pop(context)})
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          blurButton(
                              icon: Ionicons.share_social_outline,
                              width: 40,
                              height: 40,
                              iconSize: 17,
                              color: Colors.white,
                              functionallityButton: () => {})
                        ],
                      )
                    ],
                  ),
                  topPageViewButtons(event),
                ],
              ),
            ),
            Expanded(
                child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                overviewPage(event),
                managingPage(event),
              ],
            )),
          ]),
      bottomNavigationBar: isManagingSelected
          ? bottomScanButton(event.remote_id)
          : bottomEditButton(event.id),
    );
  }

  Widget bottomEditButton(int eventId) {
    return Container(
      height: 80, // Set the height of the bottom navbar
      decoration: BoxDecoration(
        // Set background color to white
        boxShadow: [
          BoxShadow(
            color: Colors.white, // Set shadow color to white
            blurRadius: 15, // Adjust the blur radius
            offset: Offset(0, -20), // Set shadow offset
          ),
        ],
      ),
      child: Center(
        child: flaotingButtonWidget(
            title: 'EDIT', buttonFunctionality: () => {showEDITEvent(eventId)}),
      ),
    );
  }

  Widget bottomScanButton(int eventID) {
    return Container(
      height: 80, // Set the height of the bottom navbar
      decoration: BoxDecoration(
          // Set background color to white

          ),
      child: Center(
        child: flaotingButtonWidget(
            title: 'SCAN',
            buttonFunctionality: () async {
              await initializeCamera();
              await scanBarcode();
              if (scannedCode != 0) {
                bool result = await Provider.of<UserBookedProvider>(context,
                        listen: false)
                    .userPresent(scannedCode, eventID);
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                          child: Text(
                        'user scanned successfully ',
                        textAlign: TextAlign.center,
                      )),
                      backgroundColor: Color.fromARGB(255, 134, 253, 140),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                          child: Text(
                        'Invalid code',
                        textAlign: TextAlign.center,
                      )),
                      backgroundColor: Color.fromARGB(255, 255, 88, 73),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'Please Scan again',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 88, 73),
                  ),
                );
              }
            }),
      ),
    );
  }

  void showEDITEvent(int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to control height
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 1, // Set your desired height
          child: EditEvent(
            eventId: id,
          ),
        );
      },
    );
  }

  Widget managingPage(EventEntity event) {
    return SingleChildScrollView(
        child: LikeTableWidget(
      eventId: event.remote_id,
    ));
  }

  Widget overviewPage(EventEntity event) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                leftTitleWidget("${event.title}", 25),
                SizedBox(height: 10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      categoryType(title: event.categories[0]),
                    ]),
                SizedBox(height: 30),
                eventDetail(
                    firstTitle: event.date,
                    secondTitle: event.time,
                    need: "date"),
                SizedBox(height: 15),
                eventDetail(
                    firstTitle: "${event.location}",
                    secondTitle: "Oran center ville",
                    need: "location"),
                SizedBox(height: 15),
                eventDetail(
                    firstTitle: "${event.organizer}",
                    secondTitle: "Organizer",
                    need: "Image"),
                SizedBox(height: 20),
                leftTitleWidget('About Event', 18),
                SizedBox(height: 10),
                Text(
                  "   ${event.description}",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color.fromARGB(141, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
              ])),
    );
  }

  Widget topPageViewButtons(EventEntity event) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(142, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      clipBehavior: Clip.hardEdge,
      width: MediaQuery.of(context).size.width * 0.8,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                color: isManagingSelected
                    ? const Color.fromARGB(0, 255, 255, 255)
                    : Color(0xFF662549),
              ),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Color(0xFFCE99A3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    onTap: () {
                      setState(() {
                        isManagingSelected = false;
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    },
                    child: Center(
                      child: Text(
                        "Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isManagingSelected
                              ? Color(0xFF662549)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color:
                    isManagingSelected ? Color(0xFF662549) : Colors.transparent,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Color(0xFFCE99A3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  onTap: () {
                    setState(() {
                      isManagingSelected = true;
                      Provider.of<UserBookedProvider>(context, listen: false)
                          .getUsers(event.remote_id);
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  child: Center(
                    child: Text(
                      "Managing",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isManagingSelected
                            ? Colors.white
                            : Color(0xFF662549),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
