import 'dart:convert';
import 'package:eventy/Static/AppConfig.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:eventy/models/SharedData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

Future<bool> my_messaging_init_app() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  init_firebase_messaging();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  return true;
}

Future<bool> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Running Background Message>>>");
  print(
      "Recevied Background message ${message.messageId} -  ${message.toMap().toString()}");
  return true;
}

Future<bool> init_firebase_messaging() async {
  await firebase_requestPermission();

  await firebase_initialize_local_plugin();
  FirebaseMessaging.onMessageOpenedApp.listen(_handleFirebaseMessage);

  await FirebaseMessaging.instance.getToken().then((token) async {
    if (token != null) {
      await SharedData.instance.saveUserToken(token);
      sendTokenToBackend(token);
      print("Firebase  token is :  $token");
    }
    //Send it to Backend
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatTitle: true,
    );
    AndroidNotificationDetails AndroidplatformChannelSpecifics =
        AndroidNotificationDetails(
      'Red Green Screen App',
      'ENSIA APP',
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: AndroidplatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body.toString(), platformChannelSpecifics,
          payload: jsonEncode(message.toMap()));
    } on Exception catch (e, stack) {
      print('Exception $e $stack');
    }
  });

  return true;
}

// Function to send the token to the backend
Future<void> sendTokenToBackend(String token) async {
  String url = '${AppConfig.backendBaseUrl}token_management.php';
  try {
    // Get the user email
    List<Map<String, dynamic>> userData = await DBUserOrganizer.getUser();
    String currentUserEmail = userData[0]['email'];

    String? userType = await SharedData.instance.getSharedVariable();

    // Make an HTTP POST request to your backend API
    final response = await http.post(
      Uri.parse(url),
      body: {
        'token': token,
        'userEmail': currentUserEmail,
        'userType': userType
      },
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      print('Token sent to the backend successfully');
    } else {
      print(
          'Failed to send token to the backend. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending token to the backend: $e');
  }
}

//This is TODO : when opening the notification
Future<bool> _handleFirebaseMessage(RemoteMessage message) async {
  print("\n\n\n#####Calling FireMessage Opening Handler...\n\n\n");
  Map<String, dynamic> data = Map.of(message.data);

  //TODO
  return true;
}

Future<bool> firebase_requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User garnted permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("User garnted provisional permission");
  } else {
    print("User declined or has not accepted permission");
  }
  return true;
}

firebase_initialize_local_plugin() {
  var androidInitialize =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: androidInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
    try {
      if (notificationResponse.payload != null &&
          notificationResponse.payload!.isNotEmpty) {
        Map<String, dynamic> payload_data =
            jsonDecode(notificationResponse.payload!);
        Map<String, dynamic> data = payload_data['data'];
        if (data!['screen'] == 'red') {}
        if (data!['screen'] == 'green') {}
      }
    } on Exception catch (e, stack) {
      print('Exception $e $stack');
    }
  });
}
