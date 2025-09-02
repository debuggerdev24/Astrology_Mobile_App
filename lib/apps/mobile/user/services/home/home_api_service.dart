import 'package:dartz/dartz.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class HomeApiService {
  HomeApiService._();

  static final HomeApiService _instance = HomeApiService._();
  static HomeApiService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> getMoonDasha() async {
    return await BaseApiHelper.instance.post(Endpoints.getMoonDasha);
  }

  Future<Either<ApiException, Map<String, dynamic>>> getDailyHoroScope() async {
    return await BaseApiHelper.instance.post(Endpoints.getDailyHoroScope);
  }

  Future<Either<ApiException, Map<String, dynamic>>> getTodayMantra() async {
    return await BaseApiHelper.instance.get(Endpoints.getTodayMantra);
  }
}
