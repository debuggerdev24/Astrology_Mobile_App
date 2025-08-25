import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as form_data;

import '../../../../core/network/base_api_helper.dart';
import '../../../../core/network/end_points.dart';

class UserProfileService {
  UserProfileService._();

  static final UserProfileService _instance = UserProfileService._();
  static UserProfileService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> updateProfile({
    required String fullName,
    required String birthDate,
    required String birthTime,
    required String birthPlace,
    required String currentLocation,
    required String? leftPalmImage,
    required String? rightPalmImage,
  }) async {
    return await BaseApiHelper.instance.patch(
      Endpoints.editProfile,
      data: form_data.FormData.fromMap({
        "full_name": fullName,
        "birth_date": birthDate,
        "birth_time": birthTime,
        "birth_place": birthPlace,
        "current_location": currentLocation,
        if (leftPalmImage != null)
          "palm_image_left": await MultipartFile.fromFile(leftPalmImage),
        if (rightPalmImage != null)
          "palm_image_right": await MultipartFile.fromFile(rightPalmImage),
      }),
    );
  }

  Future<Either<ApiException, dynamic>> getProfile() async {
    return await BaseApiHelper.instance.get(Endpoints.getProfile);
  }
}
