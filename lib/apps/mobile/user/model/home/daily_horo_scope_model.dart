class DailyHoroScopeModel {
  DateTime date;
  String karmaAction;
  String karmaCaution;
  String rulingPlanet;
  String oneLineSummary;
  DetailedPredictions detailedPredictions;
  String nakshatra;

  DailyHoroScopeModel({
    required this.date,
    required this.karmaAction,
    required this.karmaCaution,
    required this.rulingPlanet,
    required this.oneLineSummary,
    required this.detailedPredictions,
    required this.nakshatra,
  });

  factory DailyHoroScopeModel.fromJson(Map<String, dynamic> json) =>
      DailyHoroScopeModel(
        date: DateTime.parse(json["date"]),
        karmaAction: json["karma_action"],
        karmaCaution: json["karma_caution"],
        rulingPlanet: json["ruling_planet"],
        oneLineSummary: json["one_line_summary"],
        detailedPredictions: DetailedPredictions.fromJson(
          json["detailed_predictions"],
        ),
        nakshatra: json["nakshatra"],
      );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "karma_action": karmaAction,
    "karma_caution": karmaCaution,
    "ruling_planet": rulingPlanet,
    "one_line_summary": oneLineSummary,
    "detailed_predictions": detailedPredictions.toJson(),
    "nakshatra": nakshatra,
  };
}

class DetailedPredictions {
  String career;
  String relationships;
  String health;
  String finance;
  String spirituality;

  DetailedPredictions({
    required this.career,
    required this.relationships,
    required this.health,
    required this.finance,
    required this.spirituality,
  });

  factory DetailedPredictions.fromJson(Map<String, dynamic> json) =>
      DetailedPredictions(
        career: json["career"],
        relationships: json["relationships"],
        health: json["health"],
        finance: json["finance"],
        spirituality: json["spirituality"],
      );

  Map<String, dynamic> toJson() => {
    "career": career,
    "relationships": relationships,
    "health": health,
    "finance": finance,
    "spirituality": spirituality,
  };
}
