class RemedyModel {
  int remedyId;
  String remedyName;
  String remedyType;
  String remedyDescription;

  RemedyModel({
    required this.remedyId,
    required this.remedyName,
    required this.remedyType,
    required this.remedyDescription,
  });

  factory RemedyModel.fromJson(Map<String, dynamic> json) => RemedyModel(
    remedyId: json["remedy_id"],
    remedyName: json["remedy_name"],
    remedyType: json["remedy_type"],
    remedyDescription: json["remedy_description"],
  );
}

class RemedyDetailsModel {
  String remedyName;
  String remedyGain;
  List<String> suggestedAction;
  List<String> textInstructions;
  String spiritualMeaning;
  Mantra? mantra;

  RemedyDetailsModel({
    required this.remedyName,
    required this.remedyGain,
    required this.suggestedAction,
    required this.textInstructions,
    required this.spiritualMeaning,
    this.mantra,
  });

  factory RemedyDetailsModel.fromJson(Map<String, dynamic> json) =>
      RemedyDetailsModel(
        remedyName: json["remedy_name"],
        remedyGain: json["remedy_gain"],
        suggestedAction: List<String>.from(
          json["suggested_action"].map((x) => x),
        ),
        textInstructions: List<String>.from(
          json["text_instructions"].map((x) => x),
        ),
        spiritualMeaning: json["spiritual_meaning"],
        mantra: json["mantra"] != null ? Mantra.fromJson(json["mantra"]) : null,
      );
}

class Mantra {
  int id;
  String name, audio, text, meaning;

  Mantra({
    required this.id,
    required this.name,
    required this.audio,
    required this.text,
    required this.meaning,
  });

  factory Mantra.fromJson(Map<String, dynamic> json) => Mantra(
    id: json["id"],
    name: json["name"],
    audio: json["audio"],
    text: json["text"],
    meaning: json["meaning"],
  );
}
