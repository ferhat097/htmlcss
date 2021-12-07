// ignore_for_file: file_names

class PresenceModel {
  PresenceModel({
    required this.online,
    required this.date,
  });

  bool online;
  int date;

  factory PresenceModel.fromJson(Map<String, dynamic> json) => PresenceModel(
        online: json["online"],
        date: json["date"],
      );
}
