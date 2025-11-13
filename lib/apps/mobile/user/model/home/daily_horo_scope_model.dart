class DailyHoroScopeModel {
  DateTime date;
  String karmaAction, karmaCaution, rulingPlanet, oneLineSummary, nakshatra;
  DetailedPredictions detailedPredictions;

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
  String familyEnergy,
      powerPeriods,
      emotionalEnergy,
      learningOutlook,
      spiritualEnergy,
      planetarySnapshot,
      summary;

  DetailedPredictions({
    required this.familyEnergy,
    required this.powerPeriods,
    required this.emotionalEnergy,
    required this.learningOutlook,
    required this.spiritualEnergy,
    required this.planetarySnapshot,
    required this.summary,
  });

  factory DetailedPredictions.fromJson(Map<String, dynamic> json) =>
      DetailedPredictions(
        familyEnergy: json["family_energy"] ?? "",
        powerPeriods: json["power_periods"],
        emotionalEnergy: json["emotional_energy"],
        learningOutlook: json["learning_outlook"],
        spiritualEnergy: json["spiritual_energy"],
        planetarySnapshot: json["planetary_snapshot"],
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
    "career": familyEnergy,
    "relationships": powerPeriods,
    "health": emotionalEnergy,
    "finance": learningOutlook,
    "spirituality": spiritualEnergy,
  };
}
