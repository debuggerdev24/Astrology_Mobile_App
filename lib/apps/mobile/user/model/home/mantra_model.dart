class MantraModel {
  int id;
  String name;
  dynamic meaning;
  String? audioFile;
  String? textContent;
  String availability;
  DateTime lastUpdated;
  String status;
  DateTime scheduledDate;

  MantraModel({
    required this.id,
    required this.name,
    required this.meaning,
    this.audioFile,
    this.textContent,
    required this.availability,
    required this.lastUpdated,
    required this.status,
    required this.scheduledDate,
  });

  factory MantraModel.fromJson(Map<String, dynamic> json) => MantraModel(
    id: json["id"],
    name: json["name"],
    meaning: json["meaning"],
    audioFile: json["audio_file"],
    textContent: (json["text_content"] as String).isEmpty
        ? null
        : json["text_content"],
    availability: json["availability"],
    lastUpdated: DateTime.parse(json["updated_at"]),
    status: json["status"],
    scheduledDate: DateTime.parse(json["scheduled_date"]),
  );
}
