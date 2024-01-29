import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/widgets/notificationCard.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsOrganizer extends StatefulWidget {
  const NotificationsOrganizer({Key? key}) : super(key: key);

  @override
  _NotificationsOrganizerState createState() => _NotificationsOrganizerState();
}

class _NotificationsOrganizerState extends State<NotificationsOrganizer> {
  late Future<List<dynamic>?> _notificationsFuture;
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = getNotification();
    _refreshController = RefreshController(initialRefresh: false);
  }

  Future<List<dynamic>?> getNotification() async {
    List<Map<String, dynamic>> user = await DBUserOrganizer.getUser();
    // Use await to get the result of the future
    return await endpoint_fetch_organizer_noti(user[0]['email']);
  }

  void _onRefresh() async {
    // Implement your refresh logic here
    await getNotification();
    _refreshController.refreshCompleted();
    setState(() {
      _notificationsFuture = getNotification();
    });
  }

  void _onLoading() async {
    // Implement your refresh logic here
    await getNotification();
    _refreshController.loadComplete();
    setState(() {
      _notificationsFuture = getNotification();
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageAppBar(
          title: 'Notifications',
          context: context,
          backButton: false,
        ),
        body: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          header: const ClassicHeader(
            refreshingIcon: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
              ),
            ),
            idleIcon: Icon(
              Icons.refresh,
              color: Color(0xFF662549),
            ),
            releaseIcon: Icon(
              Icons.refresh,
              color: Color(0xFF662549),
            ),
            completeIcon: Icon(
              Ionicons.checkmark_circle_outline,
              color: Color.fromARGB(255, 135, 244, 138),
            ),
            failedIcon:
                Icon(Icons.error, color: Color.fromARGB(255, 239, 92, 92)),
            idleText: '',
            releaseText: '',
            refreshingText: '',
            completeText: '',
            failedText: 'Refresh failed',
            textStyle: TextStyle(
                color: Color.fromARGB(
                    255, 239, 92, 92)), // Change the text color here
          ),
          child: FutureBuilder<List<dynamic>?>(
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
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 80),
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
        ));
  }
}
