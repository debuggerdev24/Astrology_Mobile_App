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

  Future<Either<ApiException, Map<String, dynamic>>> getRemedies() async {
    return await BaseApiHelper.instance.post(
      Endpoints.getBasicRemedies,
      data: {"category": "dasha"},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getRemedyDetails({
    required String remedyId,
  }) async {
    return await BaseApiHelper.instance.get(
      Endpoints.getRemedyDetails(remedyId: remedyId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> createReminder({
    required Map data,
  }) async {
    return await BaseApiHelper.instance.post(
      Endpoints.createReminder,
      data: data,
    );
  }
}

//It's just warning not any alert or any thing. its just inform us that we can modify data and need to just dismiss no need to worry about that
