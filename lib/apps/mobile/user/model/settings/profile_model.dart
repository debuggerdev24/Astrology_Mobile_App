class UserProfileModel {
  String fullName;
  String birthDate;
  String birthTime;
  String birthPlace;
  String currentLocation;
  String palmImageLeft;
  String palmImageRight;

  UserProfileModel({
    required this.fullName,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.currentLocation,
    required this.palmImageLeft,
    required this.palmImageRight,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        fullName: json["full_name"],
        birthDate: json["birth_date"],
        birthTime: json["birth_time"],
        birthPlace: json["birth_place"],
        currentLocation: json["current_location"],
        palmImageLeft: json["palm_image_left"] ?? "",
        palmImageRight: json["palm_image_right"] ?? "",
      );

  // Map<String, dynamic> toJson() => {
  //   "full_name": fullName,
  //   "birth_date":
  //       "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
  //   "birth_time": birthTime,
  //   "birth_place": birthPlace,
  //   "current_location": currentLocation,
  //   "palm_image_left": palmImageLeft,
  //   "palm_image_right": palmImageRight,
  // };
}
