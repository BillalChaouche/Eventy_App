import 'package:eventy/EndPoints/userBookedEndpoints.dart';
import 'package:eventy/models/UserBooked.dart';
import 'package:flutter/material.dart';

class UserBookedProvider extends ChangeNotifier {
  List<UserBooked> usersBooked = [];
  bool noData = false;

  Future<List<dynamic>?> getUsers(int eventID) async {
    try {
      List<dynamic>? maps = await getUserBooked(eventID);

      usersBooked = convertToEventsList(maps);
      if (usersBooked.isEmpty) {
        noData = true;
      } else {
        noData = false;
      }
      print(usersBooked);
      notifyListeners();
      return maps; // Return the fetched data if needed
    } catch (e) {
      return null;
    }
  }

  List<UserBooked> convertToEventsList(List<dynamic>? maps) {
    if (maps == null) return []; // Handling null case
    return maps.map((map) {
      return UserBooked(
        map['user_id'] as int,
        map['event_id'] as int,
        map['name'] as String,
        map['photo_path'] != null
            ? map['photo_path'] as String
            : "", // Assign empty string when null
        map['booked_date'] != null ? map['booked_date'] as String : "0",
        map['code'] != null ? BigInt.parse(map['code']) : BigInt.zero,
        map['accepted'] != null ? map['accepted'] as int : 0,
        map['scanned'] != null ? map['scanned'] as int : 0,
        // Convert category to a list
      );
    }).toList();
  }

  Future<void> acceptUser(id) async {
    UserBooked user = usersBooked.firstWhere((user) => user.id == id);
    bool resultServer = await acceptUserBooked(user.eventId, user.id);
    if (resultServer) {
      user.accepted = 1;
      notifyListeners();
    }
  }

  Future<bool> userPresent(code, eventID) async {
    int? id = await userBookedPresent(code, eventID);
    if (id != null) {
      UserBooked user = usersBooked.firstWhere((user) => user.id == id);
      user.present = 1;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
