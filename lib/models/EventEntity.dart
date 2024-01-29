//import 'package:eventy/entities/OrganizerEntity.dart';

class EventEntity {
  late int id;
  late String title;
  late String location;
  late String time;
  late String date;
  late String imgPath;
  late int attendcees;
  late String description;
  late int saved;
  late int booked;
  late int accepted;
  late String code;
  late String organizer;
  late List categories;
  late int remote_id;

  EventEntity(
      this.id,
      this.title,
      this.location,
      this.date,
      this.time,
      this.imgPath,
      this.attendcees,
      this.description,
      this.saved,
      this.booked,
      this.accepted,
      this.code,
      this.organizer,
      this.categories,
      this.remote_id);

  void toggleSaved() {
    saved = (saved == 0) ? 1 : 0;
  }

  void toggleBooked() {
    booked = (booked == 0) ? 1 : 0;
  }
}
