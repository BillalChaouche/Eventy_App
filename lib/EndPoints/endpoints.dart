import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>?> endpoint_api_get_categories() async {
  //This can be improved by placing API endpoints into a constant dart file
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.196.162/eventyBackend/index.php/?action=categories.get'));
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
