import 'package:astrology_app/apps/mobile/user/model/settings/premium_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/services/settings/premium_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/logger.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPlanModel>? plans;

  Future<void> getSubscriptionPlans() async {
    final result = await SubscriptionApiService.instance.getPlans();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        plans = (r["data"] as List)
            .map((e) => SubscriptionPlanModel.fromJson(e))
            .toList();
        notifyListeners();
      },
    );
  }
}
