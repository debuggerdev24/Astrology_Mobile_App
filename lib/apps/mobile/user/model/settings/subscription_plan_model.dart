class SubscriptionPlanModel {
  int id;
  String plan;
  String price;
  List<String> features;
  String durationLabel;

  SubscriptionPlanModel({
    required this.id,
    required this.plan,
    required this.price,
    required this.features,
    required this.durationLabel,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json["id"],
        plan: json["plan"],
        price: json["price"],
        features: List<String>.from(json["features"].map((x) => x)),
        durationLabel: json["duration_label"],
      );
}

class ActiveSubscriptionPlanModel {
  String plan, startDate, price, endDate;
  List<String> features;
  double durationMonths;

  ActiveSubscriptionPlanModel({
    required this.plan,
    required this.price,
    required this.features,
    required this.durationMonths,
    required this.startDate,
    required this.endDate,
  });

  factory ActiveSubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      ActiveSubscriptionPlanModel(
        plan: json["plan"],
        price: json["price"],
        features: List<String>.from(json["features"].map((x) => x)),
        durationMonths: json["duration_months"]?.toDouble(),
        startDate: json["start_date"],
        endDate: json["end_date"] ?? "null",
      );
}
