import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/widgets/notificationCard.dart';
import 'package:flutter/material.dart';

class NotificationsOrganizerPage extends StatefulWidget {
  const NotificationsOrganizerPage({Key? key}) : super(key: key);

  @override
  _NotificationsOrganizerPageState createState() =>
      _NotificationsOrganizerPageState();
}

class _NotificationsOrganizerPageState
    extends State<NotificationsOrganizerPage> {
  late Future<List<dynamic>?> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = getNotification();
  }

  Future<List<dynamic>?> getNotification() async {
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    // Use await to get the result of the future
    return await endpoint_fetch_organizer_noti(user[0]['email']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
          title: 'Notifications', context: context, backButton: true),
      body: FutureBuilder<List<dynamic>?>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
              strokeWidth: 2,
            ));
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // If no data is available, display a message
            return Center(child: Text('No notifications available.'));
          } else {
            // If data is available, build the widget with the data
            List<dynamic> notifications = snapshot.data!;
            // Replace this with your logic to display notifications
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var notification in notifications)
                      notificationCard(
                        title: notification['title'] ?? '',
                        des: notification['body'] ?? '',
                        // Include other fields from the notification data
                        date: "19/02/2024",
                        time: "11:13 AM",
                        imgPath: "assets/images/notification.png",
                        urgent: false,
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
