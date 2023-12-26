import 'package:eventy/Static/AppConfig.dart';

import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

Future<List<Map<String, dynamic>>?> endpoint_api_get(String url) async {
  try {
    final response = await Future.any([
      http.get(Uri.parse(url)),
      Future.delayed(Duration(seconds: 15)),
    ]);

    if (response is http.Response && response.statusCode == 200) {
      List<Map<String, dynamic>> ret =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return ret;
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return null;
  }
  return null; // Return null if the endpoint doesn't respond within 15 seconds
}

Future<List<Map<String, dynamic>>?> endpoint_fetch_org_events(
    String email) async {
  print("inside the funct");
  String url = '${AppConfig.backendBaseUrl}organizer/operations_event.php';
  try {
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: jsonEncode({
        'action': 'getEvents',
        'email': email,
      }),
    );

    print("requested the funct  " + response.statusCode.toInt().toString());

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> ret =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return ret;
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return null;
  }
  return null; // Return null if the endpoint doesn't respond within 15 seconds
}

Future<bool> add_event_endpoint(List events, String email) async {
  String url = '${AppConfig.backendBaseUrl}organizer/operations_event.php';
  try {
    var request_data =
        jsonEncode({'action': 'addEvents', 'events': events, 'email': email});
    print("Going to send to add_event_endpoint >>");
    print(request_data);
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: request_data,
    );

    if (kDebugMode) {
      print("Requested the add event and the server response is :  " +
          response.body);
    }

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        // Handle the login error
        print('Event insertion error: ${responseData['error']}');
        return false;
      } else if (responseData['success'] != null) {
        // Handle the login error
        print('${responseData['success']}');
        return true;
      }
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return false;
  }
  return false; // Return null if the endpoint doesn't respond within 15 seconds
}

