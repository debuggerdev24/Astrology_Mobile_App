class PalmReadingModel {
  TPalm leftPalm;
  TPalm rightPalm;

  PalmReadingModel({required this.leftPalm, required this.rightPalm});

  factory PalmReadingModel.fromJson(Map<String, dynamic> json) =>
      PalmReadingModel(
        leftPalm: TPalm.fromJson(json["left_palm"]),
        rightPalm: TPalm.fromJson(json["right_palm"]),
      );
}

class TPalm {
  String image;
  Summary summary;
  MountAnalysis mountAnalysis;

  TPalm({
    required this.image,
    required this.summary,
    required this.mountAnalysis,
  });

  factory TPalm.fromJson(Map<String, dynamic> json) => TPalm(
    image: json["image"],
    summary: Summary.fromJson(json["summary"]),
    mountAnalysis: MountAnalysis.fromJson(json["mount_analysis"]),
  );
}

class MountAnalysis {
  String? mountOfJupiter,
      mountOfSaturn,
      mountOfVenus,
      monthlySummary,
      mountOfSun;

  MountAnalysis({
    required this.mountOfJupiter,
    required this.mountOfSaturn,
    required this.mountOfVenus,
    required this.monthlySummary,
    required this.mountOfSun,
  });

  factory MountAnalysis.fromJson(Map<String, dynamic> json) => MountAnalysis(
    mountOfJupiter: json["mount_of_jupiter"] ?? "",
    mountOfSaturn: json["mount_of_saturn"] ?? "",
    mountOfVenus: json["mount_of_venus"] ?? "",
    monthlySummary: json["monthly_summary"] ?? "",
    mountOfSun: json["mount_of_sun"] ?? "",
  );
}

class Summary {
  String lifeline;
  String headline;
  String heartline;

  Summary({
    required this.lifeline,
    required this.headline,
    required this.heartline,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    lifeline: json["lifeline"],
    headline: json["headline"],
    heartline: json["heartline"],
  );

  Map<String, dynamic> toJson() => {
    "lifeline": lifeline,
    "headline": headline,
    "heartline": heartline,
  };
}
