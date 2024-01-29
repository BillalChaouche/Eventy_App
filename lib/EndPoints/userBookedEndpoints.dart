import 'dart:convert';
import 'package:eventy/Static/AppConfig.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>?> getUserBooked(int eventID) async {
  print("inside the funct");
  String url = '${AppConfig.backendBaseUrl}organizer/operations_event.php';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'action': 'getUserBooked',
        'eventID': eventID,
      }),
    );

    print("requested the funct  ${response.statusCode.toInt()}");

    if (response.statusCode == 200) {
      List<dynamic> ret = jsonDecode(response.body);
      print(ret);
      return ret;
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return null;
  }
  return null;
}

Future<bool> acceptUserBooked(int eventID, int userID) async {
  print("inside the function");
  print(userID);
  print(eventID);

  String url = '${AppConfig.backendBaseUrl}organizer/operations_event.php';
  print("going to send to$url");

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'action': 'acceptUser',
        'eventID': eventID,
        'userID': userID,
      }),
    );

    print("requested the function  ${response.body}");

    if (response.statusCode == 200) {
      return true;
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return false;
  }

  return false;
}

Future<int?> userBookedPresent(int code, int eventID) async {
  print("this is the code ${code}");
  print("this is the eventID ${eventID}");
  print("inside the funct userBookedPresent");
  String url = '${AppConfig.backendBaseUrl}organizer/operations_event.php';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'action': 'userScan',
        'code': code,
        'eventID': eventID,
      }),
    );

    print("requested the funct  ${response.statusCode.toInt()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> ret = jsonDecode(response.body);
      print(ret['user_id']);
      return ret['user_id'];
    }
  } catch (error) {
    print("Error: ${error.toString()}");
    return null;
  }
  return null;
}
