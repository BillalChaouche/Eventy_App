import 'package:eventy/Static/AppConfig.dart';
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
