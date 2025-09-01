import 'package:astrology_app/apps/mobile/user/model/settings/subscription_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/services/settings/subscription_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/logger.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPlanModel>? subscriptionPlans;
  ActiveSubscriptionPlanModel? activeSubscriptionPlan;

  Future<void> getSubscriptionPlans() async {
    final result = await SubscriptionApiService.instance.getPlans();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        subscriptionPlans = (r["data"] as List)
            .map((e) => SubscriptionPlanModel.fromJson(e))
            .toList();
        notifyListeners();
      },
    );
  }

  bool isActivePlanLoading = true;
  Future<void> getActiveSubscriptionPlan() async {
    activeSubscriptionPlan = null;
    isActivePlanLoading = true;
    notifyListeners();
    final result = await SubscriptionApiService.instance
        .getCurrentActivePlans();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        activeSubscriptionPlan = ActiveSubscriptionPlanModel.fromJson(
          r["data"],
        );
        isActivePlanLoading = false;
        notifyListeners();
      },
    );
  }
}
