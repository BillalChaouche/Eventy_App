import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:eventy/Providers/EventProvider.dart';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/models/EventEntity.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:eventy/widgets/floatingButtonWidget.dart';
import 'package:eventy/widgets/profileWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class AcceptedEvent extends StatefulWidget {
  final int eventId;
  const AcceptedEvent({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<AcceptedEvent> createState() => _AcceptedEventState();
}

class _AcceptedEventState extends State<AcceptedEvent> {
  String choice = 'Info';
  @override
  void initState() {
    super.initState();
    choice = 'Info';
  }

  @override
  Widget build(BuildContext contex) {
    EventEntity event = Provider.of<EventProvider>(context)
        .events
        .firstWhere((event) => event.id == widget.eventId);
    return Consumer<EventProvider>(builder: (context, eventProvider, _) {
      return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  // Optional: Add border radius
                  image: DecorationImage(
                    image: NetworkImage(
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
                            blurButton(
                                icon: (event.saved == 1)
                                    ? Ionicons.bookmark
                                    : Ionicons.bookmark_outline,
                                width: 40,
                                height: 40,
                                iconSize: 16,
                                color: Colors.white,
                                functionallityButton: () {
                                  eventProvider
                                      .toggleEventSavedState(event.id - 1);
                                }),
                            const SizedBox(width: 10),
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
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        20,
                      ),
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(50),
                        dashPattern: const [4, 4],
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the value to change the border radius
                            color: const Color.fromARGB(255, 255, 255,
                                255), // Specify the color of the container
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(event.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 102, 37, 73),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                event.organizer,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(116, 0, 0, 0)),
                              ),
                              const SizedBox(height: 20),
                              const DottedLine(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                lineLength: double.infinity,
                                lineThickness: 1.2,
                                dashLength: 4.0,
                                dashColor: Color.fromARGB(255, 245, 206, 206),
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                              const SizedBox(height: 20),
                              (choice == 'Qr Code')
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: PrettyQrView.data(
                                            data: '214 212 331',
                                            decoration:
                                                const PrettyQrDecoration(
                                              shape: PrettyQrSmoothSymbol(
                                                color: Color.fromARGB(
                                                    255, 174, 68, 94),
                                              ),
                                              image: PrettyQrDecorationImage(
                                                image: AssetImage(
                                                    'assets/images/logo.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Date',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          116, 0, 0, 0)),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  event.date,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          116, 0, 0, 0)),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  event.time,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Place',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      116, 0, 0, 0)),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              event.location,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              if (choice == 'Info') const SizedBox(height: 20),
                              if (choice == 'Info')
                                const DottedLine(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.2,
                                  dashLength: 4.0,
                                  dashColor: Color.fromARGB(255, 245, 206, 206),
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                              if (choice == 'Info')
                                const SizedBox(
                                  height: 20,
                                ),
                              if (choice == 'Info')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    profileWidget(
                                        50,
                                        50,
                                        "assets/images/profile.jpg",
                                        false,
                                        () => {}),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    const Text(
                                      'Adam Ali -- 214 212 331',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ))),
            ]),
        bottomNavigationBar: Container(
          height: 60, // Set the height of the bottom navbar
          decoration: const BoxDecoration(
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
                title: (choice == 'Info') ? "Qr Code" : "Info",
                buttonFunctionality: () => {
                      if (choice == 'Info')
                        {
                          choice = "Qr Code",
                        }
                      else
                        {
                          choice = "Info",
                        },
                      setState(() {
                        choice;
                      })
                    }),
          ),
        ),
      ); // Add elevation (shadow));
    });
  }
}
