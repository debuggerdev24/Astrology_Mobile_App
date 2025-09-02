class MantraHistoryModel {
  int id;
  String name,
      meaning,
      audioFile,
      textContent,
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
        meaning: json["meaning"],
        audioFile: json["audio_file"],
        textContent: json["text_content"],
        availability: json["availability"],
        updatedAt: json["updated_at"],
        status: json["status"],
        scheduledDate: json["scheduled_date"],
        mantraType: json["mantra_type"],
        planetName: json["planet_name"],
        dashaName: json["dasha_name"],
      );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "name": name,
  //   "meaning": meaning,
  //   "audio_file": audioFile,
  //   "text_content": textContent,
  //   "availability": availability,
  //   "updated_at": updatedAt.toIso8601String(),
  //   "status": status,
  //   "scheduled_date": "${scheduledDate.year.toString().padLeft(4, '0')}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}",
  //   "mantra_type": mantraType,
  //   "planet_name": planetName,
  //   "dasha_name": dashaName,
  // };
}
