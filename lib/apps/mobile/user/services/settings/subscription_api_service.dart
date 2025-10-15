import 'package:dartz/dartz.dart';

import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/network/end_points.dart';

class SubscriptionApiService {
  SubscriptionApiService._();

  static final SubscriptionApiService _instance = SubscriptionApiService._();
  static SubscriptionApiService instance = _instance;

  Future<Either<ApiException, dynamic>> getPlans() async {
    return await BaseApiHelper.instance.get(Endpoints.getSubscriptionPlans);
  }

  Future<Either<ApiException, dynamic>> getCurrentActivePlans() async {
    return await BaseApiHelper.instance.get(Endpoints.getCurrentPlan);
  }

  Future<Either<ApiException, dynamic>> initiateSubscription({
    required Map data,
  }) async {
    return await BaseApiHelper.instance.post(
      Endpoints.initiateSubscription,
      data: data,
    );
  }

  Future<Either<ApiException, dynamic>> validateSubscription({
    required Map data,
  }) async {
    return await BaseApiHelper.instance.post(
      Endpoints.validateSubscription,
      data: data,
    );
  }
}
