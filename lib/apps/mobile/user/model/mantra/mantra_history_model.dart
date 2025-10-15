class MantraHistoryModel {
  int id;
  String? audioFile, textContent;
  String name,
      meaning,
      availability,
      updatedAt,
      status,
      scheduledDate,
      mantraType,
      planetName;
  dynamic dashaName;

  MantraHistoryModel({
    required this.id,
    required this.name,
    required this.meaning,
    required this.audioFile,
    required this.textContent,
    required this.availability,
    required this.updatedAt,
    required this.status,
    required this.scheduledDate,
    required this.mantraType,
    required this.planetName,
    required this.dashaName,
  });

  factory MantraHistoryModel.fromJson(Map<String, dynamic> json) =>
      MantraHistoryModel(
        id: json["id"],
        name: json["name"],
        meaning: json["meaning"] ?? "Meaning",
        audioFile: json["audio_file"],
        textContent: (json["text_content"] as String).isEmpty
            ? null
            : json["text_content"],
        availability: json["availability"],
        updatedAt: json["updated_at"],
        status: json["status"],
        scheduledDate: json["scheduled_date"],
        mantraType: json["mantra_type"],
        planetName: json["planet_name"] ?? "Planet Name",
        dashaName: json["dasha_name"],
      );
}
