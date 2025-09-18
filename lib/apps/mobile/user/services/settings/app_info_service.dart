import 'package:dartz/dartz.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class AppInfoService {
  AppInfoService._();
  static final AppInfoService _instance = AppInfoService._();
  static AppInfoService instance = _instance;

  Future<Either<ApiException, dynamic>> getTermsAndCondition() async {
    return await BaseApiHelper.instance.get(Endpoints.getTermsAndCondition);
  }

  Future<Either<ApiException, dynamic>> getFaq() async {
    return await BaseApiHelper.instance.get(Endpoints.getFaq);
  }
}