// Code to handle the sign up for the user
Future<bool> userSignup(Map<String, dynamic> userData) async {
  await DBUserOrganizer.insertUser({
    'name': userData['name'],
    'email': userData['email'],
    'verified': 0,
  });
  String url = '${AppConfig.backendBaseUrl}index.php';

  try {
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: jsonEncode({
        'action': 'signup',
        'name': userData['name'],
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode == 200) {
      print("user signup successfuly");
      final responseData = jsonDecode(response.body);

      if (responseData["error"] != null) {
        // Handle the signup error
        print('Signup error: ${responseData["error"]}');
        return false;
      } else {
        print('Signup successful from client');
        return true;
      }
    } else {
      // Server errors
      print('Failed to signup. Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during signup: $e');
    return true;
  }
}

//code to handle the sign up for the organizer
Future<bool> organizerSignup(Map<String, dynamic> userData) async {
  await DBUserOrganizer.insertUser({
    'name': userData['name'],
    'email': userData['email'],
    'verified': 0,
  });
  String url = '${AppConfig.backendBaseUrl}organizer/login_signup_org.php';

  try {
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: jsonEncode({
        'action': 'signup',
        'name': userData['name'],
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode == 200) {
      print("organizer signup successfuly");
      final responseData = jsonDecode(response.body);

      if (responseData["error"] != null) {
        // Handle the signup error
        print('Signup error: ${responseData["error"]}');
        return false;
      } else {
        print('Signup successful from client');
        return true;
      }
    } else {
      // Server errors
      print('Failed to signup. Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during signup: $e');
    return true;
  }
}

Future<bool> verify_email(String code) async {
  List userData = await DBUserOrganizer.getUser();
  print('sending email to  ${userData[0]['email']}');
  String url = '${AppConfig.backendBaseUrl}verifyemail.php';
  print(SharedData.instance.sharedVariable);
  var table_name;
  Map<String, dynamic> Info;
  if (SharedData.instance.sharedVariable == "User") {
    table_name = "users";
  } else {
    table_name = "organizers";
  }

  try {
    print(SharedData.instance.sharedVariable);
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: jsonEncode({
        'userEmail': userData[0]['email'],
        'code': code,
        'table_name': table_name,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        // Handle the signup error
        print('Verification error: ${responseData['error']}');
        return false;
      } else {
        if (table_name == "users") {
          Info = await get_user_by_email(userData[0]['email']);
          print('Email Verification successful from user');
        } else {
          Info = await get_organizer_by_email(userData[0]['email']);
          print('Email Verification successful from organizer');
        }

        await DBUserOrganizer.deleteUser(userData[0]['id']);
        print("user deleted successfully");
        var isUpdated = DBUserOrganizer.insertUser({
          'name': Info['name'],
          'role': Info['role'],
          'birth_date': Info['birth_date'],
          'location': Info['location'],
          'phone_number': Info['phone_number'],
          'email': Info['email'],
          'verified': Info['verified'],
        });
        if (isUpdated != null) {
          print("user updated successfully");
          return true;
        } else {
          print("an error happened while updating the user");
          return false;
        }

        //DBUserOrganizer.syncUsers(remote_data)

        //additional logic for login success, maybe navigating to the email verification
      }
    } else {
      // Server errors
      print('Failed to verify. Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during verify email: $e');
    return false;
  }
}

Future<bool> userlogin(Map<String, dynamic> userData) async {
  String url = '${AppConfig.backendBaseUrl}index.php';

  try {
    //Sending POST request to API endpoint
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'action': 'login',
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        // Handle the login error
        print('Login error: ${responseData['error']}');
        return false;
      } else {
        print('Login successful from user');
        int id = await DBUserOrganizer.insertUser({
          'name': userData['name'],
          'email': userData['email'],
          'verified': 1,
        });
        print("the user logged in is of id : $id");
        return true;
        //additional logic for login success, maybe navigating to the home page
      }
    } else {
      // Server error
      print('Failed. Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during login: $e');
    return false;
  }
}

Future<bool> organizerlogin(Map<String, dynamic> userData) async {
  String url = '${AppConfig.backendBaseUrl}organizer/login_signup_org.php';

  try {
    //Sending POST request to API endpoint
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'action': 'login',
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        // Handle the login error
        print('Login error: ${responseData['error']}');
        return false;
      } else {
        print('Login successful from organizer');
        int id = await DBUserOrganizer.insertUser({
          'name': userData['name'],
          'email': userData['email'],
          'verified': 1,
        });
        print("the user logged in is of id : $id");
        return true;
        //additional logic for login success, maybe navigating to the home page
      }
    } else {
      // Server error
      print('Failed. Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during login: $e');
    return false;
  }
}

//function to get the user info from remote database by his unique email
Future<Map<String, dynamic>> get_user_by_email(String useremail) async {
  String url = '${AppConfig.backendBaseUrl}index.php';

  //Sending POST request to API endpoint
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({
      'action': 'get_user_by_email',
      'email': useremail,
    }),
  );
  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['error'] != null) {
      // Handle the  error
      print('Getting info error: ${responseData['error']}');
    } else {
      print('get the user info successfuly');
      Map<String, dynamic> user = responseData['user'];
      // Handle the user data
      print('User: $user');
    }
  } else {
    // Server error
    print('Failed. Error: ${response.statusCode}');
  }
  return responseData['user'];
}

//function to get the organizer info from remote database by his unique email
Future<Map<String, dynamic>> get_organizer_by_email(String useremail) async {
  String url = '${AppConfig.backendBaseUrl}organizer/login_signup_org.php';

  //Sending POST request to API endpoint
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({
      'action': 'get_organizer_by_email',
      'email': useremail,
    }),
  );
  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['error'] != null) {
      // Handle the  error
      print('Getting info error: ${responseData['error']}');
    } else {
      print('get the user info successfuly');
      Map<String, dynamic> user = responseData['user'];
      // Handle the user data
      print('User: $user');
    }
  } else {
    // Server error
    print('Failed. Error: ${response.statusCode}');
  }
  return responseData['user'];
}
