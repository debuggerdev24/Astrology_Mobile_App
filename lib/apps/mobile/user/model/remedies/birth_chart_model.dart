class BirthChartModel {
  BirthChartSummary birthChartSummary;
  String palmSummary;
  String interpretation;
  String remediesCta;

  BirthChartModel({
    required this.birthChartSummary,
    required this.palmSummary,
    required this.interpretation,
    required this.remediesCta,
  });

  factory BirthChartModel.fromJson(Map<String, dynamic> json) =>
      BirthChartModel(
        birthChartSummary: BirthChartSummary.fromJson(
          json["birth_chart_summary"],
        ),
        palmSummary: json["palm_summary"],
        interpretation: json["interpretation"],
        remediesCta: json["remedies_cta"],
      );

  Map<String, dynamic> toJson() => {
    "birth_chart_summary": birthChartSummary.toJson(),
    "palm_summary": palmSummary,
    "interpretation": interpretation,
    "remedies_cta": remediesCta,
  };
}

class BirthChartSummary {
  String moonSign;
  String dasha;
  String summary;

  BirthChartSummary({
    required this.moonSign,
    required this.dasha,
    required this.summary,
  });

  factory BirthChartSummary.fromJson(Map<String, dynamic> json) =>
      BirthChartSummary(
        moonSign: json["moon_sign"],
        dasha: json["dasha"],
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
    "moon_sign": moonSign,
    "dasha": dasha,
    "summary": summary,
  };
}
