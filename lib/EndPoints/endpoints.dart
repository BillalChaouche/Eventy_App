import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>?> endpoint_api_get_categories() async {
  //This can be improved by placing API endpoints into a constant dart file
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.35.186/flutter_test_backend/index.php/?action=categories.get'));
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> ret =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return ret;
    }
  } catch (error) {
    print("Error ${error.toString()}");
    return null;
  }
  return null;
}

Future<bool> signup(Map<String, dynamic> userData) async {
  await DBUserOrganizer.insertUser({
    'name': userData['name'],
    'email': userData['email'],
    'verified': 0,
  });
  String url = 'http://192.168.35.186/flutter_test_backend/index.php';

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
      print("there is a result");
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
  String url = 'http://192.168.35.186/flutter_test_backend/verifyemail.php';

  try {
    final response = await http.post(
      //Sending POST request to API endpoint
      Uri.parse(url),
      body: jsonEncode({
        'userEmail': userData[0]['email'],
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        // Handle the signup error
        print('Verification error: ${responseData['error']}');
      } else if (responseData['success'] != null) {
        print('Email Verification successful from client');

        Map<String, dynamic> userInfo =
            await get_user_by_email(userData[0]['email']);
        await DBUserOrganizer.deleteUser(userData[0]['id']);
        print("user deleted successfully");
        var isUpdated = DBUserOrganizer.insertUser({
          'name': userInfo['name'],
          'role': userInfo['role'],
          'birth_date': userInfo['birth_date'],
          'location': userInfo['location'],
          'phone_number': userInfo['phone_number'],
          'email': userInfo['email'],
          'verified': userInfo['verified'],
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
  return false;
}

Future<bool> login(Map<String, dynamic> userData) async {
  String url = 'http://192.168.35.186/flutter_test_backend/index.php';

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
        print('Login successful from client');
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
  String url = 'http://192.168.35.186/flutter_test_backend/index.php';

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
