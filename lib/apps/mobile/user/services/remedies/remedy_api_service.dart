import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class RemedyApiService {
  RemedyApiService._();

  static final RemedyApiService _instance = RemedyApiService._();
  static RemedyApiService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> uploadPalmFroReading({
    required FormData data,
  }) async {
    return await BaseApiHelper.instance.post(Endpoints.palmReading, data: data);
  }

  Future<Either<ApiException, Map<String, dynamic>>>
  getBirthChartDetails() async {
    return await BaseApiHelper.instance.post(
      Endpoints.getPalmAndBirthChartReading,
    );
  }
}
