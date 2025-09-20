import 'package:dartz/dartz.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class AppInfoService {
  AppInfoService._();
  static final AppInfoService _instance = AppInfoService._();
  static AppInfoService instance = _instance;

  Future<Either<ApiException, dynamic>> getPrivacyPolicy() async {
    return await BaseApiHelper.instance.get(Endpoints.getSpiritualDisclaimers);
  }

  Future<Either<ApiException, dynamic>> getTermsAndCondition() async {
    return await BaseApiHelper.instance.get(Endpoints.getTermsAndCondition);
  }

  Future<Either<ApiException, dynamic>> getFaqs() async {
    return await BaseApiHelper.instance.get(Endpoints.getFaq);
  }

  Future<Either<ApiException, dynamic>> getSpiritualDisclaimers() async {
    return await BaseApiHelper.instance.get(Endpoints.getSpiritualDisclaimers);
  }
}
