import 'package:dartz/dartz.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class MantraApiService {
  MantraApiService._();

  static final MantraApiService _instance = MantraApiService._();
  static MantraApiService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> getMantraHistory() async {
    return await BaseApiHelper.instance.get(Endpoints.getMantraHistory);
  }
}
